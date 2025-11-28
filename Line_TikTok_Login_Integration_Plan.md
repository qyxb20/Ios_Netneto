# Ios_netneto 第三方登录集成方案（LINE & TikTok）

> 目标：在不影响现有账号/验证码登录流程的前提下，为 `Netneto` iOS 客户端增加 LINE 登录与海外抖音（TikTok）登录入口。本文档仅提供实施方案与步骤，暂不修改任何代码。

---

## 1. 现状与总体思路
- 工程类型：Objective-C，最低 iOS 版本 11+（需再次确认 Xcode 工程配置）。
- 现有登录：账号密码登录、验证码登录（见 `Login/LoginViewController`）。
- 网络层：`Network/NetWorkRequest` + `NetwortTool` 封装接口；登录成功后由 `account` 单例加载用户信息、资源、Socket 链接。
- 目标：新增两种社交登录入口，统一走后端鉴权，最终仍然落地到本地的 `account` 数据模型。

实施分三块：SDK 引入、客户端流程改造、后端协同。

---

## 2. 先决条件

### 2.1 账号与配置
| 平台 | 需要准备 | 说明 |
| --- | --- | --- |
| LINE | 开发者账号、Provider、LINE Login Channel、Channel ID、Channel Secret、Callback URL | Callback URL 建议使用 Universal Link；Bundle ID 必须与 `jp.co.netneto`（需确认实际值）一致 |
| TikTok | TikTok for Developers 账号、App、Client Key(App ID)、Client Secret、Redirect URI、Universal Link | TikTok 登录要求 https 回调域名且需通过审核 |

### 2.2 法务与合规
- 更新隐私政策，说明会使用 LINE/TikTok 登录并收集基础资料。
- 确认是否需要在 App Store Connect 中声明第三方登录能力。

---

## 3. 依赖与工程配置

### 3.1 Podfile 调整
```ruby
target 'Netneto' do
  # ... 原有依赖 ...
  pod 'LineSDK', '~> 5.10'
  pod 'TikTokOpenSDK', '~> 5.1'
end
```
- 执行 `pod repo update && pod install`
- 若 TikTok SDK 版本变动，需以官方文档为准确认最新兼容版本。

### 3.2 Info.plist 调整

1. **URL Scheme**
   - LINE: `line3rdp.<BundleID>`
   - TikTok: `tiktok<CLIENT_KEY>`（CLIENT_KEY 即 TikTok App 的 Client Key，大小写需与官网一致）

2. **LSApplicationQueriesSchemes**
   ```xml
   <array>
     <!-- 现有字段 -->
     <string>lineauth</string>
     <string>line</string>
     <string>tiktok</string>
     <string>snssdk1233</string> <!-- TikTok iOS 端使用的 URL Scheme 前缀，具体数值以官方文档为准 -->
   </array>
   ```

3. **TikTok 专用键值**（若使用 TikTokOpenSDK >= 5.x）
   ```xml
   <key>TikTokAppID</key>
   <string>{CLIENT_KEY}</string>
   <key>TikTokUniversalLink</key>
   <string>https://your.domain.com/tiktok/oauth/</string>
   <key>TikTokAuthList</key>
   <array>
     <string>user.info.basic</string>
     <string>user.info.profile</string>
     <string>user.info.stats</string>
     <!-- 根据业务需要选择授权范围 -->
   </array>
   <key>TikTokRedirectURI</key>
   <string>https://your.domain.com/tiktok/oauth/</string>
   ```

4. **Universal Links / Associated Domains**
   - 若使用 Universal Link 作为回调（推荐），需在 `Signing & Capabilities` 中开启 `Associated Domains`，并添加：
     - `applinks:your.line.domain`
     - `applinks:your.tiktok.domain`
   - 对应域名需部署 `apple-app-site-association` 文件。

