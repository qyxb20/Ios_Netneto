//
//  ResetPassViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/23.
//

#import "ResetPassViewController.h"

@interface ResetPassViewController ()

@property(nonatomic, strong)UIImageView *bacView;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgView;

@property(nonatomic, strong)resignCustomTFView *phoneView;
@property(nonatomic, strong)resignCustomTFView *codeView;

@property(nonatomic, strong)UIButton *reginBtnView;

@end

@implementation ResetPassViewController
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
-(void)CreateView{
    [self.view addSubview:self.bacView];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 123, WIDTH, HEIGHT - 223)];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, self.bgView.width, 29)];
    label.text = TransOutput(@"重置密码");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"思源黑体" size:20];
    [self.bgView addSubview:label];
   
    
   
      
   
    self.phoneView.frame = CGRectMake(30, label.bottom + 81, WIDTH - 60 - 48, 40);
    [self.bgView addSubview: self.phoneView];
    
  
    self.codeView.frame = CGRectMake(30, self.phoneView.bottom + 16,  WIDTH - 60- 48, 40);
    [self.bgView addSubview:self.codeView];
    
    self.reginBtnView.frame = CGRectMake(30, self.codeView.bottom + 49,  WIDTH - 60- 48, 40);
    [self.bgView addSubview:self.reginBtnView];

    self.scrollView.contentSize = CGSizeMake(WIDTH, self.reginBtnView.bottom + 16);

}
-(UIImageView *)bacView{
    if (!_bacView) {
        _bacView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _bacView.image = [UIImage imageNamed:@"组合 501-2"];
        _bacView.userInteractionEnabled = YES;
    }
    return _bacView;
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




-(resignCustomTFView *)phoneView{
    if (!_phoneView) {
      
        _phoneView = [[resignCustomTFView alloc] init];
        _phoneView.customTF.placeholder = TransOutput(@"新密码");
        _phoneView.layer.cornerRadius = 23;
        _phoneView.clipsToBounds = YES;
        _phoneView.customTF.secureTextEntry = YES;
        [_phoneView.customTF addPlachColor:TransOutput(@"新密码") color:RGB(0x797676)];
        }
        return _phoneView;

    
}


-(resignCustomTFView *)codeView{
    if (!_codeView) {
      
        _codeView = [[resignCustomTFView alloc] init];
        _codeView.customTF.placeholder = TransOutput(@"确认新密码");
        _codeView.layer.cornerRadius = 23;
        _codeView.clipsToBounds = YES;
        _codeView.customTF.secureTextEntry = YES;
        [_codeView.customTF addPlachColor:TransOutput(@"确认新密码") color:RGB(0x797676)];
        }
        return _codeView;

    
}
-(UIButton *)reginBtnView{
    if (!_reginBtnView) {
        _reginBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _reginBtnView.layer.cornerRadius = 20;
        _reginBtnView.clipsToBounds = YES;
       
        _reginBtnView.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 60];
        [_reginBtnView setTitle:TransOutput(@"确定") forState:UIControlStateNormal];
        _reginBtnView.titleLabel.font = [UIFont systemFontOfSize:18];
        _reginBtnView.userInteractionEnabled = YES;
        [_reginBtnView addTarget:self action:@selector(resignTap) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _reginBtnView;
   
    

}



-(void)resignTap{
    
   
    if (self.phoneView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入新密码") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (self.codeView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请确认新密码") ,errImg,RGB(0xFF830F));
        return;
    }
   else if(![self.phoneView.customTF.text isEqual:self.codeView.customTF.text]){
       ToastShow(TransOutput(@"密码不一致") ,errImg,RGB(0xFF830F));
       return;
   }
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORDSTR];
    BOOL emailValid = [emailTest evaluateWithObject:self.phoneView.customTF.text];

    if (!emailValid) {
    
        ToastShow(TransOutput(@"密码必须是8-18位，包含数字，字母和特殊符号"), errImg,RGB(0xFF830F));
     
        return;
    }
    NSString *passStr = [NSString stringWithFormat:@"%@%@",[Tool getCurrentTimeNumber],self.phoneView.customTF.text];
 
    NSString *str = [AESManager encrypt:passStr key:AESKEY] ;
   
    [NetwortTool ChangePassWith:@{@"account":self.phoneNumber,@"password":str} Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"重置成功"),@"chenggong",RGB(0x36D053));
       
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LoginViewController class]]) {
                LoginViewController *A =(LoginViewController *)controller;
               [self.navigationController popToViewController: A animated:YES];
                }
            }
    
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],errImg,RGB(0xFF830F));
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
