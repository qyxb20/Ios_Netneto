//
//  addContactViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/25.
//

#import "addContactViewController.h"

@interface addContactViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *jiaTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yaoTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTX;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *yaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nB;
@property (weak, nonatomic) IBOutlet UILabel *jB;
@property (weak, nonatomic) IBOutlet UILabel *pB;
@property (weak, nonatomic) IBOutlet UILabel *eB;
@property (weak, nonatomic) IBOutlet UILabel *yB;
@property (weak, nonatomic) IBOutlet UILabel *cB;

@end

@implementation addContactViewController
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
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"联系我们");
    self.nameLabel.text = TransOutput(@"名称:");
    self.jiaLabel.text = TransOutput(@"假名:");
    self.phoneLabel.text = TransOutput(@"电话号码:");
    self.emailLabel.text = TransOutput(@"电子邮件:");
    self.yaoLabel.text = TransOutput(@"要件:");
    self.contentLabel.text = TransOutput(@"咨询内容:");
    self.nB.text = TransOutput(@"(必填)");
    self.jB.text = TransOutput(@"(必填)");
    self.pB.text = TransOutput(@"(必填)");
    self.eB.text = TransOutput(@"(必填)");
    self.yB.text = TransOutput(@"(必填)");
    self.cB.text = TransOutput(@"(必填)");
    
    [self.sendBtn setTitle:TransOutput(@"发送") forState:UIControlStateNormal];
    self.sendBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    self.nameTF.placeholder = TransOutput(@"请输入名称");
    self.jiaTF.placeholder = TransOutput(@"请输入假名");
    self.emailTF.placeholder = TransOutput(@"请输入电子邮件");
    self.phoneTF.placeholder = TransOutput(@"请输入电话号码(示例:090-1234-5678)");
    self.yaoTF.placeholder = TransOutput(@"请输入要件");
    [self.contentTX setPlaceholderWithText:TransOutput(@"请输入咨询内容(500字以内)") Color:RGB(0xBBB8B8)];
    self.contentTX.delegate = self;
    self.nameTF.text = [NSString isNullStr:self.model.userName];
    self.jiaTF.text = [NSString isNullStr:self.model.nickName];
    self.phoneTF.text = [NSString isNullStr:self.model.contact];
    self.yaoTF.text = [NSString isNullStr:self.model.topic];
    self.contentTX.text = [NSString isNullStr:self.model.content];
    self.emailTF.text = [NSString isNullStr:self.model.email];
    @weakify(self)
    [self.sendBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self sendClick];
    }];
    
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = textView.text.length + text.length - range.length;
   
   
    
    return newLength <= 500;
   
}
-(void)sendClick{
    if (self.nameTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入名称"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.jiaTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入假名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.phoneTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号码"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.emailTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入电子邮件"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.yaoTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入要件"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.contentTX.text.length == 0) {
        ToastShow(TransOutput(@"请输入咨询内容"), errImg,RGB(0xFF830F));
        return;
    }
  

    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
    BOOL phoneValid = [phoneTest evaluateWithObject:self.phoneTF.text];

    if (!phoneValid) {
    
        ToastShow(TransOutput(@"手机号格式错误"), errImg,RGB(0xFF830F));
        return;
    }
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAILSTR];
    BOOL emailValid = [emailTest evaluateWithObject:self.emailTF.text];

    if (!emailValid) {
    
        ToastShow(TransOutput(@"邮箱格式错误"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.model) {
        [HudView showHudForView:self.view];
        [NetwortTool modyContactWithParm:@{@"id":self.model.idStr, @"userName":self.nameTF.text,@"nickName":self.jiaTF.text,@"email":self.emailTF.text,@"contact":self.phoneTF.text,@"topic":self.yaoTF.text,@"content":self.contentTX.text} Success:^(id  _Nonnull responseObject) {
            [HudView hideHudForView:self.view];
            ToastShow(TransOutput(@"提交成功"), @"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }else{
        [HudView showHudForView:self.view];
        [NetwortTool addContactWithParm:@{@"userName":self.nameTF.text,@"nickName":self.jiaTF.text,@"email":self.emailTF.text,@"contact":self.phoneTF.text,@"topic":self.yaoTF.text,@"content":self.contentTX.text} Success:^(id  _Nonnull responseObject) {
            [HudView hideHudForView:self.view];
            ToastShow(TransOutput(@"提交成功"), @"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
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
