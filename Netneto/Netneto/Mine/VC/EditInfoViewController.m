//
//  EditInfoViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/28.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatar;
@property (weak, nonatomic) IBOutlet UILabel *acountLabel;
@property (weak, nonatomic) IBOutlet UITextField *acountTF;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UITextField *birTF;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) NSString *sexStr;
@property(nonatomic, strong)BRDatePickerView *datePicker;
@property(nonatomic, strong)NSString *birStr;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)NSString *avaStr;
@end

@implementation EditInfoViewController
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.backgroundColor = [UIColor clearColor];
        
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
    self.navigationItem.title = TransOutput(@"个人信息");
    self.acountLabel.text = TransOutput(@"账户");
    self.acountTF.text = account.userInfo.userAccount;
    self.acountTF.enabled = NO;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:account.userInfo.pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
    self.avaStr =[NSString isNullStr:account.userInfo.pic];
    
    self.nicknameTF.delegate = self;
    self.acountTF.delegate = self;
    self.nickNameLabel.text = TransOutput(@"昵称");
    self.nicknameTF.text = account.userInfo.nickName;
    self.nicknameTF.placeholder = TransOutput(@"请输入昵称");
    self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.sexLabel.text = TransOutput(@"性别");
    if ([account.userInfo.sex isEqual:@"M"]) {
        self.sexTF.text = TransOutput(@"男");
    }else if ([account.userInfo.sex isEqual:@"F"]) {
        self.sexTF.text = TransOutput(@"女");
    }else if ([account.userInfo.sex isEqual:@"O"]) {
        self.sexTF.text = TransOutput(@"其他");
    }{
        self.sexTF.text = @"";
    }
    self.sexTF.placeholder = TransOutput(@"请选择性别");
    
    self.birthLabel.text = TransOutput(@"出生日期");
    self.birTF.placeholder = TransOutput(@"请输入出生日期");
    self.birTF.text = account.userInfo.birthDay;
    self.emailLabel.text = TransOutput(@"邮箱");
    self.emailTF.placeholder = TransOutput(@"请输入邮箱地址");
    
    self.emailTF.text = account.userInfo.userMail;
    self.phoneLabel.text  = TransOutput(@"联系电话");
    self.phoneTF.placeholder  = TransOutput(@"请输入联系电话");
    
    self.sexStr = account.userInfo.sex;
    self.sexTF.delegate = self;
    self.birTF.delegate = self;
    self.birStr = account.userInfo.birthDay;
    self.phoneTF.text = account.userInfo.userMobile;
    [self.saveBtn setTitle:TransOutput(@"保存修改") forState:UIControlStateNormal];
    
    self.saveBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    @weakify(self);
    [self.saveBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        [self saveClick];
    }];
    [self.avatar addTapAction:^(UIView * _Nonnull view) {
            @strongify(self)
            [self showImageChoseAlert];
    }];
}
-(void)showImageChoseAlert{
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
        [self.avatar setImage:image forState:UIControlStateNormal];
        [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
           
        } success:^(id  _Nonnull responseObject) {
            [HudView hideHudForView:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
            });
//            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
            self.avaStr = responseObject[@"data"];
            
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)saveClick{

    if (self.nicknameTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入昵称"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.sexTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择性别"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.birTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入出生日期"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.emailTF.text.length == 0 && self.phoneTF.text.length == 0) {
        ToastShow(TransOutput(@"电话/邮箱不能为空"), errImg,RGB(0xFF830F));
        return;
    }

    if (self.phoneTF.text.length > 0) {
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONESTR];
        BOOL phoneValid = [phoneTest evaluateWithObject:self.phoneTF.text];

        if (!phoneValid) {
        
            ToastShow(TransOutput(@"手机号格式错误"), errImg,RGB(0xFF830F));
            return;
        }
    }
    if (self.emailTF.text.length > 0) {
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAILSTR];
        BOOL emailValid = [emailTest evaluateWithObject:self.emailTF.text];

        if (!emailValid) {
        
            ToastShow(TransOutput(@"邮箱格式错误"), errImg,RGB(0xFF830F));
            return;
        }
    }
    
    
    
    
    [HudView showHudForView:self.view];
    [NetwortTool getSetUserInfoWithParm:@{@"nickName":self.nicknameTF.text,@"userMobile":self.phoneTF.text,@"userMail":self.emailTF.text,@"sex":self.sexStr,@"birthDay":self.birStr,@"avatarUrl":self.avaStr} Success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] isEqual:@"00000"]) {
            ToastShow(TransOutput(@"保存成功"), @"chenggong",RGB(0x36D053));

            [self uploadInfo];
            
            
        }
        else{
            [HudView hideHudForView:self.view];
            ToastShow(responseObject[@"msg"], errImg,RGB(0xFF830F));
            
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
}
-(void)uploadInfo{
    [NetwortTool getUserInfoSuccess:^(id  _Nonnull responseObject) {
        account.userInfo = [UserInfoModel mj_objectWithKeyValues:responseObject];
        [HudView hideHudForView:self.view];
        [self popViewControllerAnimate];
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.sexTF) {
        [self choseSex];
        return NO;
    }
    if (textField == self.birTF) {
        [self choseBirthday];
        return NO;
    }
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = textField.text.length + string.length - range.length;
   
   
    
    if (textField == self.acountTF || textField == self.nicknameTF) {
        
        return newLength <= 50;
    }
    return YES;
}
-(void)choseSex{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TransOutput(@"请选择性别") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAlert = [UIAlertAction actionWithTitle:TransOutput(@"男") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = TransOutput(@"男");
        self.sexStr = @"M";
    }];
    [maleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
   
    UIAlertAction *femaleAlert = [UIAlertAction actionWithTitle:TransOutput(@"女") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = TransOutput(@"女");
      
        
        self.sexStr = @"F";
    }];
    [femaleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
   
    UIAlertAction *otherAlert = [UIAlertAction actionWithTitle:TransOutput(@"其他") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexTF.text = TransOutput(@"其他");
      
      
        
        self.sexStr = @"O";
    }];
    [otherAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexStr = @"";
    }];
    [cancle setValue:RGB(0x333333) forKey:@"_titleTextColor"];
   
    [alert addAction:maleAlert];
    [alert addAction:femaleAlert];
    [alert addAction:otherAlert];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)choseBirthday{
    self.datePicker = [[BRDatePickerView alloc] init];
    self.datePicker.pickerMode = BRDatePickerModeDate;
    self.datePicker.title = TransOutput(@"选择生日");
    
    self.datePicker.selectValue = self.birTF.text;
    self.datePicker.minDate = [NSDate br_setYear:1950 month:1];
    self.datePicker.maxDate = [NSDate date];
   
    self.datePicker.isAutoSelect = NO;
@weakify(self)
    self.datePicker.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        @strongify(self)
        self.birTF.text = selectValue ;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
