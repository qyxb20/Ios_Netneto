//
//  CodeViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/18.
//

#import "CodeViewController.h"

@interface CodeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *liLabel;
@property (nonatomic, assign) NSInteger timecount;
@property (nonatomic, strong) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UITextView *agreeTx;

@end

@implementation CodeViewController
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
    [self popViewControllerAnimate];
}
-(void)returnKeyBord{
    if ([self.phoneTF isFirstResponder]) {
        [self.phoneTF resignFirstResponder];
        
    }
    else  if ([self.codeTF isFirstResponder]) {
        [self.codeTF resignFirstResponder];
    }
}
-(void)CreateView{
    self.liLabel.text = [NSString stringWithFormat:@"(%@:090-1234-5678)",TransOutput(@"示例")];
    
    self.phoneTF.placeholder =TransOutput(@"携帯電話番号またはメールアドレス");
    [self.codeBtn setTitle:TransOutput(@"发送验证码") forState:UIControlStateNormal];
    self.codeTF.placeholder = TransOutput(@"请输入验证码");
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
    
    self.codeBtn.backgroundColor = [UIColor gradientColorArr:@[RGB(0x3ED196),RGB(0x3ED196)] withWidth:102];
    @weakify(self);
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self returnKeyBord];
    }];
    
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
- (IBAction)phoneClick:(id)sender {
    [self popViewControllerAnimate];
    
}
- (IBAction)codeTapAction:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号/邮箱"),@"矢量 20",RGB(0xFF830F));
        return;
    }
   
    NSString *str = [NSString stringWithFormat:@"validateAccount=%@",self.phoneTF.text];
   
    
    [NetwortTool loginWithGetCode:str Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"发送成功"), @"chenggong",RGB(0x36D053));
        [self startDaoTime];
    } failure:^(NSError * _Nonnull error) {
        
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
}

- (IBAction)loginClick:(UIButton *)sender {
    if (self.phoneTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号/邮箱"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    if (self.codeTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入验证码"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    [NetwortTool loginWithCode:@{@"userName":self.phoneTF.text,@"verificationCode":self.codeTF.text} Success:^(id  _Nonnull responseObject) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCollec" object:nil userInfo:nil];
        account.user = [userModel mj_objectWithKeyValues:responseObject];
        [account loadResource];
        [account loadBank];
        [account loadRootController];
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
                [self.codeBtn setTitle:TransOutput(@"发送验证码") forState:UIControlStateNormal];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时进行中
                [self changeResendBtnStatus:NO];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%ld s",self.timecount] forState:UIControlStateNormal];
            });
            self.timecount--;
        }
    });
    dispatch_resume(_timer);
}
- (void)uninitTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
- (void)changeResendBtnStatus:(BOOL)enable {
    self.codeBtn.enabled = enable;
  
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
