//
//  PhoneBindingViewController.m
//  Netneto
//
//  Created on 2025/11/21.
//

#import "PhoneBindingViewController.h"
#import <Masonry/Masonry.h>
#import "LoginViewController.h"
#import "NetwortTool.h"

@interface PhoneBindingViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *sendCodeButton;
@property (nonatomic, strong) UIButton *bindingButton;
@property (nonatomic, strong) UILabel *exampleLabel;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIImageView *bgHeaderView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *birthTextField;
@property (nonatomic, strong) BRDatePickerView *datePicker;
@property (nonatomic, strong) NSString *birthStr;
@end

@implementation PhoneBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏，保留 bgHeaderView 样式
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复导航栏（可选，根据需求决定）
    // [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initData {
    // 设置导航栏（与 HomeSectionViewController 保持一致）
    // 继承自 BaseViewController，使用 BaseViewController 的导航栏样式（hbd_ 属性）
    // 隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    // 设置标题
    self.navigationItem.title  = TransOutput(@"携帯電話番号と連携");
    
}

- (void)returnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView {
    // 添加顶部背景视图（与 HomeSectionViewController 保持一致）
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    
    // 添加标题标签
    [self.bgHeaderView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgHeaderView);
        make.bottom.equalTo(self.bgHeaderView).offset(-20);
    }];
    
    // 手机号输入框容器
    UIView *phoneContainer = [[UIView alloc] init];
    phoneContainer.backgroundColor = [UIColor whiteColor];
    phoneContainer.layer.borderColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f].CGColor;
    phoneContainer.layer.borderWidth = 0.5f;
    phoneContainer.layer.cornerRadius = 27.0f; // 与登录页保持一致
    phoneContainer.layer.masksToBounds = YES;
    [self.view addSubview:phoneContainer];
    
    // 手机图标（使用登录页账号输入框右侧的图片）
    UIImageView *phoneIcon = [[UIImageView alloc] init];
    phoneIcon.image = [UIImage imageNamed:@"login_phone"];
    phoneIcon.contentMode = UIViewContentModeScaleAspectFit;
    [phoneContainer addSubview:phoneIcon];
    
    // 手机号输入框
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = TransOutput(@"携帯電話番号を入力してください。");
    self.phoneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation; // 允许输入数字和连字符
    self.phoneTextField.delegate = self;
    self.phoneTextField.font = [UIFont systemFontOfSize:16.0f];
    self.phoneTextField.textAlignment = NSTextAlignmentLeft; // 左对齐
    self.phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; // 垂直居中
    self.phoneTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; // 水平左对齐
    [phoneContainer addSubview:self.phoneTextField];
    
    // 示例标签
    self.exampleLabel = [[UILabel alloc] init];
    self.exampleLabel.text = TransOutput(@"例:090-1234-5678");
