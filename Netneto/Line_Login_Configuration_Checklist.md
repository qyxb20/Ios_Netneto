# Line 第三方登录配置清单

## 📋 配置检查清单

### ✅ 1. Line Developers Console 配置

**访问地址**: https://developers.line.biz/console/

**需要配置的内容**:
- **Channel ID**: `2008407504` ✅
- **iOS bundle ID**: `netneto.co.jp` ✅
- **Callback URL (Universal Link)**: `https://netneto.co.jp/oauth/callback/line` ✅

**配置步骤**:
1. 登录 Line Developers Console
2. 选择 Channel ID: `2008407504`
3. 进入 "LINE Login" → "Settings"
4. 在 "Callback URL" 部分添加: `https://netneto.co.jp/oauth/callback/line`
5. 保存并等待 5-10 分钟让配置生效

---

### ✅ 2. 应用配置 (Info.plist)

**文件路径**: `Netneto/Info.plist`

**当前配置**:
```xml
<key>LineChannelID</key>
<string>2008407504</string> ✅

<key>LineUniversalLinkURL</key>
<string>https://netneto.co.jp/oauth/callback/line</string> ✅

<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>line.login</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>line3rdp.2008407504</string> ✅
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>lineauth</string> ✅
    <string>line</string> ✅
</array>
```

**状态**: ✅ 所有配置正确

---

### ✅ 3. Associated Domains 配置 (Entitlements)

**文件路径**: `Netneto/Netneto.entitlements`

**当前配置**:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:netneto.co.jp</string> ✅
</array>
```

**状态**: ✅ 配置正确

**注意**: 
- 格式必须是 `applinks:` 开头
- 后面跟域名（不带 `https://` 和路径）
- 域名必须与服务器域名匹配

---

### ✅ 4. 服务器配置 (apple-app-site-association)

**文件路径**: `https://netneto.co.jp/.well-known/apple-app-site-association`

**当前配置**:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "MR7PRB2YBH.netneto.co.jp",
        "paths": [
          "/oauth/callback/line*"
        ]
      }
    ]
  }
}
```

**验证结果**:
- ✅ 文件可访问
- ✅ Content-Type: `application/json`
- ✅ appID 格式正确: `MR7PRB2YBH.netneto.co.jp` (TeamID.BundleID)
- ✅ paths 配置正确: `["/oauth/callback/line*"]`

**重要提示**:
- appID 格式: `TeamID.BundleID`
  - Team ID: `MR7PRB2YBH` (10位字母数字，来自 Xcode)
  - Bundle ID: `netneto.co.jp`
  - ❌ 不要使用 Apple ID (数字格式，如 `6737018234`)
- paths 格式: `["/oauth/callback/line*"]`
  - 大小写敏感
  - `*` 表示匹配所有以该路径开头的 URL

---

### ✅ 5. 应用代码配置

#### 5.1 AppDelegate.m - Line SDK 初始化

**配置位置**: `AppDelegate.m` → `configureLineSDK`

**当前配置**:
```objc
[manager setupWithChannelID:channelID universalLinkURL:universalLinkURL];
```

**参数**:
- Channel ID: `2008407504` ✅
- Universal Link URL: `https://netneto.co.jp/oauth/callback/line` ✅

**状态**: ✅ 配置正确

---

#### 5.2 AppDelegate.m - Universal Link 回调处理

**方法**: `application:continueUserActivity:restorationHandler:`

**当前配置**:
```objc
if ([webpageURL.host isEqualToString:@"netneto.co.jp"] && 
    [webpageURL.path hasPrefix:@"/oauth/callback/line"]) {
    // 处理 Universal Link 回调
}
```

**状态**: ✅ 配置正确

---

#### 5.3 LoginViewController.m - Line 登录按钮

**配置位置**: `LoginViewController.m` → `lineLoginTapped`

**当前配置**:
```objc
LineSDKLoginManagerParameters *parameters = [[LineSDKLoginManagerParameters alloc] init];
parameters.onlyWebLogin = NO; // 优先使用客户端登录 ✅
```

**状态**: ✅ 配置正确

---

#### 5.4 LoginViewController.m - API 调用

**配置位置**: `LoginViewController.m` → Line 登录成功回调

**当前配置**:
```objc
NSString *idToken = result.accessToken.IDTokenRaw ?: @"";
NSDictionary *params = @{@"idToken": idToken};
[NetwortTool loginWithLineToken:params Success:^(id responseObject) {
    // 处理登录响应
} failure:^(NSError *error) {
    // 处理错误
}];
```

**状态**: ✅ 配置正确

---

#### 5.5 NetwortTool.m - API 接口

**配置位置**: `NetwortTool.m` → `loginWithLineToken`

**当前配置**:
```objc
+(void)loginWithLineToken:(NSDictionary *)parm Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    [NetWorkRequest postWithUrl:RequestURL(@"/lineLogin") parameters:parm success:success failure:failure];
}
```

**接口信息**:
- 接口地址: `POST /lineLogin` ✅
- 参数: `{"idToken": "..."}` ✅

**状态**: ✅ 配置正确

---

## 🔍 配置验证总结

### ✅ 已正确配置的项目

1. ✅ Line Developers Console: Channel ID, Bundle ID, Callback URL
2. ✅ Info.plist: LineChannelID, LineUniversalLinkURL, URL Schemes
3. ✅ Entitlements: Associated Domains
4. ✅ 服务器: apple-app-site-association 文件
5. ✅ 应用代码: Line SDK 初始化、回调处理、登录流程、API 调用

### ⚠️ 需要注意的事项

1. **等待时间**:
   - Line Developers Console 配置保存后需要 5-10 分钟生效
   - iOS Universal Link 验证需要 10-15 分钟（首次安装后）

2. **测试要求**:
   - 必须在 iOS 设备上测试（不能是 Mac 浏览器）
   - 必须在 Safari 中测试（不能是应用内浏览器）
   - 必须完全删除应用、重启设备、重新安装

3. **配置同步**:
   - 确保 Line Developers Console、服务器、应用配置都使用相同的 URL
   - 当前 URL: `https://netneto.co.jp/oauth/callback/line`

---

## 📝 测试步骤

### 1. 验证 Universal Link

在设备的 Safari 中:
1. 打开 Safari
2. 输入: `https://netneto.co.jp/oauth/callback/line`
3. 观察结果:
   - ✅ 如果应用自动打开 → Universal Link 配置成功
   - ❌ 如果 Safari 显示空白页面 → 配置有问题或还在验证中

### 2. 测试 Line 登录

1. 打开应用
2. 点击 Line 登录按钮
3. 在 Line 应用中完成授权
4. 应该能正常返回应用并完成登录

---

## 🎯 当前配置状态

**总体评估**: ✅ 所有配置都正确

**可能的问题**:
- Universal Link 可能还在验证中（需要等待）
- 需要完全删除应用并重新安装
- 需要重启设备清除缓存

**建议操作**:
1. 确认 Line Developers Console 中的 Callback URL 已更新为: `https://netneto.co.jp/oauth/callback/line`
2. 确认服务器上的 apple-app-site-association 文件已更新为新的 paths
3. 完全删除应用、重启设备、重新安装
4. 等待 15-20 分钟让 iOS 验证 Universal Link
5. 在设备的 Safari 中测试 Universal Link 是否工作

