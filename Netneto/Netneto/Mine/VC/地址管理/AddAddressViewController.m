//
//  AddAddressViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/27.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *receviLabel;
@property (weak, nonatomic) IBOutlet UITextField *receTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UILabel *emaiCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaTF;

@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UITextField *addTF;
@property (weak, nonatomic) IBOutlet UIButton *morenBtn;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)AddressSelView *addSelectView;
@property(nonatomic, strong) NSString *commonAddr;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger cityareaId;

@end

@implementation AddAddressViewController
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
    
    self.commonAddr = @"0";
    self.areaId = 0;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}

-(void)CreateView{
    self.addSelectView = [AddressSelView initViewNIB];
    self.addSelectView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    
    self.view.backgroundColor = RGB(0xF9F9F9);
  
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"添加地址");
    self.receviLabel.text = TransOutput(@"收货人:");
    self.receTF.placeholder = TransOutput(@"请输入姓名");
    
    self.phoneLabel.text = TransOutput(@"手机号码:");
    self.phoneTF.placeholder = TransOutput(@"请输入手机号(示例:090-1234-5678)");
    
    self.emaiCodeLabel.text = TransOutput(@"邮政编码");
    self.emailCodeTF.placeholder = TransOutput(@"请输入邮政编码");
    self.emailCodeTF.delegate = self;
    
    self.areaLabel.text = TransOutput(@"所在地区:");
    self.areaTF.text = TransOutput(@"请选择");
//    [self.areaTF setCustomPlaceholderWithText:TransOutput(@"请选择") Color:[UIColor lightGrayColor] font:12] ;
    @weakify(self);
    [self.areaTF addTapAction:^(UIView * _Nonnull view) {
        [self.view addSubview:self.addSelectView];
        if (![self.areaTF.text isEqual:TransOutput(@"请选择")]) {
            [self.addSelectView upshow:self.areaTF.text areId:self.areaId cityAreId:self.cityareaId];
        }
        @weakify(self);
        [self.addSelectView setSureBlock:^(NSString * _Nonnull addressStr, NSString * _Nonnull postalCode, NSInteger cityAreaId, NSInteger areaId) {
            
        
        
            @strongify(self);
            self.areaId = areaId;
            self.cityareaId = cityAreaId;
            self.areaTF.text = addressStr;
            self.areaTF.textColor = [UIColor blackColor];
            self.emailCodeTF.text = postalCode;
        }];
    }];
//    self.areaTF.delegate = self;
    self.addLabel.text = TransOutput(@"详细地址:");
    self.addTF.placeholder = TransOutput(@"如楼号/单元/门牌号");
    
    [self.morenBtn setTitle:TransOutput(@"设置为默认地址") forState:UIControlStateNormal];
    
    [self.sureBtn setTitle:TransOutput(@"保存收货地址") forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    
    self.receTF.text = [NSString isNullStr:self.model.receiver];
    self.phoneTF.text = [NSString isNullStr:self.model.mobile];
    self.emailCodeTF.text = [NSString isNullStr:self.model.postCode];
    if (self.model.province.length > 0) {
        self.areaTF.textColor = [UIColor blackColor];
        self.areaTF.text = [NSString stringWithFormat:@"%@%@%@",[NSString isNullStr:self.model.province],[NSString isNullStr:self.model.city],[NSString isNullStr:self.model.area]];
    }
   
    self.addTF.text = [NSString isNullStr:self.model.addr];
    if ([self.model.commonAddr isEqual:@"1"]) {
        self.commonAddr = @"1";
        [self.choseBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    }
    else{
        self.commonAddr = @"0";
        [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    }
    
   
    [self.sureBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self saveAddress];
    }];
    
    [self.searchBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self searchEmailCode];
    }];
}
-(void)saveAddress{
    if (self.receTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入姓名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.phoneTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号码"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.emailCodeTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入邮政编码"), errImg,RGB(0xFF830F));
        return;
    }
    if ([self.areaTF.text isEqual:TransOutput(@"请选择")]) {
        ToastShow(TransOutput(@"请选择地区"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.addTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入详细地址"), errImg,RGB(0xFF830F));
        return;
    }
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
    BOOL phoneValid = [phoneTest evaluateWithObject:self.phoneTF.text];

    if (!phoneValid) {
    
        ToastShow(TransOutput(@"手机号格式错误"), errImg,RGB(0xFF830F));
        return;
    }
    
    if (self.isMody) {
        NSDictionary *parm = @{@"receiver":self.receTF.text,@"addr":[NSString stringWithFormat:@"%@",self.addTF.text],@"postCode":self.emailCodeTF.text,@"mobile":self.phoneTF.text,@"addrId":self.model.addrId,@"commonAddr":self.commonAddr};
        [NetwortTool getUpdateAddressWithParm:parm Success:^(id  _Nonnull responseObject) {
            
            NSString *msg =  [NSString stringWithFormat:@"%@「%@」%@",TransOutput(@"收货人"),self.receTF.text,TransOutput(@"地址修改成功")];
            
            ToastShow(TransOutput(msg),@"chenggong",RGB(0x36D053));
//            ToastShow(TransOutput(@"保存成功"),@"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }else{
        NSDictionary *parm = @{@"receiver":self.receTF.text,@"addr":[NSString stringWithFormat:@"%@",self.addTF.text],@"postCode":self.emailCodeTF.text,@"mobile":self.phoneTF.text,@"commonAddr":self.commonAddr};
        [NetwortTool getSaveAddressWithParm:parm Success:^(id  _Nonnull responseObject) {
            ToastShow(TransOutput(@"保存成功"),@"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
}
- (IBAction)choseClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.commonAddr = @"1";
        [self.choseBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
   
    }
    else{
        sender.selected = NO;
        self.commonAddr = @"0";
        [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    }
}

-(void)searchEmailCode{
    if (self.emailCodeTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入邮政编码"), errImg,RGB(0xFF830F));
        return;
    }
    [HudView showHudForView:self.view];
    [NetwortTool getListByPostCodeWithParm:@{@"postCode":self.emailCodeTF.text} Success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
        NSLog(@"根据code获取地址：%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"%@",responseObject];
        if ([str isEqual:@"<null>"]) {
            ToastShow(TransOutput(@"未匹配到相应地址"), errImg,RGB(0xFF830F));
            self.areaTF.text = TransOutput(@"请选择");
            self.areaTF.textColor = [UIColor lightGrayColor];
        }else{
            if (str.length > 0) {
                self.areaTF.text = str;
                self.areaTF.textColor = [UIColor blackColor];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.emailCodeTF) {
        self.areaTF.text = TransOutput(@"请选择");
        self.areaTF.textColor = [UIColor lightGrayColor];
    }
    return YES;
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
