//
//  CancelAccountViewController.m
//  Netneto
//
//  Created by apple on 2024/11/6.
//

#import "CancelAccountViewController.h"

@interface CancelAccountViewController ()
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLbale;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseStrBtn;

@end

@implementation CancelAccountViewController
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
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
    self.navigationItem.title = TransOutput(@"注销账户");
    self.titleLabel.text = TransOutput(@"为保障您的权益，请再次确认:");
    self.subLbale.text = TransOutput(@"注销提示");
    self.sureBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    [self.sureBtn setTitle:TransOutput(@"注销") forState:UIControlStateNormal];
    @weakify(self)
    [self.sureBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        if(!self.choseBtn.selected){
            ToastShow(TransOutput(@"请勾选注销协议"), errImg, RGB(0xFF830F));
            return;
        }
        
                CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"确定注销？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
                   
                    [self cancelUser];
                } cancelBlock:^{
        
                }];
                [alert show];
    }];
    
    [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [self.choseStrBtn setTitle:TransOutput(@"勾选注销协议") forState:UIControlStateNormal];
    self.choseStrBtn.titleLabel.numberOfLines = 0;
    [self.choseBtn addTarget:self action:@selector(choseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)choseClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [self.choseBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    }
    else{
        sender.selected = NO;
        [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    }
}

-(void)cancelUser{
    [NetwortTool getCancelUserWithParm:self.parm Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"注销成功"), @"chenggong",RGB(0x36D053));
      [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCollec" object:nil userInfo:nil];
        [account logoutCancel];
         
        } failure:^(NSError * _Nonnull error) {
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
