# LoginViewController 现有逻辑梳理

> 目的：快速了解当前登录页（`Login/LoginViewController`）的 UI 架构、交互流程、网络调用及依赖，方便后续加入 Line / TikTok 等第三方登录。

---

## 1. 文件与资源
- **控制器**：`Login/LoginViewController.h` / `.m`
- **界面文件**：`Login/LoginViewController.xib`
- **辅助类**：`CodeViewController`（验证码登录页）、`ResginViewController`（注册）、`ForgetViewController`（忘记密码）
- **工具依赖**：`HudView`、`ToastShow`、`AESManager`、`CSQAlertView`、`Tool` 分类 & 宏（如 `TransOutput`、`RGB`）
- **网络接口**：`NetwortTool loginWithUserName`, `NetwortTool loginWithCode`, `NetwortTool loginWithGetCode`
- **状态管理**：`AccountTool`、`Socket sharedSocketTool`

---

## 2. UI 结构（XIB）
- 顶部 Logo + 标题
- 用户名输入框（`userTF`），左边带邮箱图标
- 密码输入框（`passTF`），右侧有显示/隐藏按钮（`eyeBtn`）
- “验证码登录”按钮（跳转 `CodeViewController`）
- “用户注册”、“忘记密码”按钮（点击后各自 push 对应 VC）
- 主登录按钮（`loginBtn`）
- 勾选协议按钮（`choseBtn`）+ 协议富文本（`agreeTx`）：支持点击触发 `handleTap` / `handleTapY` 进入用户协议/隐私政策

> 注：iPad 设备上隐藏验证码登录 / 注册 / 忘记密码入口。

---

## 3. 控件与属性
```objc
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *reginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreeTx;
@property (nonatomic, strong) UIButton *returnBtn; // 由 BaseViewController 提供返回按钮封装
```

额外状态：
- `isCancel`：用于区分从不同场景（如注销、购物车）返回登录的逻辑分支

---

## 4. 生命周期与初始化
- `viewWillAppear`：关闭 Socket 自动重连、清空 Tab 角标
- `viewDidLoad`：调用 `initData` 配置返回按钮 → `CreateView` 设置 UI 文案、手势和文案链接；注册点击事件
- `CreateView` 要点：
  - 设置按钮标题（通过 `TransOutput` 多语言）
  - 配置协议富文本 `agreeTx`，绑定自定义 URL Scheme 以跳转协议页面
  - AOP：给整页添加 tap 手势，点击收起键盘

---

## 5. 用户交互流程

### 5.1 账号密码登录
1. 用户输入用户名/密码
2. 点击“登录”→ `loginClick:`
   - 校验：
     - 用户名非空 → 否则 `ToastShow("请输入账号")`
     - 密码非空 → 否则 `ToastShow("请输入密码")`
   - 加密：`passStr = 时间戳 + 输入密码` → `AESManager encrypt`
   - 调用 `NetwortTool loginWithUserName` 发送用户名 & 加密密码
   - 显示加载：`HudView showHudForView`
3. 成功回调：
   - 将结果转成 `userModel`
   - `account.loadResource` 获取用户详细信息
   - `account.loadResource` 完成后在 `AccountTool` 内：
     - 保存 `UserInfoModel`
     - 初始化/登录 Socket & RTM
     - 发送多个通知更新 UI（`uploadUserInfo`, `updataShopNumber`, `updataCoupon`）
   - 根据 `isCancel` 判断跳回方式
4. 失败回调：`HudView hide` + `ToastShow(error.userInfo[@"httpError"])`

### 5.2 协议勾选
- `choseClick:`：简单切换选中态（未强制要求勾选，若为平滑升级可在后续加入约束）
- `agreeTx` 链接点击：
  - `firstPerson://` -> 用户协议
  - `secondPerson://` -> 隐私政策
  - 均通过 `MineWebKitViewController` 内嵌网页打开

### 5.3 密码显示/隐藏
- `eyeClick:`：切换按钮选中态并设置 `passTF.secureTextEntry`

### 5.4 其他跳转
- 验证码登录：`codeClick:` -> push `CodeViewController`
- 注册：tap 手势 -> push `ResginViewController`
- 忘记密码：tap 手势 -> push `ForgetViewController`

> 这些页面在完成操作后通常会回到 `LoginViewController` 或直接进入业务流程。

---

## 6. 网络交互摘要
| 调用场景 | 方法 | 参数 | 说明 |
| --- | --- | --- | --- |
| 账号密码登录 | `NetwortTool loginWithUserName` | `{ userName, passWord }`（加密后） | 返回 `userModel`，内部设置 `account.accessToken` |
| 获取验证码 | `NetwortTool loginWithGetCode`（在验证码登录页使用） | 表单/字符串 | 当前页面不直接调用 |
| 获取用户信息 | `AccountTool loadResource` 内部：`NetwortTool getUserInfo` | 无 | 登录后补充用户详情、初始化 Socket |

---

## 7. 事件与通知
- 登录成功后由 `AccountTool` 统一发出通知：
  - `uploadUserInfo`
  - `updataShopNumber`
  - `updataCoupon`
  - 可能还有直播相关的 `loadData`
- 登录页自身未监听通知，但 `BaseTabbarController` 会在购物车 Tab 再次校验登录态。

---

## 8. 与第三方登录的衔接点建议
| 衔接位置 | 说明 |
| --- | --- |
| UI 层 | 在 XIB 或代码中加入新按钮（LINE/TikTok），与现有按钮同层级；iPad 隐藏逻辑需同步更新 |
| 控制器 | 新增 `lineLoginTapped` / `tiktokLoginTapped` 等方法，与账号登录相似，成功后调用统一的 `handleLoginSuccessWithData:` | 
| 网络层 | 在 `NetwortTool` 增加 `loginWithLineToken`、`loginWithTikTokCode`，复用登录成功后的处理（写入 `userModel`、调用 `account.loadResource`） |
| 状态管理 | 第三方成功后仍调用 `account.loadResource` 和 `return`/`pop` 逻辑，保持体验一致 |
| 协议/埋点 | 可在 `choseBtn` 或第三方按钮点击时添加埋点；若需要强制勾选协议，可在按钮事件中复用现有 Toast 提示 |

---

## 9. 常见注意点
- 密码加密依赖当前时间戳 + AES KEY，需要与后端保持一致；第三方登录可直接携带 `accessToken`/`authCode`，无需此加密步骤
- `HudView` 显示与关闭需成对调用，避免残留遮罩
- `Socket sharedSocketTool` 在 `viewWillAppear` 中被关闭自动重连，登录成功后由 `AccountTool` 再初始化
- `isCancel` 字段区分不同入口回退行为，集成第三方登录后若有新的入口记得扩展
- 目前协议勾选未强制限制，可按产品要求增加校验

---

如需进一步细化（例如验证码登录 `CodeViewController` 的流程、注册/忘记密码链路），可以在此文档基础上继续扩展。

