//
//  ResginViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/18.
//

#import "ResginViewController.h"

@interface ResginViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgView;
@property(nonatomic, strong)resignCustomTFView *userView;
@property(nonatomic, strong)resginPassCustomTFView *passView;
@property(nonatomic, strong)UILabel *liLabel;
@property(nonatomic, strong)resginPassCustomTFView *aginPassView;
@property(nonatomic, strong)resignCustomTFView *userNickNameView;
@property(nonatomic, strong)resignCustomTFView *birBtnView;
@property(nonatomic, strong)resignCustomTFView *sexBtnView;
@property(nonatomic, strong)BRDatePickerView *datePicker;
@property(nonatomic, strong)UIButton *phoneBtnView;
@property(nonatomic, strong)UIButton *emilBtnView;
@property(nonatomic, strong)resignCustomTFView *phoneView;
@property(nonatomic, strong)UIButton *codeBtnView;
@property(nonatomic, strong)resignCustomTFView *codeView;

@property(nonatomic, strong)UIButton *reginBtnView;
@property(nonatomic, strong)UITextView *agreeBtnView;
@property(nonatomic, strong)NSString *birStr;
@property(nonatomic, strong)NSString *sexStr;
@property(nonatomic, assign)NSInteger validateType;
@property (nonatomic, assign) NSInteger timecount;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ResginViewController
-(void)initData{
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    self.birStr = @"";
    self.sexStr = @"";
    self.validateType = 0;
    
}
-(void)returnClick{
    [self popViewControllerAnimate];
}
-(void)CreateView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 132, WIDTH, HEIGHT - 132)];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, self.bgView.width, 29)];
    label.text = TransOutput(@"用户注册");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"思源黑体" size:20];
    [self.bgView addSubview:label];
    self.userView.frame = CGRectMake(30, label.bottom + 23, self.bgView.width - 60, 46);
    
    [self.bgView addSubview:self.userView];
    
    self.passView.frame = CGRectMake(30, self.userView.bottom + 16, self.userView.width, 46);
    [self.bgView addSubview:self.passView];
    
    self.liLabel.frame = CGRectMake(30, self.passView.bottom + 16, self.passView.width, 20);
    self.liLabel.text = TransOutput(@"英数字を含む8～18文字で入力してください。");
    
    self.liLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.liLabel];
    
    self.aginPassView.frame = CGRectMake(30, self.liLabel.bottom + 16, self.liLabel.width, 46);
    [self.bgView addSubview:self.aginPassView];
    
    self.userNickNameView.frame = CGRectMake(30, self.aginPassView.bottom + 16, self.aginPassView.width, 46);
    [self.bgView addSubview:self.userNickNameView];
    
    self.birBtnView.frame = CGRectMake(30, self.userNickNameView.bottom + 16, self.userNickNameView.width, 46);
    self.birBtnView.customTF.delegate = self;
    [self.bgView addSubview:self.birBtnView];
    
    self.sexBtnView.frame = CGRectMake(30, self.birBtnView.bottom + 16, self.birBtnView.width, 46);
    self.sexBtnView.customTF.delegate = self;
    [self.bgView addSubview:self.sexBtnView];
   
    self.phoneBtnView.frame = CGRectMake(30, self.sexBtnView.bottom + 16, (WIDTH - 60 - 48) / 2, 46);
    [self.bgView addSubview: self.phoneBtnView];
    
    self.emilBtnView.frame = CGRectMake(30 + (WIDTH - 60 - 48) / 2, self.sexBtnView.bottom + 16, (WIDTH - 60) / 2, 46);
    [self.bgView addSubview: self.emilBtnView];
    
    self.phoneView.frame = CGRectMake(30, self.phoneBtnView.bottom + 16, self.birBtnView.width, 46);
    [self.bgView addSubview: self.phoneView];
    
    self.codeView.frame = CGRectMake(30, self.phoneView.bottom + 24,  self.birBtnView.width, 46);
    [self.bgView addSubview:self.codeView];
    
    self.codeBtnView.frame = CGRectMake(self.codeView.width - 127, 5,  122, 37);
    [self.codeView addSubview:self.codeBtnView];
    
    self.reginBtnView.frame = CGRectMake(30, self.codeView.bottom + 16,  self.birBtnView.width, 48);
    [self.bgView addSubview:self.reginBtnView];
    
    self.agreeBtnView.frame = CGRectMake(30, self.reginBtnView.bottom + 60,  self.birBtnView.width, 40);
    [self.bgView addSubview:self.agreeBtnView];
    self.scrollView.contentSize = CGSizeMake(WIDTH, self.agreeBtnView.bottom + 16);
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.sexBtnView.customTF) {
        [self keyReturn];
        [self choseSex];
        return NO;
    }
    if (textField == self.birBtnView.customTF) {
        [self keyReturn];
        [self choseBirthday];
        return NO;
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = textField.text.length + string.length - range.length;
   
    if (textField == self.userView.customTF) {
        return newLength <= 20;
    }else{
        return newLength <= 50;
    }
}
-(UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 0, WIDTH - 48, HEIGHT)];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.contentMode = UIViewContentModeScaleToFill;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
    
}
-(resignCustomTFView *)userView{
    if (!_userView) {
        _userView = [[resignCustomTFView alloc] init];
        _userView.customTF.placeholder = TransOutput(@"ユーザーID");
        _userView.customTF.delegate  = self;
        _userView.layer.cornerRadius = 23;
        _userView.clipsToBounds = YES;
        [_userView.customTF addPlachColor:TransOutput(@"ユーザーID") color:RGB(0x797676)];
      
    }
    return _userView;
}
-(resginPassCustomTFView *)passView{
    if (!_passView) {
        _passView = [[resginPassCustomTFView alloc] init];
        _passView.customTF.placeholder = TransOutput(@"パスワード");
        _passView.layer.cornerRadius = 23;
        _passView.clipsToBounds = YES;
        
        [_passView.customTF addPlachColor:TransOutput(@"パスワード") color:RGB(0x797676)];
    }
    return _passView;
}
-(UILabel *)liLabel{
    if (!_liLabel) {
        _liLabel = [[UILabel alloc] init];
        _liLabel.font = [UIFont systemFontOfSize:12];
        _liLabel.textColor = RGB(0xFD9329);
    }
    return _liLabel;
}
-(resginPassCustomTFView *)aginPassView{
    if (!_aginPassView) {
        _aginPassView = [[resginPassCustomTFView alloc] init];
        _aginPassView.customTF.placeholder = TransOutput(@"パスワード再入力");
        _aginPassView.layer.cornerRadius = 23;
        _aginPassView.clipsToBounds = YES;
        
        [_aginPassView.customTF addPlachColor:TransOutput(@"パスワード再入力") color:RGB(0x797676)];
    }
    return _aginPassView;

    
}
-(resignCustomTFView *)userNickNameView{
    if (!_userNickNameView) {
        _userNickNameView = [[resignCustomTFView alloc] init];
        _userNickNameView.customTF.placeholder = TransOutput(@"ニックネーム");
        _userNickNameView.customTF.delegate = self;
        _userNickNameView.layer.cornerRadius = 23;
        _userNickNameView.clipsToBounds = YES;
        [_userNickNameView.customTF addPlachColor:TransOutput(@"ニックネーム") color:RGB(0x797676)];
    }
    return _userNickNameView;

    
}
- (resignCustomTFView *)birBtnView{
    if (!_birBtnView) {
        _birBtnView = [[resignCustomTFView alloc] init];
        _birBtnView.customTF.placeholder = TransOutput(@"生年月日");
        _birBtnView.layer.cornerRadius = 23;
        _birBtnView.clipsToBounds = YES;
        [_birBtnView.customTF addPlachColor:TransOutput(@"生年月日") color:RGB(0x797676)];
        }
       
           
       
      
    return _birBtnView;
}
-(void)keyReturn{
    if ([self.userNickNameView.customTF isFirstResponder]) {
        [self.userNickNameView.customTF resignFirstResponder];
    }
    if ([self.passView.customTF isFirstResponder]) {
        [self.passView.customTF resignFirstResponder];
    }
    if ([self.aginPassView.customTF isFirstResponder]) {
        [self.aginPassView.customTF resignFirstResponder];
    }
    if ([self.userNickNameView.customTF isFirstResponder]) {
        [self.userNickNameView.customTF resignFirstResponder];
    }
    if ([self.phoneView.customTF isFirstResponder]) {
        [self.phoneView.customTF resignFirstResponder];
    }
    if ([self.codeView.customTF isFirstResponder]) {
        [self.codeView.customTF resignFirstResponder];
    }
}
-(void)choseBirthday{
    self.datePicker = [[BRDatePickerView alloc] init];
    self.datePicker.pickerMode = BRDatePickerModeDate;
    self.datePicker.title = TransOutput(@"生年月日");
    
    self.datePicker.selectValue = self.birBtnView.customTF.text;
    self.datePicker.minDate = [NSDate br_setYear:1950 month:1];
    self.datePicker.maxDate = [NSDate date];
   
    self.datePicker.isAutoSelect = NO;
@weakify(self)
    self.datePicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        @strongify(self)
        self.birBtnView.customTF.text = selectValue;
        self.birStr = selectValue;
       
};
     BRPickerStyle *customStyle = [[BRPickerStyle alloc] init];
     customStyle.hiddenCancelBtn = YES;
     customStyle.doneBtnTitle = TransOutput(@"确定");
     customStyle.doneTextFont = [UIFont systemFontOfSize:16];
     customStyle.doneTextColor = [UIColor blackColor];
     customStyle.hiddenTitleLine = YES;
     customStyle.topCornerRadius = 16;
    customStyle.language = @"zh";
     self.datePicker.pickerStyle = customStyle;
    [self.datePicker show];
}
- (resignCustomTFView *)sexBtnView{
    if (!_sexBtnView) {
        _sexBtnView = [[resignCustomTFView alloc] init];
        _sexBtnView.customTF.placeholder = TransOutput(@"性別選択");
        _sexBtnView.layer.cornerRadius = 23;
        _sexBtnView.clipsToBounds = YES;
        [_sexBtnView.customTF addPlachColor:TransOutput(@"性別選択") color:RGB(0x797676)];
        }
       
           
       
    return _sexBtnView;
}
- (UIButton *)phoneBtnView{
    if (!_phoneBtnView) {
        _phoneBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtnView layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        [_phoneBtnView setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
        
        [_phoneBtnView setTitle:TransOutput(@"手机认证") forState:UIControlStateNormal];
        [_phoneBtnView setTitleColor:RGB(0x8A8989) forState:UIControlStateNormal];
        _phoneBtnView.titleLabel.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        [_phoneBtnView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self)
            self.validateType = 0;
            [self.phoneBtnView setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
            
            [self.emilBtnView setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
            self.phoneView.customTF.placeholder = TransOutput(@"请输入手机号(示例:090-1234-5678)");
            
        }];
    }
    return _phoneBtnView;
}
- (UIButton *)emilBtnView{
    if (!_emilBtnView) {
        _emilBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emilBtnView layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        
        [_emilBtnView setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
        [_emilBtnView setTitle:TransOutput(@"邮箱认证") forState:UIControlStateNormal];
        [_emilBtnView setTitleColor:RGB(0x8A8989) forState:UIControlStateNormal];
        _emilBtnView.titleLabel.font = [UIFont systemFontOfSize:14];
        @weakify(self)
        [_emilBtnView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self)
            self.validateType = 1;
            [self.phoneBtnView setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
            
            [self.emilBtnView setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
            self.phoneView.customTF.placeholder = TransOutput(@"请输入邮箱地址");
            
        }];
    }
    return _emilBtnView;
}
-(resignCustomTFView *)phoneView{
    if (!_phoneView) {
      
        _phoneView = [[resignCustomTFView alloc] init];
        _phoneView.customTF.placeholder = TransOutput(@"请输入手机号(示例:090-1234-5678)");
        _phoneView.layer.cornerRadius = 23;
        _phoneView.clipsToBounds = YES;
        [_phoneView.customTF addPlachColor:TransOutput(@"请输入手机号(示例:090-1234-5678)") color:RGB(0x797676)];
        }
        return _phoneView;

    
}
-(UIButton *)codeBtnView{
    if (!_codeBtnView) {
        _codeBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeBtnView setTitle:TransOutput(@"发送验证码") forState:UIControlStateNormal];
        _codeBtnView.titleLabel.font = [UIFont systemFontOfSize:14];
        _codeBtnView.backgroundColor = RGB(0x3ED196);
        _codeBtnView.layer.cornerRadius = 18.5;
        _codeBtnView.clipsToBounds = YES;
       
        @weakify(self);
        [_codeBtnView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.phoneView.customTF.text.length == 0) {
                ToastShow(TransOutput(@"请输入手机号/邮箱"), errImg,RGB(0xFF830F));
                return;
            }
            [self getCode];
        }];
        
    }
    return _codeBtnView;
}
///发送验证码
-(void)getCode{
    NSString *str = [NSString stringWithFormat:@"validateAccount=%@",self.phoneView.customTF.text];
   
    
    [NetwortTool loginWithRegisterGetCode:str Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"发送成功"), @"chenggong",RGB(0x36D053));
        [self startDaoTime];
    } failure:^(NSError * _Nonnull error) {
        
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)startDaoTime{
    self.timecount = 120;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (self.timecount <= 1) {
            [self uninitTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束
                self.timecount = 120;
                [self changeResendBtnStatus:YES];
                [self.codeBtnView setTitle:TransOutput(@"发送验证码") forState:UIControlStateNormal];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时进行中
                [self changeResendBtnStatus:NO];
                [self.codeBtnView setTitle:[NSString stringWithFormat:@"%ld s",self.timecount] forState:UIControlStateNormal];
            });
            self.timecount--;
        }
    });
    dispatch_resume(_timer);
}
- (void)changeResendBtnStatus:(BOOL)enable {
    self.codeBtnView.enabled = enable;
  
}
- (void)uninitTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
-(resignCustomTFView *)codeView{
    if (!_codeView) {
      
        _codeView = [[resignCustomTFView alloc] init];
        _codeView.isCode = YES;
        _codeView.customTF.placeholder = TransOutput(@"请输入验证码");
        _codeView.layer.cornerRadius = 23;
        _codeView.clipsToBounds = YES;
        [_codeView.customTF addPlachColor:TransOutput(@"请输入验证码") color:RGB(0x797676)];
        }
        return _codeView;

    
}
-(UIButton *)reginBtnView{
    if (!_reginBtnView) {
        _reginBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _reginBtnView.layer.cornerRadius = 24;
        _reginBtnView.clipsToBounds = YES;
       
        _reginBtnView.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 60];
        [_reginBtnView setTitle:TransOutput(@"注册") forState:UIControlStateNormal];
        _reginBtnView.titleLabel.font = [UIFont systemFontOfSize:18];
        _reginBtnView.userInteractionEnabled = YES;
        [_reginBtnView addTarget:self action:@selector(resignTap) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _reginBtnView;
   
    

}

-(UITextView *)agreeBtnView{
    if (!_agreeBtnView) {
        _agreeBtnView = [[UITextView alloc] init];
        _agreeBtnView.layer.cornerRadius = 20;
        _agreeBtnView.clipsToBounds = YES;
        _agreeBtnView.backgroundColor = [UIColor clearColor];
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
        _agreeBtnView.delegate = self;
        _agreeBtnView.attributedText =attstring;
        _agreeBtnView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0); // 上 左 下 右
        _agreeBtnView.textAlignment = NSTextAlignmentCenter; // 设置文本居中
        _agreeBtnView.editable = NO; // 如果你不希望用户编辑文本，设置为NO
     
    }
    return _agreeBtnView;
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
   

  
        vc.url = @"http://agree.netneto.jp/privacy_policy.html";
       
   
    
    [self  pushController:vc];
}
-(void)handleTap{
  
    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];

        
        vc.url = @"https://netneto.com/user_protocol.html";
       
   
    
    [self  pushController:vc];
    
}
-(void)resignTap{
    
    if (self.userView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入账号") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (self.passView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入密码") ,errImg,RGB(0xFF830F));
        return;
    }
    
    
   else if (self.aginPassView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请再次输入密码") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (![self.aginPassView.customTF.text isEqual:self.passView.customTF.text]) {
       ToastShow(TransOutput(@"密码不一致") ,errImg,RGB(0xFF830F));
       return;
   }
   else if (self.userNickNameView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入昵称") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (self.birStr.length == 0) {
        ToastShow(TransOutput(@"请设置生日") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (self.sexStr.length == 0) {
        ToastShow(TransOutput(@"请选择性别") ,errImg,RGB(0xFF830F));
        return;
    }
    
   else if (self.phoneView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号/邮箱") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (self.codeView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入验证码") ,errImg,RGB(0xFF830F));
        return;
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORDSTR];
    BOOL emailValid = [emailTest evaluateWithObject:self.passView.customTF.text];

    if (!emailValid) {
    
        ToastShow(TransOutput(@"密码必须是8-18位，包含数字，字母和特殊符号"), errImg,RGB(0xFF830F));
        return;
    }
    NSString *nameStr = @"mobile";
    if (self.validateType == 1) {
        nameStr = @"userMail";
    }
    
    NSString *passStr = [NSString stringWithFormat:@"%@%@",[Tool getCurrentTimeNumber],self.passView.customTF.text];
 
    NSString *str = [AESManager encrypt:passStr key:AESKEY] ;
    
    NSDictionary *parm = @{@"validateType":@(self.validateType),
                           @"userAccount":self.userView.customTF.text,
                           @"verificationCode":self.codeView.customTF.text,
                           @"passWord":str,
                           nameStr:self.phoneView.customTF.text,
                           @"nickName":self.userNickNameView.customTF.text,
                           @"birthDate":self.birStr,
                           @"sex":self.sexStr};
    
    [NetwortTool registerWithGetData:parm Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"注册成功") ,@"chenggong",RGB(0x36D053));

        [self popViewControllerAnimate];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],errImg,RGB(0xFF830F));
    }];
    
    
}
-(void)choseSex{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TransOutput(@"性別選択") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAlert = [UIAlertAction actionWithTitle:TransOutput(@"男") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.sexBtnView.customTF.text =TransOutput(@"男");
       
        self.sexStr = @"M";
    }];
    [maleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
   
    UIAlertAction *femaleAlert = [UIAlertAction actionWithTitle:TransOutput(@"女") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
      
        self.sexBtnView.customTF.text =TransOutput(@"女");
       
        self.sexStr = @"F";
    }];
    [femaleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
   
    UIAlertAction *otherAlert = [UIAlertAction actionWithTitle:TransOutput(@"其他") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexBtnView.customTF.text =TransOutput(@"其他");
       
        self.sexStr = @"O";
    }];
    [otherAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancle setValue:RGB(0x333333) forKey:@"_titleTextColor"];
   
    [alert addAction:maleAlert];
    [alert addAction:femaleAlert];
    [alert addAction:otherAlert];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
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