### 3.3 Swift SDK 与 Objective-C 工程的桥接
- **为何需要**：LINE/TikTok 官方仅维护 Swift 版 SDK，但已通过 `@objc` 暴露接口，Objective-C 工程可直接调用。
- **开启 Swift 支持**：若项目中尚无 `.swift` 文件，可创建一个空的 `Dummy.swift` 并选择“Create Bridging Header”，确认使用现有的 `Netneto-Bridging-Header.h`。
- **Bridging Header**：通常无需在桥接头里额外导入（SDK 会生成 `*-Swift.h`），但若需引用 Swift 辅助工具类，可在 `Netneto-Bridging-Header.h` 中 `#import`。
- **Objective-C 中引用**：在使用处（例如 `AppDelegate.m`、`LoginViewController.m`）添加：
  ```objc
  #import <LineSDK/LineSDK-Swift.h>
  #import <TikTokOpenSDK/TikTokOpenSDK-Swift.h>
  ```
  编译器会自动生成对应的 Swift 接口头文件；若提示找不到，确认 `Build Settings` → `Defines Module` 为 `Yes`。
- **命名空间注意事项**：部分类型前缀可能与官方文档略有差异（例如 `LineSDKLoginManager` 在 Swift 中为 `LoginManager`），可在 Xcode 的“Jump to Definition”中查看具体暴露名称。
- **与 Swift UI 兼容**：无需将现有业务转为 Swift，只在需要使用 SDK 的位置调用即可。

---

## 4. AppDelegate 规划

> 主要文件：`Netneto/AppDelegate.m`

1. **引入头文件**
   ```objc
   #import <LineSDK/LineSDK.h>
   #import <TikTokOpenSDK/TikTokOpenSDKAuth.h>
   #import <TikTokOpenSDK/TikTokOpenSDKApplicationDelegate.h>
   ```

2. **初始化**（`application:didFinishLaunchingWithOptions:`）
   - LINE：`[[LineSDKLogin sharedInstance] setupWithChannelID:LINE_CHANNEL_ID universalLinkURL:[NSURL URLWithString:lineUniversalLink]];`
   - TikTok：通常无需显式初始化，但需确保 `TikTokAppID` 已在 Info.plist 配好。

3. **回调处理**
   - 实现 `application:openURL:options:`，按顺序判断 
     ```objc
     if ([[LineSDKLogin sharedInstance] handleOpenURL:url]) return YES;
     if ([[TikTokOpenSDKApplicationDelegate sharedInstance] application:app openURL:url options:options]) return YES;
     ```
   - 若使用 Universal Link，还需实现 `application:continueUserActivity:restorationHandler:`，调用 `LineSDKLogin` 与 `TikTokOpenSDKApplicationDelegate` 对应方法。

4. **SceneDelegate**
   - 若工程启用了 SceneDelegate，同步实现 `scene:openURLContexts:` 与 `scene:continueUserActivity:` 类似逻辑。

---

## 5. 网络层与数据流改造

### 5.1 NetwortTool 新增接口
- `+ (void)loginWithLineToken:(NSDictionary *)parm ...;`
- `+ (void)loginWithTikTokCode:(NSDictionary *)parm ...;`

> 约定参数：
> - Line：`lineAccessToken` / `idToken`（SDK 返回） + `loginUuid`
> - TikTok：`authCode` + `scopes` + `loginUuid`

实现：
```objc
[NetWorkRequest postWithUrl:RequestURL(@"/login/line") parameters:parm success:success failure:failure];
[NetWorkRequest postWithUrl:RequestURL(@"/login/tiktok") parameters:parm success:success failure:failure];
```

### 5.2 数据接入
- 保持与传统登录一致：成功后解析 `userModel`、`UserInfoModel`，写入 `account` 单例，并触发现有通知（`uploadUserInfo` 等）。
- 若后端返回 refreshToken/过期时间，需与现有 token 管理策略兼容（确认 `account` 模块实现）。

---

## 6. LoginViewController UI/交互规划

> 文件：`Login/LoginViewController.(xib|m)`

