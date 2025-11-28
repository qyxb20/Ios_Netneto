//
//  ModeyShopInfoViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/5.
//

#import "ModeyShopInfoViewController.h"

@interface ModeyShopInfoViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *shopAddView;
@property (weak, nonatomic) IBOutlet UIView *shopAddresView;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextView *desTX;
@property (weak, nonatomic) IBOutlet UILabel *emailCodelLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *shopAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddTF;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *shopAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *nexBtn;
@property(nonatomic, strong)AddressSelView *addSelectView;
@property (weak, nonatomic) IBOutlet UIView *shopNameView;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
@property (nonatomic, strong) NSString *avaStr;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger cityareaId;

@property (nonatomic, assign) NSInteger areaIdRefun;
@property (nonatomic, assign) NSInteger cityareaIdRefun;
@property (weak, nonatomic) IBOutlet UILabel *shopIndo;
@property (weak, nonatomic) IBOutlet UILabel *refunCodelLabel;
@property (weak, nonatomic) IBOutlet UITextField *refunCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *refunAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *refunAddTF;
@property (weak, nonatomic) IBOutlet UILabel *refunAddInfoLabel;

@property (weak, nonatomic) IBOutlet UITextField *refunAddInfoTF;

@end

@implementation ModeyShopInfoViewController
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
    self.areaId = 0;
    self.areaIdRefun = 0;
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    
    self.shopNameTipLabel.text = TransOutput(@"店铺名称");
    self.phoneLabel.text = TransOutput(@"携帯電話");
    self.shopIndo.text = TransOutput(@"店铺简介");
    self.shopNameTF.placeholder = TransOutput(@"请输入店铺名称");
    self.shopNameTF.delegate = self;
    
    self.phoneTF.placeholder = TransOutput(@"请输入联系电话(示例:090-1234-5678)");
    self.desTX.delegate = self;
    [self.desTX setPlaceholderWithText:TransOutput(@"请输入商品描述") Color:RGB(0xB3B3B3)];
    self.emailCodelLabel.text = TransOutput(@"邮政编码");
    self.emailCodeTF.placeholder = TransOutput(@"请输入邮政编码");
    self.shopAddLabel.text = TransOutput(@"店铺地址");
   
//    self.shopAddTF.delegate = self;
    self.emailCodeTF.delegate = self;
//    self.refunAddTF.delegate = self;
    self.refunCodeTF.delegate = self;
    self.shopAddressLabel.text = TransOutput(@"店铺详细地址");
    self.shopAddressTF.placeholder = TransOutput(@"如楼号/单元/门牌号");
    self.refunCodelLabel.text = TransOutput(@"退货编码");
    self.refunCodeTF.placeholder = TransOutput(@"请输入退货邮编");
    self.refunAddLabel.text = TransOutput(@"退货地址");
    
//    [self.refunAddTF setCustomPlaceholderWithText:TransOutput(@"请选择退货地址") Color:[UIColor lightGrayColor] font:12];
    self.shopAddTF.text = TransOutput(@"请选择店铺地址");
    self.refunAddTF.text =TransOutput(@"请选择退货地址");
    
    @weakify(self);
    
    [self.shopAddTF addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self.view addSubview:self.addSelectView];
        if (![self.shopAddTF.text isEqual:TransOutput(@"请选择店铺地址")]) {
            [self.addSelectView upshow:self.shopAddTF.text areId:self.areaId cityAreId:self.cityareaId];
        }
        @weakify(self);
        [self.addSelectView setSureBlock:^(NSString * _Nonnull addressStr, NSString * _Nonnull postalCode, NSInteger cityAreaId, NSInteger areaId) {
            
        
        
            @strongify(self);
            self.areaId = areaId;
            self.cityareaId = cityAreaId;
            self.shopAddTF.text = addressStr;
            self.shopAddTF.textColor = [UIColor blackColor];
            self.emailCodeTF.text = postalCode;
        }];
    }];
    [self.refunAddTF addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self.view addSubview:self.addSelectView];
        if (![self.refunAddTF.text isEqual:TransOutput(@"请选择退货地址")]) {
            [self.addSelectView upshow:self.refunAddTF.text areId:self.areaIdRefun cityAreId:self.cityareaIdRefun];
        }
       
        [self.addSelectView setSureBlock:^(NSString * _Nonnull addressStr, NSString * _Nonnull postalCode, NSInteger cityAreaId, NSInteger areaId) {
            
        
        
            @strongify(self);
            self.areaIdRefun = areaId;
            self.cityareaIdRefun = cityAreaId;
            self.refunAddTF.text = addressStr;
            self.refunCodeTF.text = postalCode;
            self.refunAddTF.textColor = [UIColor blackColor];
            
        }];
    }];
