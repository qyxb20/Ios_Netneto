# Netneto 工程结构与核心文件梳理

> 适用范围：`/Users/apple/Desktop/Ios_netneto/Netneto` 项目。本文帮助快速建立对现有代码的整体认识，方便后续接入新功能或排查问题。

---

## 1. 工程概览
- **项目类型**：iOS 原生 App（主体 Objective-C，已启用 Swift 桥接以便接入 Swift-only SDK）
- **主要业务**：帐号登录、商城（首页/分类/购物车）、直播、即时通讯、支付等
- **入口流程**：`AppDelegate` -> `ViewController` -> `AccountTool` 决定加载 `BaseTabbarController` 或跳转登录
- **第三方框架**：详见 `Podfile`，核心包括 AFNetworking、CYLTabBarController、ReactiveObjC、Agora RTC/RTM、Square 支付、MJExtension 等

---

## 2. 启动与全局状态

| 文件/类 | 作用描述 |
| --- | --- |
| `AppDelegate.h/m` | 创建窗口、设置根控制器、初始化 Square 支付、检测版本更新，维护后台任务；`applicationDidBecomeActive` 会触发版本检查及 Socket 初始化 |
| `ViewController.m` | App 启动后立即调用 `account loadRootController`，根据登录状态切换后续界面 |
| `AccountTool.h/m` | 登录态单例，缓存 `user`、`userInfo`、`accessToken`，负责根控制器切换、登陆/登出、拉取用户/银行数据、触发 Socket/RTM/RTC 初始化，封装与 `SaveManager` 的持久化逻辑 |
| `Netneto-Bridging-Header.h` | Swift 桥接头（当前为空），用于在 OC 工程引入 Swift SDK 或暴露 OC API 给 Swift |

---

## 3. 主界面结构

| 模块 | 关键文件 | 职责 |
| --- | --- | --- |
| Tab 容器 | `BaseTabbarController.m` | 基于 `CYLTabBarController` 构建五个 Tab（首页/分类/购物车/LIVE/我的），统一设置 Tab 样式与点击逻辑；在切换到购物车时检查登录态 |
| 导航控制 | `BaseNavgationController.m` | 自定义导航栏外观、交互手势 |
| 基类 | `BaseViewController.m`, `BaseView.m` | 设置通用 UI、数据、埋点等基础能力 |
| 首页 | `Home/` 目录（`HomeViewController`、`Model`、`View` 等） | 商城首页、banner、推荐列表等 |
| 分类 | `Classification/` | 分类筛选、商品列表业务 |
| 购物车 | `ShoppingCart/` | 购物车管理、结算入口（含数量、优惠） |
| LIVE | `Live/` | 直播间、直播商品（包含与 Agora RTC/RTM 交互） |
| 我的 | `Mine/` | 用户中心、订单、设置等 |

---

## 4. 登录与账户相关

- `Login/VC/`：包含账号登录、验证码登录、注册、忘记密码等页面（如 `LoginViewController.m`、`CodeViewController.m`）。
- `Login/View/`：登录/注册流程用到的自定义视图。
- 登录成功后流程：`LoginViewController` -> `NetwortTool loginWithUserName` -> `AccountTool loadResource` -> 获取用户信息并初始化 Socket/RTM。
- 未登录访问敏感页面时，会通过弹窗或自动跳转回 `LoginViewController`。

---

## 5. 网络层与接口封装

| 文件/类 | 作用描述 |
| --- | --- |
| `Network/NetWorkRequest.h/m` | 网络请求底层封装，维护服务器域名、请求头（Authorization）、日志输出、错误统一处理；支持 GET/POST/PUT/DELETE 及表单提交 |
| `Network/NetWorkCommon.h/m` | 基于 AFNetworking 的抽象层（在 Pods 中），实际发起 HTTP 请求 |
| `Network/NetwortTool.h/m` | 业务接口集合，按功能划分方法（登录、首页、商品、订单、直播、支付等）；后端返回约定 `code == "00000"` 视为成功 |
| `Tool/SaveManager` | 本地持久化工具，保存/读取用户信息、配置等 |

常见错误码：`A00004` 表示登录失效，会触发 `AccountTool Kitout` 进行强退。

---

## 6. 即时通讯与实时音视频

| 模块 | 关键文件 | 说明 |
| --- | --- | --- |
| RTM（信令） | `RTM/RTM.h/m` | 基于 Agora RTM 的登录、消息收发、踢出等逻辑 |
| RTC（音视频） | `RTC/RTC.h/m` | 声网 RTC 加入频道、推流、视频预览等操作 |
| Socket | `Tool/Socket`（具体实现可搜索 `Socket sharedSocketTool`） | 维护 Socket 连接、重连、心跳；与直播/消息模块协同 |
| 关联流程 | `AccountTool` 在登录、被踢、登出时统筹调用上述模块 |

---

## 7. 工具与辅助模块

- `Tool/`：通用工具集，例如 `HudView`（加载框）、`ToastShow`（提示）、`CSQAlertView`（弹窗）、`AESManager`、`NSString+UUID` 等。
- `Category/`：系统类扩展（如 `UIView+`、`UIButton+` 等），提供布局、样式、手势封装。
- `Language/`：本地化支持，`TransOutput` 宏在此实现，配合 `ja.lproj` 资源提供日文展示。
- `View/`：共享 UI 组件和 XIB（表格 Cell、弹窗、自定义控件）。

---

## 8. 第三方依赖速读（节选）

- **网络&响应式**：`AFNetworking`、`ReactiveObjC`
- **UI 组件**：`CYLTabBarController`、`JXCategoryView`、`JXPagingView`、`SDCycleScrollView`、`DZNEmptyDataSet`
- **工具类**：`Masonry`、`MJExtension`、`MJRefresh`、`IQKeyboardManager`
- **媒体/实时**：`AgoraRtcEngine_iOS`、`AgoraRtm`
- **支付**：`SquareInAppPaymentsSDK`、`SquareBuyerVerificationSDK`
- **存储/协议**：`Protobuf`

详尽列表请参阅 `Podfile`。

---

## 9. 研发建议与注意事项

1. **登录态统一**：通过 `AccountTool` 读写 `accessToken`，避免重复持久化。
2. **网络扩展**：新增接口时优先在 `NetwortTool` 中封装，保持调用统一；注意服务端返回结构与错误码。
3. **实时模块**：对 `Kitout`、登出流程做改动时，同时考虑 RTC、RTM、Socket 的释放与通知发送。
4. **Swift SDK 引入**：若接入 Swift-only SDK（如最新 LINE/TikTok），在 OC 文件中 `#import <xxx/xxx-Swift.h>` 即可使用。
5. **旧 API 替换计划**：项目仍有 `UIAlertView`、`NSURLConnection` 等旧接口，后续如需兼容性优化可规划替换为现代 API。
6. **文档化**：建议持续更新此类结构文档与模块说明，降低交接成本。

---

## 10. 参考入口
- `AppDelegate.m`：应用生命周期、根控制器
- `AccountTool.m`：登录态核心逻辑
- `BaseTabbarController.m`：主业务模块入口
- `Network/NetwortTool.m`：全部后端接口总览
- `Login/LoginViewController.m`：传统登录流程实现
- `RTM/`、`RTC/`：直播/即时通信相关

如需更细分的流程图或接口文档，可在此基础上继续补充。

