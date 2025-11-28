//
//  ModyPassViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/27.
//

#import "ModyPassViewController.h"

@interface ModyPassViewController ()
@property (weak, nonatomic) IBOutlet UIButton *eye1;
@property (weak, nonatomic) IBOutlet UIButton *eye2;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UITextField *againPass;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic, strong)UIImageView *bgHeaderView;

@end

@implementation ModyPassViewController

-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
     UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"修改密码");
    self.pass.placeholder = TransOutput(@"请输入新密码");
    self.againPass.placeholder = TransOutput(@"重新输入新密码");
    [self.saveBtn setTitle:TransOutput(@"变更") forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    @weakify(self)
    [self.saveBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        [self updatePass];
    }];
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(void)updatePass{
    if (self.pass.text.length == 0) {
        ToastShow(TransOutput(@"请输入新密码"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.againPass.text.length == 0) {
        ToastShow(TransOutput(@"请再次输入新密码"), errImg,RGB(0xFF830F));
        return;
    }
    if (![self.pass.text isEqual:self.againPass.text]) {
        ToastShow(TransOutput(@"密码不一致"), errImg,RGB(0xFF830F));
        return;
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORDSTR];
    BOOL emailValid = [emailTest evaluateWithObject:self.pass.text];

    if (!emailValid) {
    
        ToastShow(TransOutput(@"密码必须是8-18位，包含数字，字母和特殊符号"), errImg,RGB(0xFF830F));
     
        return;
    }
    NSString *passStr = [NSString stringWithFormat:@"%@%@",[Tool getCurrentTimeNumber],self.pass.text];

  
    NSLog(@"用户信息：%@",account.userInfo.userId);
    
    NSDictionary *dic =@{@"userId":account.userInfo.userId,@"password":[AESManager encrypt:passStr key:AESKEY]};
    
    
    
    [NetwortTool getUpdatePwdWithParm:dic Success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqual:@"00000"]) {
            ToastShow(TransOutput(@"修改成功,请重新登录"), @"chenggong",RGB(0x36D053));
            [account logoutCancel];

        }
        else {
            ToastShow(responseObject[@"msg"],@"矢量 20",RGB(0xFF830F));
        }
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}

- (IBAction)eyePass:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.eye1 setImage:[UIImage imageNamed:@"login_password_show"] forState:UIControlStateNormal];
        self.pass.secureTextEntry = NO;
        
    }else{
        sender.selected = NO;
        [self.eye1 setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
        self.pass.secureTextEntry = YES;
    }
}
- (IBAction)eyeAgainPass:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self.eye2 setImage:[UIImage imageNamed:@"login_password_show"] forState:UIControlStateNormal];
        self.againPass.secureTextEntry = NO;
        
    }else{
        sender.selected = NO;
        [self.eye2 setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
        self.againPass.secureTextEntry = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