//        .placeholder =TransOutput(@"请选择退货地址");
    self.refunAddInfoLabel.text = TransOutput(@"退货详细地址");
    self.refunAddInfoTF.placeholder = TransOutput(@"如楼号/单元/门牌号");
    
    
    self.nexBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    if ([[self.dataDic allKeys] count] != 0) {
        
        self.shopAddTF.textColor = [UIColor blackColor];
        self.navigationItem.title = TransOutput(@"店铺基本信息");
        self.shopNameView.backgroundColor = RGB(0xF9F9F9);
        self.shopNameTF.text = [NSString isNullStr:self.dataDic[@"shopName"]];
        self.emailView.backgroundColor = RGB(0xF9F9F9);
        self.shopAddView.backgroundColor = RGB(0xF9F9F9);
        self.shopAddresView.backgroundColor = RGB(0xF9F9F9);
        self.shopNameTF.enabled = NO;
        self.phoneTF.text = [NSString isNullStr:self.dataDic[@"tel"]];
        self.desTX.text = [NSString isNullStr:self.dataDic[@"intro"]];
        self.emailCodeTF.text = [NSString isNullStr:self.dataDic[@"postalCode"]];
        self.emailCodeTF.userInteractionEnabled = NO;
        self.shopAddTF.userInteractionEnabled = NO;
        self.shopAddressTF.userInteractionEnabled = NO;
        if ([[NSString isNullStr:self.dataDic[@"province"]] length] != 0) {
            self.shopAddTF.text = [NSString stringWithFormat:@"%@-%@-%@",[NSString isNullStr:self.dataDic[@"province"]],[NSString isNullStr:self.dataDic[@"city"]],[NSString isNullStr:self.dataDic[@"area"]]];
            
        }
       
        
        self.shopAddressTF.text = [NSString isNullStr:self.dataDic[@"shopAddress"]];
        
        self.refunCodeTF.text = [NSString isNullStr:self.dataDic[@"returnPostalCode"]];
        self.refunCodeTF.userInteractionEnabled = YES;
        self.refunAddTF.userInteractionEnabled = YES;
        self.refunAddInfoTF.userInteractionEnabled = YES;
        
        if ([[NSString isNullStr:self.dataDic[@"returnProvince"]] length] != 0) {
            self.refunAddTF.text = [NSString stringWithFormat:@"%@-%@-%@",[NSString isNullStr:self.dataDic[@"returnProvince"]],[NSString isNullStr:self.dataDic[@"returnCity"]],[NSString isNullStr:self.dataDic[@"returnArea"]]];
            self.refunAddTF.textColor = [UIColor blackColor];
            
        }
       
        
        self.refunAddInfoTF.text = [NSString isNullStr:self.dataDic[@"returnAddress"]];
        
        
        [self.picBtn sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:self.dataDic[@"shopLogo"]]] forState:UIControlStateNormal];
        self.delBtn.hidden = NO;
        self.avaStr =[NSString isNullStr:self.dataDic[@"shopLogo"]];
        [self.nexBtn setTitle:TransOutput(@"更新") forState:UIControlStateNormal];
    }
    else{
        self.navigationItem.title = TransOutput(@"开通店铺");
        self.shopNameView.backgroundColor = [UIColor whiteColor];
        self.delBtn.hidden = YES;
        self.shopNameTF.enabled = YES;
        self.picBtn.backgroundColor = RGB(0xF6FAFE);
        self.picBtn.layer.borderColor = RGB(0xA3CCF9).CGColor;
        self.picBtn.layer.borderWidth = 0.5;
        [self.picBtn setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
        [self.picBtn setTitle:TransOutput(@"店铺图片") forState:UIControlStateNormal];
        self.picBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.picBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
        self.picBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.picBtn.contentMode = UIViewContentModeScaleToFill;
        [self.picBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
        [self.nexBtn setTitle:TransOutput(@"提交申请") forState:UIControlStateNormal];
    }
    self.addSelectView = [AddressSelView initViewNIB];
    self.addSelectView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
     
    ////
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)seachCode:(UIButton *)sender {
    [self searchEmailCode];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.emailCodeTF) {
        self.shopAddTF.text = TransOutput(@"请选择店铺地址");
        self.shopAddTF.textColor = [UIColor lightGrayColor];
    }
    if (textField == self.shopNameTF) {
        NSUInteger newLength = textField.text.length + string.length - range.length;
       
        return newLength <= 50;
    }
    
    if (textField == self.refunCodeTF) {
        self.refunAddTF.text = TransOutput(@"请选择退货地址");
        self.refunAddTF.textColor = [UIColor lightGrayColor];
        
    }
    
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
 
        
        NSUInteger newLength = textView.text.length + text.length - range.length;
       
     
        
        return newLength <= 500;

    
   
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
            self.shopAddTF.text = TransOutput(@"请选择店铺地址");
            self.shopAddTF.textColor = [UIColor lightGrayColor];
        }else{
            if (str.length > 0) {
                self.shopAddTF.text = str;
                self.shopAddTF.textColor = [UIColor blackColor];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
   
}
- (IBAction)searchRefunCode:(id)sender {
    if (self.refunCodeTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入退货邮编"), errImg,RGB(0xFF830F));
        return;
    }
    [HudView showHudForView:self.view];
    [NetwortTool getListByPostCodeWithParm:@{@"postCode":self.refunCodeTF.text} Success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
        NSLog(@"根据code获取地址：%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"%@",responseObject];
        if ([str isEqual:@"<null>"]) {
            ToastShow(TransOutput(@"未匹配到相应地址"), errImg,RGB(0xFF830F));
            self.refunAddTF.text = TransOutput(@"请选择退货地址");
            self.refunAddTF.textColor = [UIColor lightGrayColor];
            
        }else{
            if (str.length > 0) {
                self.refunAddTF.text = str;
                self.refunAddTF.textColor = [UIColor blackColor];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    if ([[self.dataDic allKeys] count] != 0) {
        if (self.phoneTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入联系电话"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.emailCodeTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入邮政编码"), errImg,RGB(0xFF830F));
            return;
        }
        if ([self.shopAddTF.text isEqual:TransOutput(@"请选择店铺地址")]) {
            ToastShow(TransOutput(@"请选择店铺地址"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.shopAddressTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入店铺详细地址"), errImg,RGB(0xFF830F));
            return;
        }
        
        if (self.refunCodeTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入退货邮编"), errImg,RGB(0xFF830F));
            return;
        }
        if ([self.refunAddTF.text isEqual:TransOutput(@"请选择退货地址")]) {
            ToastShow(TransOutput(@"请选择退货地址"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.refunAddInfoTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入退货详细地址"), errImg,RGB(0xFF830F));
            return;
        }
        
        
        
        if (self.avaStr.length == 0) {
            ToastShow(TransOutput(@"请选择店铺logo"), errImg,RGB(0xFF830F));
            return;
        }
       
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
        
        BOOL phoneValid = [phoneTest evaluateWithObject:self.phoneTF.text];

        if (!phoneValid) {
        
            ToastShow(TransOutput(@"手机号格式错误"), errImg,RGB(0xFF830F));
            return;
        }
        
        NSArray *arr = [self.shopAddTF.text componentsSeparatedByString:@"-"];
        NSString *area = @"";
        if (arr.count == 3) {
            area = arr[2];
        }
        NSArray *arrRefun = [self.refunAddTF.text componentsSeparatedByString:@"-"];
        NSString *areaRefun = @"";
        if (arrRefun.count == 3) {
            areaRefun = arrRefun[2];
        }
        //修改
        [HudView showHudForView:self.view];
        [NetwortTool getUpdateShopDetailWithParm:@{@"shopId":self.dataDic[@"shopId"],@"shopName":self.shopNameTF.text,@"intro":self.desTX.text,@"tel":self.phoneTF.text,@"province":arr[0],@"city":arr[1],@"area":area,@"shopAddress":self.shopAddressTF.text,@"postalCode":self.emailCodeTF.text,@"shopLogo":self.avaStr,@"returnProvince":arrRefun[0],@"returnCity":arrRefun[1],@"returnArea":areaRefun,@"returnAddress":self.refunAddInfoTF.text,@"returnPostalCode":self.refunCodeTF.text} Success:^(id  _Nonnull responseObject) {
            ToastShow(TransOutput(@"修改成功"),@"chenggong",RGB(0x36D053));
            [HudView hideHudForView:self.view];
            
           
            
            [self popViewControllerAnimate];
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
    else{
        //创建
        if (self.shopNameTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入店铺名称"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.phoneTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入联系电话"), errImg,RGB(0xFF830F));
            return;
        }
        if ([self.shopAddTF.text isEqual:TransOutput(@"请选择店铺地址")]) {
            ToastShow(TransOutput(@"请选择店铺地址"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.avaStr.length == 0) {
            ToastShow(TransOutput(@"请选择店铺logo"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.shopAddressTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入店铺详细地址"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.refunCodeTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入退货邮编"), errImg,RGB(0xFF830F));
            return;
        }
        if ([self.refunAddTF.text  isEqual:TransOutput(@"请选择退货地址")]) {
            ToastShow(TransOutput(@"请选择退货地址"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.refunAddInfoTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入退货详细地址"), errImg,RGB(0xFF830F));
            return;
        }
        
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
        BOOL phoneValid = [phoneTest evaluateWithObject:self.phoneTF.text];

        if (!phoneValid) {
        
            ToastShow(TransOutput(@"手机号格式错误"), errImg,RGB(0xFF830F));
            return;
        }
        NSArray *arr = [self.shopAddTF.text componentsSeparatedByString:@"-"];
        
        NSString *area = @"";
        if (arr.count == 3) {
            area = arr[2];
        }
        NSArray *arrRefun = [self.refunAddTF.text componentsSeparatedByString:@"-"];
        NSString *areaRefun = @"";
        if (arrRefun.count == 3) {
            areaRefun = arrRefun[2];
        }
        [HudView showHudForView:self.view];
        [NetwortTool getCreateShopDetailWithParm:@{@"shopName":self.shopNameTF.text,@"intro":self.desTX.text,@"tel":self.phoneTF.text,@"province":arr[0],@"city":arr[1],@"area":arr[2],@"shopAddress":self.shopAddressTF.text,@"postalCode":self.emailCodeTF.text,@"shopLogo":self.avaStr,@"returnProvince":arrRefun[0],@"returnCity":arrRefun[1],@"returnArea":areaRefun,@"returnAddress":self.refunAddInfoTF.text,@"returnPostalCode":self.refunCodeTF.text} Success:^(id  _Nonnull responseObject) {
            [HudView hideHudForView:self.view];
            ToastShow(TransOutput(@"创建成功"),@"chenggong",RGB(0x36D053));
            
            UIViewController *targetViewController = nil;
            NSArray *viewControllers = self.navigationController.viewControllers;
            for (UIViewController *vc in viewControllers) {
                if ([vc isKindOfClass:[shopUserApplyViewController class]]) {
                    targetViewController = vc;
                    break;
                }
            }
             
            if (targetViewController) {
                [self.navigationController popToViewController:targetViewController animated:YES];
            }

          
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
}


- (IBAction)choseShopLogo:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choseImgType:UIImagePickerControllerSourceTypePhotoLibrary ];
    }];
    [photoAlbumAction setValue:RGB(0x333333) forKey:@"_titleTextColor"];
  
    UIAlertAction *takeAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choseImgType:UIImagePickerControllerSourceTypeCamera];
    }];
    [takeAlbumAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancle setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alert addAction:takeAlbumAction];
    [alert addAction:photoAlbumAction];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)choseImgType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqual:@"public.image"]) {
        [HudView showHudForView:self.view];
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
      
        
        UIImage *imageW = [Tool OriginImage:image scaleToSize:CGSizeMake(80, 80)];
        self.picBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [self.picBtn setBackgroundImage:imageW forState:UIControlStateNormal];
        [self.picBtn setTitle:@"" forState:UIControlStateNormal];
        [self.picBtn setImage:[UIImage new] forState:UIControlStateNormal];
        self.delBtn.hidden = NO;
        [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
           
        } success:^(id  _Nonnull responseObject) {
            [HudView hideHudForView:self.view];
//            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
            });
            self.avaStr = responseObject[@"data"];
            
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)delBtn:(id)sender {
    self.picBtn.backgroundColor = RGB(0xF6FAFE);
    self.picBtn.layer.borderColor = RGB(0xA3CCF9).CGColor;
    self.picBtn.layer.borderWidth = 0.5;
    [self.picBtn setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
    [self.picBtn setTitle:TransOutput(@"店铺图片") forState:UIControlStateNormal];
    self.picBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.picBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
    self.picBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [self.picBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
    [self.picBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    self.avaStr = @"";
    self.delBtn.hidden = YES;
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