//    self.exampleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    self.exampleLabel.textColor = [UIColor orangeColor];
    self.exampleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.exampleLabel.textAlignment = NSTextAlignmentLeft; // 左对齐
    [self.view addSubview:self.exampleLabel];
    
    // 验证码输入框容器
    UIView *codeContainer = [[UIView alloc] init];
    codeContainer.backgroundColor = [UIColor whiteColor];
    codeContainer.layer.borderColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f].CGColor;
    codeContainer.layer.borderWidth = 0.5f;
    codeContainer.layer.cornerRadius = 27.0f; // 与登录页保持一致
    codeContainer.layer.masksToBounds = YES;
    [self.view addSubview:codeContainer];
    
    // 验证码输入框
    self.codeTextField = [[UITextField alloc] init];
    self.codeTextField.placeholder = TransOutput(@"認証コード入力");
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.delegate = self;
    self.codeTextField.font = [UIFont systemFontOfSize:16.0f];
    self.codeTextField.textAlignment = NSTextAlignmentLeft; // 左对齐
    self.codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; // 垂直居中
    self.codeTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; // 水平左对齐
    [codeContainer addSubview:self.codeTextField];
    
    // 发送验证码按钮
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendCodeButton setTitle:TransOutput(@"認証コード送信") forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendCodeButton.backgroundColor = RGB(0x3ED196); // 与其他验证码页面保持一致
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.sendCodeButton.layer.cornerRadius = 18.5; // 与其他验证码页面保持一致
    self.sendCodeButton.layer.masksToBounds = YES;
    [self.sendCodeButton addTarget:self action:@selector(sendCodeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [codeContainer addSubview:self.sendCodeButton];
    
    // 登録按钮
    self.bindingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bindingButton setTitle:TransOutput(@"登録") forState:UIControlStateNormal];
    [self.bindingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bindingButton.backgroundColor = [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    self.bindingButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.bindingButton.layer.cornerRadius = 27.0f; // 与登录页保持一致
    self.bindingButton.layer.masksToBounds = YES;
    [self.bindingButton addTarget:self action:@selector(bindingButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bindingButton];
    
    // 布局约束
    CGFloat margin = 20.0f;
    CGFloat topMargin = 100.0f;
    
    [phoneContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(topMargin);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.height.equalTo(@50);
    }];
    
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneContainer).offset(12);
        make.centerY.equalTo(phoneContainer);
        make.width.height.equalTo(@37); // 与登录页保持一致
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).offset(5); // 与登录页保持一致
        make.right.equalTo(phoneContainer).offset(-15);
        make.centerY.equalTo(phoneContainer);
        make.height.equalTo(@40);
    }];
    
    [self.exampleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneContainer.mas_bottom).offset(8);
        // 与输入框内容左对齐：22(图标左边距) + 37(图标宽度) + 5(间距) = 64
        make.left.equalTo(phoneContainer).offset(12 + 30);
    }];
    
    [codeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exampleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.height.equalTo(@50);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeContainer).offset(12 + 37 + 5); // 与手机号输入框内容左对齐（22+37+5=64，但验证码框没有图标，所以直接用22）
        make.centerY.equalTo(codeContainer);
        make.right.equalTo(self.sendCodeButton.mas_left).offset(-10);
        make.height.equalTo(@40);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeContainer).offset(-10);
        make.centerY.equalTo(codeContainer);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
    }];
    
    // 生年月日输入框容器
    UIView *birthContainer = [[UIView alloc] init];
    birthContainer.backgroundColor = [UIColor whiteColor];
    birthContainer.layer.borderColor = [UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f].CGColor;
    birthContainer.layer.borderWidth = 0.5f;
    birthContainer.layer.cornerRadius = 27.0f;
    birthContainer.layer.masksToBounds = YES;
    [self.view addSubview:birthContainer];
    
    // 生年月日输入框
    self.birthTextField = [[UITextField alloc] init];
    self.birthTextField.placeholder = TransOutput(@"生年月日を選択してください。");
    self.birthTextField.delegate = self;
    self.birthTextField.font = [UIFont systemFontOfSize:16.0f];
    self.birthTextField.textAlignment = NSTextAlignmentLeft;
    self.birthTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.birthTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [birthContainer addSubview:self.birthTextField];
    
    [birthContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeContainer.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.height.equalTo(@50);
    }];
    
    [self.birthTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(birthContainer).offset(12 + 37 + 5); // 与验证码输入框内容左对齐
        make.right.equalTo(birthContainer).offset(-12);
        make.centerY.equalTo(birthContainer);
        make.height.equalTo(@40);
    }];
    
    [self.bindingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(birthContainer.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
        make.height.equalTo(@50);
    }];
    
    // 添加点击手势隐藏键盘
    @weakify(self);
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self returnKeyBord];
    }];
}

- (void)returnKeyBord {
    if ([self.phoneTextField isFirstResponder]) {
        [self.phoneTextField resignFirstResponder];
    } else if ([self.codeTextField isFirstResponder]) {
        [self.codeTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.birthTextField) {
        // 先收起可能已经弹出的键盘（手机号或验证码）
        [self.view endEditing:YES];
        [self choseBirthday];
        return NO; // 阻止键盘弹出
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 只对手机号输入框进行限制
    if (textField == self.phoneTextField) {
        // 允许输入数字和连字符
        NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:string];
        
        if (![allowedCharacters isSupersetOfSet:characterSet]) {
            return NO; // 不允许输入非数字和非连字符的字符
        }
        
        // 限制最大长度为 13 (090-1234-5678)
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length > 13) {
            return NO;
        }
    } else if (textField == self.codeTextField) {
        // 验证码输入框只允许数字，限制最大长度为 50
        NSCharacterSet *allowedCharacters = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:string];
        
        if (![allowedCharacters isSupersetOfSet:characterSet]) {
            return NO;
        }
        
        NSUInteger newLength = textField.text.length + string.length - range.length;
        if (newLength > 50) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Button Actions

- (void)sendCodeButtonTapped {
    NSString *phoneNumber = self.phoneTextField.text;
    
    if (phoneNumber.length == 0) {
        ToastShow(TransOutput(@"携帯電話番号を入力してください。"), @"矢量 20", RGB(0xFF830F));
        return;
    }
    
    // 校验手机号格式 090-1234-5678
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
    BOOL phoneValid = [phoneTest evaluateWithObject:phoneNumber];
    if (!phoneValid) {
        ToastShow(TransOutput(@"携帯電話番号の形式が正しくありません（例:090-1234-5678）。"), @"矢量 20", RGB(0xFF830F));
        return;
    }

    // 调用LINE绑定手机号发送验证码接口
    [NetwortTool lineSendCode:phoneNumber Success:^(id responseObject) {
        // 确保 UI 操作在主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            // 开始倒计时
        [self startCountdown];
        });
    } failure:^(NSError *error) {
        // 确保 UI 操作在主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *httpError = error.userInfo[@"httpError"];
            NSString *message = httpError.length > 0 ? httpError : TransOutput(@"認証コードの送信に失敗しました。");
            ToastShow(message, @"矢量 20", RGB(0xFF830F));
        });
    }];
}