1. **新增按钮**
   - 位置：现有 "登录" 按钮下方或验证码/注册链接区域之间。
   - 样式：
     - LINE：绿色背景 `#00C300`，白色文字 “LINEでログイン”。
     - TikTok：黑色背景，白色文字 “TikTokでログイン”，可配合 TikTok Logo。
   - iPad 模式下是否展示需与产品确认。

2. **Action 逻辑**
   - `lineLoginTapped`：
     ```objc
     LineSDKLoginRequest *request = [[LineSDKLoginRequest alloc] initWithScopes:@[LineSDKLoginPermission_profile]];
     [[LineSDKLogin sharedInstance] startLoginWithRequest:request completion:^(LineSDKLoginResult *result, NSError *error) {
        // 成功：取 accessToken / ID Token
        // 失败：提示 + 记录埋点
     }];
     ```
   - `tiktokLoginTapped`：
     ```objc
     TikTokOpenSDKAuthRequest *request = [TikTokOpenSDKAuthRequest new];
     request.permissions = @[@"user.info.basic", @"user.info.profile"];
     request.state = [NSString getUUID];
     request.redirectURI = TikTokRedirectURI;
     request.fromViewController = self;
     [request sendAuthRequestWithBlock:^(TikTokOpenSDKAuthResponse * _Nonnull response) {
        // 成功：获取 authCode & state
     }];
     ```

3. **网络串联**
   - 成功回调里组装参数调用 `NetwortTool` 新方法。
   - 同步展示 `HudView` Loading，失败提示沿用 `ToastShow`。

4. **埋点与风控**
   - 记录第三方登录入口、失败原因。
   - 若后端需要图形验证码/风控参数，在调用前补充。

---

## 7. 后端协作要点

1. **接口设计**
   - `/login/line`：校验 LINE ID Token（通过 LINE Verify API），如合法则匹配/创建用户，返回统一登录结果。
   - `/login/tiktok`：使用 `authCode` + `Client Secret` 交换 Access Token，再拉取用户 Profile，匹配/创建用户。

2. **数据落盘**
   - 维持用户系统中第三方账号与本地账号的绑定关系。
   - 处理首次登录绑定手机号/邮箱等补充信息流程（若有）。

3. **安全**
   - 校验 `state` 防止 CSRF。
   - Access Token 不在客户端长期保存，必要时只存服务器生成的登录凭证。

---

## 8. 测试计划

### 8.1 功能测试
- LINE 登录成功 / 取消 / 失败（无 LINE 客户端时的 Web 登录）。
- TikTok 登录成功 / 取消 / 失败（含授权范围拒绝）。
- 登录后账号数据加载、Socket 连接、Tab 切换是否正常。
- 已登录状态下再次点击第三方登录的处理逻辑。

### 8.2 边界测试
- 网络异常、超时、DNS 错误。
- state 校验失败。
- 旧版本客户端升级兼容性（关注本地缓存）。

### 8.3 回归
- 传统账号/验证码登录流程。
- 退出登录与重新登录。

---

## 9. 发布与监控
- 新增埋点：第三方登录按钮点击、授权页面展示、成功/失败原因。
- 日志：关键节点写入本地日志并上传（便于定位 SDK 问题）。
- 灰度策略：可通过服务器下发开关控制按钮展示，逐步放量。

---

## 10. 时间评估（粗略）
| 步骤 | 预估人日 |
| --- | --- |
| 准备账号、配置 & 对接后端接口 | 1.0 |
| SDK 接入、工程配置 | 0.5 |
| Login UI/逻辑开发 | 1.0 |
| 联调与测试 | 1.0 |
| 预留问题修复 | 0.5 |

---

## 11. 参考文档
- LINE Login iOS Objective-C 指南：https://developers.line.biz/en/docs/line-login-sdks/ios-sdk/objective-c/
- TikTok Open Platform iOS Guide：https://developers.tiktok.com/doc/login-kit-implement/
- Apple Universal Links：https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html

---

> 完成本方案评审后，可按章节逐步实施；若 SDK 或接口规范更新，请以官方文档为准同步调整。
