//
//  LoginViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/18.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import "PhoneBindingViewController.h"
@import LineSDK;

@interface LoginViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *reginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreeTx;
@property (strong, nonatomic) UIButton *lineLoginButton;

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Socket sharedSocketTool].autoReconnect = NO;
    [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 确保 Line 登录按钮在布局完成后可见
    if (self.lineLoginButton) {
        NSString *deviceType = [UIDevice currentDevice].model;
        if (deviceType && ![deviceType isEqualToString:@"iPad"]) {
            [self.view bringSubviewToFront:self.lineLoginButton];
            self.lineLoginButton.hidden = NO;
        }
    }
}
-(void)initData{
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

    
}
-(void)returnClick{
    if ([self.isCancel isEqual:@"1"]) {
        [account loadRootController];
    }
   else if ([self.isCancel isEqual:@"2"]) {
        [account loadRootController];
    }
    else{
        [self popViewControllerAnimate];
    }
}
-(void)CreateView{
    self.loginBtn.backgroundColor = [UIColor gradientColorWithWidth:WIDTH - 62 color:MainColorArr];
    [self.loginBtn setTitle:TransOutput(@"登录") forState:UIControlStateNormal];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",TransOutput(@"已阅读并同意"),TransOutput(@"《用户协议》"),TransOutput(@"与"),TransOutput(@"《隐私政策》"),TransOutput(@"政策")];
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:str];
   
    NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *valueString1 = [[NSString stringWithFormat:@"secondPerson://2"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSRange rang1 =NSMakeRange(TransOutput(@"已阅读并同意").length, TransOutput(@"《用户协议》").length);
    
    NSRange rang2 =NSMakeRange(str.length - TransOutput(@"《隐私政策》").length - TransOutput(@"政策").length, TransOutput(@"《隐私政策》").length);
    
    [attstring addAttribute:NSLinkAttributeName value:valueString range:rang1];
    [attstring addAttribute:NSLinkAttributeName value:valueString1 range:rang2];
    
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rang1];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:rang1];
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rang2];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:rang2];
    self.agreeTx.delegate = self;
    self.agreeTx.attributedText =attstring;
    self.agreeTx.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0); // 上 左 下 右
    self.agreeTx.textAlignment = NSTextAlignmentCenter; // 设置文本居中
    self.agreeTx.editable = NO; // 如果你不希望用户编辑文本，设置为NO
    @weakify(self);
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self returnKeyBord];
    }];
    self.userTF.delegate = self;
    self.userTF.placeholder = TransOutput(@"ユーザーID");
    self.passTF.placeholder = TransOutput(@"パスワード");
    [self.codeLoginBtn setTitle:TransOutput(@"验证码登录") forState:UIControlStateNormal];
    [self.reginBtn setTitle:TransOutput(@"用户注册") forState:UIControlStateNormal];
    [self.forgetBtn setTitle:TransOutput(@"忘记密码") forState:UIControlStateNormal];
    [self.reginBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ResginViewController *vc = [[ResginViewController alloc] init];
        [self pushController:vc];
    }];
    [self.forgetBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ForgetViewController *vc = [[ForgetViewController alloc] init];
        [self pushController:vc];
    }];
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        if ([self.userTF isFirstResponder]) {
            [self.userTF resignFirstResponder];
        }
        else if ([self.passTF isFirstResponder]){
            [self.passTF resignFirstResponder];
        }
    }];
    
    // 创建 Line 登录按钮
    if (!self.lineLoginButton) {
        self.lineLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.lineLoginButton setTitle:TransOutput(@"LINEでログイン") forState:UIControlStateNormal];
        self.lineLoginButton.backgroundColor = [UIColor colorWithRed:0.0f green:195.0f/255.0f blue:0.0f alpha:1.0f];
        [self.lineLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.lineLoginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        // 确保 cornerRadius 有值，如果 loginBtn 还没有设置，使用默认值
        CGFloat cornerRadius = self.loginBtn.layer.cornerRadius > 0 ? self.loginBtn.layer.cornerRadius : 8.0f;
        self.lineLoginButton.layer.cornerRadius = cornerRadius;
        self.lineLoginButton.layer.masksToBounds = YES;
        [self.lineLoginButton addTarget:self action:@selector(lineLoginTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.lineLoginButton];
        // 确保按钮在视图层级中可见
        [self.view bringSubviewToFront:self.lineLoginButton];
        [self.lineLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginBtn.mas_bottom).offset(16.0f);
            make.left.equalTo(self.loginBtn);
            make.right.equalTo(self.loginBtn);
            make.height.equalTo(self.loginBtn);
        }];
    }
    
    // 确保按钮可见（除非是 iPad）
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        self.codeLoginBtn.hidden = YES;
        self.reginBtn.hidden = YES;
        self.forgetBtn.hidden = YES;
        self.lineLoginButton.hidden = NO;
    } else {
        // 确保非 iPad 设备上按钮可见
        self.lineLoginButton.hidden = NO;
        self.lineLoginButton.alpha = 1.0f;
    }
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        [self handleTap];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"secondPerson"]) {
        [self handleTapY];
        return NO;
    }
 
    return YES;
 
}
-(void)handleTapY{
  
    
    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];

  
    
        vc.url = @"https://netneto.com/privacy_policy.html";
       
   
    
    [self  pushController:vc];
}
-(void)handleTap{
  
    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
   
  
        vc.url = @"https://netneto.com/user_protocol.html";
       
   
    
    [self  pushController:vc];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = textField.text.length + string.length - range.length;
   
    return newLength <= 50;
}
- (IBAction)codeClick:(id)sender {
    CodeViewController *vc = [[CodeViewController alloc] init];
    [self pushController:vc];
    
}
- (void)lineLoginTapped {
    if (![LineSDKLoginManager sharedManager].isSetupFinished) {
        ToastShow(TransOutput(@"LINEログインは現在利用できません。しばらくしてからお試しください"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    NSString *channelID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LineChannelID"];
    if (channelID.length == 0 || [channelID containsString:@"YOUR_LINE_CHANNEL_ID"]) {
        ToastShow(TransOutput(@"LINEログインが設定されていません。管理者に連絡してください"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    
    // 检查 Line 客户端是否安装
    NSURL *lineURL = [NSURL URLWithString:@"line://"];
    BOOL isLineInstalled = [[UIApplication sharedApplication] canOpenURL:lineURL];
    
    if (!isLineInstalled) {
        // Line 客户端未安装，提示用户安装
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TransOutput(@"お知らせ") 
                                                                         message:TransOutput(@"LINEログインを使用するには、まずLINEアプリをインストールしてください") 
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *installAction = [UIAlertAction actionWithTitle:TransOutput(@"インストールへ") 
                                                                style:UIAlertActionStyleDefault 
                                                              handler:^(UIAlertAction * _Nonnull action) {
            // 打开 App Store 安装 Line
            NSURL *appStoreURL = [NSURL URLWithString:@"https://apps.apple.com/app/line/id443904275"];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:appStoreURL];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TransOutput(@"キャンセル") 
                                                                style:UIAlertActionStyleCancel 
                                                              handler:nil];
        [alert addAction:installAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.lineLoginButton.enabled = NO;
    @weakify(self);
    NSSet<LineSDKLoginPermission *> *permissions = [NSSet setWithObjects:LineSDKLoginPermission.profile, LineSDKLoginPermission.openID, nil];
    
    // 配置登录参数，禁止网页登录，只使用客户端登录
    LineSDKLoginManagerParameters *parameters = [[LineSDKLoginManagerParameters alloc] init];
    parameters.onlyWebLogin = NO; // 设置为 NO，优先使用客户端登录
    
    [[LineSDKLoginManager sharedManager] loginWithPermissions:permissions inViewController:self parameters:parameters completionHandler:^(LineSDKLoginResult *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (!self) {
                return;
            }
            if (error) {
                self.lineLoginButton.enabled = YES;
                
                // 用户取消登录（错误码 3003）
                if ([error.domain isEqualToString:LineSDKErrorConstant.errorDomain] && error.code == 3003) {
                    // 不显示错误提示给用户，因为可能是配置问题
                    return;
                }
                
                // 检查是否是网页登录相关的错误，如果是则提示用户
                NSString *errorMessage = error.userInfo[LineSDKErrorConstant.userInfoKeyMessage];
                NSString *errorDescription = error.localizedDescription;
                
                // 如果错误信息包含网页登录相关的内容，提示用户使用客户端
                BOOL isWebLoginError = NO;
                if (errorDescription && ([errorDescription rangeOfString:@"web" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                    [errorDescription rangeOfString:@"safari" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
                    isWebLoginError = YES;
                }
                if (errorMessage && ([errorMessage rangeOfString:@"web" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                    [errorMessage rangeOfString:@"safari" options:NSCaseInsensitiveSearch].location != NSNotFound)) {
                    isWebLoginError = YES;
                }
                
                if (isWebLoginError) {
                    ToastShow(TransOutput(@"LINEアプリでログインしてください"),@"矢量 20",RGB(0xFF830F));
                    return;
                }
                
                NSString *message = errorMessage.length > 0 ? errorMessage : 
                                   (errorDescription.length > 0 ? errorDescription : TransOutput(@"ログインに失敗しました。しばらくしてからお試しください"));
                ToastShow(message,@"矢量 20",RGB(0xFF830F));
                return;
            }
            if (!result) {
                self.lineLoginButton.enabled = YES;
                ToastShow(TransOutput(@"ログインに失敗しました。しばらくしてからお試しください"),@"矢量 20",RGB(0xFF830F));
                return;
            }
            
            [HudView showHudForView:self.view];
            NSString *idToken = result.accessToken.IDTokenRaw ?: @"";
            
            // 只传递 idToken 参数
            if (idToken.length == 0) {
                [HudView hideHudForView:self.view];
                self.lineLoginButton.enabled = YES;
                ToastShow(TransOutput(@"ログインに失敗しました。しばらくしてからお試しください"),@"矢量 20",RGB(0xFF830F));
                return;
            }
            
            NSDictionary *params = @{@"idToken": idToken};
            [NetwortTool loginWithLineToken:params Success:^(id responseObject) {
                // 确保所有 UI 操作在主线程执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HudView hideHudForView:self.view];
                    
                    // 检查返回的数据结构
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *responseDict = (NSDictionary *)responseObject;
                        NSDictionary *data = responseDict[@"data"];
                        
                        if (data && [data isKindOfClass:[NSDictionary class]]) {
                            // 检查 line 字段：line = 1 需要绑定手机号，line = 0 直接进入主页
                            NSNumber *lineValue = data[@"line"];
                            NSInteger line = lineValue ? [lineValue integerValue] : 0;
                            
                            if (line == 1) {
                                // line = 1，需要绑定手机号
                                // 保存接口数据（包括 accessToken），但不完成登录流程
                                account.user = [userModel mj_objectWithKeyValues:data];
                                
                                // 跳转到绑定页面
                                PhoneBindingViewController *phoneBindingVC = [[PhoneBindingViewController alloc] init];
                                phoneBindingVC.lineUserId = data[@"userId"];
                                [self.navigationController pushViewController:phoneBindingVC animated:YES];
                            } else {
                                // line = 0 或其他值，直接进入登录流程（进入主页）
                                [self handleLoginResponse:data];
                            }
                        } else {
                            // 如果没有 data 字段，使用整个 responseObject
                            [self handleLoginResponse:responseObject];
                        }
                    } else {
                        // 如果响应不是字典，直接处理
                        [self handleLoginResponse:responseObject];
                    }
                    
                    self.lineLoginButton.enabled = YES;
                });
            } failure:^(NSError *error) {
                // 确保所有 UI 操作在主线程执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HudView hideHudForView:self.view];
                    NSString *httpError = error.userInfo[@"httpError"];
                    NSString *message = httpError.length > 0 ? httpError : TransOutput(@"ログインに失敗しました。しばらくしてからお試しください");
                    ToastShow(message,@"矢量 20",RGB(0xFF830F));
                    self.lineLoginButton.enabled = YES;
                });
            }];
        });
    }];
}

- (void)handleLoginResponse:(id)responseObject {
    account.user = [userModel mj_objectWithKeyValues:responseObject];
    [account loadResource];
    [account loadBank];
    [self getuserInfo];
}

-(void)returnKeyBord{
    if ([self.userTF isFirstResponder]) {
        [self.userTF resignFirstResponder];
        
    }
    else  if ([self.passTF isFirstResponder]) {
        [self.passTF resignFirstResponder];
    }
}

- (IBAction)eyeClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected =YES;
       
        self.passTF.secureTextEntry = NO;
    }else{
        sender.selected = NO;
        self.passTF.secureTextEntry = YES;
    }
}

- (IBAction)loginClick:(id)sender {
    if (self.userTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入账号"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    if (self.passTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入密码"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    NSString *passStr = [NSString stringWithFormat:@"%@%@",[Tool getCurrentTimeNumber],self.passTF.text];
 
    NSString *str = [AESManager encrypt:passStr key:AESKEY] ;
    NSLog(@"加密字符串：%@",str);
    [HudView showHudForView:self.view];
    
//    [LoadingView showLoadingAction];
    [NetwortTool loginWithUserName:@{@"userName":self.userTF.text,@"passWord":str} Success:^(id  _Nonnull responseObject) {
        
        [self handleLoginResponse:responseObject];

//
        
      
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
//        [LoadingView dismissLoadingAction];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      }];
}
-(void)getuserInfo{
    [NetwortTool getUserInfoSuccess:^(id  _Nonnull responseObject) {
        account.userInfo = [UserInfoModel mj_objectWithKeyValues:responseObject];
        if (![Socket sharedSocketTool].autoReconnect && ![Socket sharedSocketTool].isLogin) {
            [[Socket sharedSocketTool] initSocket];
        }
        if ([Socket sharedSocketTool].autoReconnect && ![Socket sharedSocketTool].isLogin) {
            //已连接 未登录
            [[Socket sharedSocketTool] loginSocket];
        }
        [HudView hideHudForView:self.view];
//        [LoadingView dismissLoadingAction];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataCoupon" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadData" object:nil userInfo:nil];
        
        if ([self.isCancel isEqual:@"1"]) {
            [account loadRootController];
        }
        else{
            [self popViewControllerAnimate];
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
//        [LoadingView dismissLoadingAction];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      
    }];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