- (void)startCountdown {
    self.timeCount = 120; // 与其他验证码页面保持一致（120秒）
    self.sendCodeButton.enabled = NO;
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.timeCount <= 0) {
            dispatch_source_cancel(self.timer);
            self.sendCodeButton.enabled = YES;
            [self.sendCodeButton setTitle:TransOutput(@"認証コード送信") forState:UIControlStateNormal];
        } else {
            // 与其他验证码页面保持一致，格式为 "120 s"
            [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%ld s", (long)self.timeCount] forState:UIControlStateNormal];
            self.timeCount--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)bindingButtonTapped {
    NSString *phoneNumber = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *birthday = self.birthTextField.text;
    NSString *userId = self.lineUserId;
    
    if (phoneNumber.length == 0) {
        ToastShow(TransOutput(@"携帯電話番号を入力してください。"), @"矢量 20", RGB(0xFF830F));
        return;
    }
    
    // 校验手机号格式 090-1234-5678
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
    BOOL phoneValid = [phoneTest evaluateWithObject:phoneNumber];
    if (!phoneValid) {
        ToastShow(TransOutput(@"携帯電話番号の形式が正しくありません（例:090-1234-5678）。"), @"矢量 20", RGB(0xFF830F));
        return;
    }
    
    if (code.length == 0) {
        ToastShow(TransOutput(@"認証コードを入力してください。"), @"矢量 20", RGB(0xFF830F));
        return;
    }
    
    // 验证生日输入框不为空
   
    if (birthday.length == 0) {
        ToastShow(TransOutput(@"生年月日を選択してください。"), @"矢量 20", RGB(0xFF830F));
        return;
    }
    
    // 获取 userId（来自 LINE 登录）
    
    if (userId.length == 0) {
        ToastShow(TransOutput(@"ユーザー情報が取得できませんでした。"), @"矢量 20", RGB(0xFF830F));
        return;
    }
    
    // 调用LINE绑定手机号接口（携带生日）
    // 确保 UI 操作在主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [HudView showHudForView:self.view];
    });
    [NetwortTool lineBind:userId phone:phoneNumber code:code birthday:birthday Success:^(id responseObject) {
        // 确保 UI 操作在主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绑定成功后，处理返回的数据
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSDictionary *data = responseDict[@"data"];
            
            // 保存之前保存的 accessToken（因为新用户绑定成功可能不会返回 token）
            NSString *savedAccessToken = account.user.accessToken ?: account.accessToken;
            
            if (data) {
                account.user = [userModel mj_objectWithKeyValues:data];
                // 如果返回的数据没有 accessToken，使用之前保存的
                if (!account.user.accessToken || account.user.accessToken.length == 0) {
                    account.user.accessToken = savedAccessToken;
                }
                [account loadResource];
                [account loadBank];
                [self getuserInfo];
            } else {
                account.user = [userModel mj_objectWithKeyValues:responseObject];
                // 如果返回的数据没有 accessToken，使用之前保存的
                if (!account.user.accessToken || account.user.accessToken.length == 0) {
                    account.user.accessToken = savedAccessToken;
                }
                [account loadResource];
                [account loadBank];
                [self getuserInfo];
            }
        });
    } failure:^(NSError *error) {
        // 确保 UI 操作在主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            [HudView hideHudForView:self.view];
            NSString *httpError = error.userInfo[@"httpError"];
            NSString *message = httpError.length > 0 ? httpError : TransOutput(@"バインディングに失敗しました");
            ToastShow(message, @"矢量 20", RGB(0xFF830F));
        });
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataCoupon" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadData" object:nil userInfo:nil];
        
//        ToastShow(TransOutput(@"バインディング成功。"), @"矢量 20", RGB(0x00FF00));
        [account loadRootController];
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      
    }];
   
}

- (void)navigateToMainApp {
    // 跳过绑定时使用的方法，直接进入应用
    [account loadRootController];
}

- (UIImageView *)bgHeaderView {
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
    }
    return _bgHeaderView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = TransOutput(@"携帯電話番号と連携");
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)choseBirthday {
    self.datePicker = [[BRDatePickerView alloc] init];
    self.datePicker.pickerMode = BRDatePickerModeDate;
    self.datePicker.title = TransOutput(@"生年月日を選択");
    
    self.datePicker.selectValue = self.birthTextField.text;
    self.datePicker.minDate = [NSDate br_setYear:1950 month:1];
    self.datePicker.maxDate = [NSDate date];
   
    self.datePicker.isAutoSelect = NO;
    @weakify(self)
    self.datePicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        @strongify(self)
        // 不做年龄判断，直接保存选择的生年月日
        dispatch_async(dispatch_get_main_queue(), ^{
            self.birthTextField.text = selectValue;
            self.birthStr = selectValue;
        });
    };
     BRPickerStyle *customStyle = [[BRPickerStyle alloc] init];
     customStyle.hiddenCancelBtn = YES;
     customStyle.doneBtnTitle = TransOutput(@"確定");
     customStyle.doneTextFont = [UIFont systemFontOfSize:16];
     customStyle.doneTextColor = [UIColor blackColor];
     customStyle.hiddenTitleLine = YES;
     customStyle.topCornerRadius = 16;
    customStyle.language = @"zh";
     self.datePicker.pickerStyle = customStyle;
    [self.datePicker show];
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end

