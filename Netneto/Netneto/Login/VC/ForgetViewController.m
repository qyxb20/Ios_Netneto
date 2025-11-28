//
//  ForgetViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/18.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgView;

@property(nonatomic, strong)UIButton *phoneBtnView;
@property(nonatomic, strong)UIButton *emilBtnView;
@property(nonatomic, strong)resignCustomTFView *phoneView;
@property(nonatomic, strong)UIButton *codeBtnView;
@property(nonatomic, strong)resignCustomTFView *codeView;

@property(nonatomic, strong)UIButton *reginBtnView;

@property(nonatomic, assign)NSInteger validateType;
@property (nonatomic, assign) NSInteger timecount;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ForgetViewController
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 132, WIDTH, HEIGHT - 232)];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, self.bgView.width, 29)];
    label.text = TransOutput(@"重置密码");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"思源黑体" size:20];
    [self.bgView addSubview:label];
   
    
   
    self.phoneBtnView.frame = CGRectMake(30, label.bottom + 16, (WIDTH - 60 - 48 ) / 2, 46);
    [self.bgView addSubview: self.phoneBtnView];
    
    self.emilBtnView.frame = CGRectMake(30 + (WIDTH - 60) / 2, label.bottom + 16, (WIDTH - 60 - 48 ) / 2, 46);
    [self.bgView addSubview: self.emilBtnView];
    
    self.phoneView.frame = CGRectMake(30, self.phoneBtnView.bottom + 16, WIDTH - 60 - 48, 46);
    [self.bgView addSubview: self.phoneView];
    
    self.codeView.frame = CGRectMake(30, self.phoneView.bottom + 24,  WIDTH - 60- 48, 46);
    [self.bgView addSubview:self.codeView];
    
    self.codeBtnView.frame = CGRectMake(self.codeView.width - 127, 5,  122, 37);
    [self.codeView addSubview:self.codeBtnView];
    
    self.reginBtnView.frame = CGRectMake(30, self.codeView.bottom + 16,  WIDTH - 60- 48, 48);
    [self.bgView addSubview:self.reginBtnView];

    self.scrollView.contentSize = CGSizeMake(WIDTH, self.reginBtnView.bottom + 16);

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
   
    [NetwortTool loginWithForgetGetCode:str Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"发送成功"),@"chenggong",RGB(0x36D053));
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
        [_reginBtnView setTitle:TransOutput(@"下一步") forState:UIControlStateNormal];
        _reginBtnView.titleLabel.font = [UIFont systemFontOfSize:18];
        _reginBtnView.userInteractionEnabled = YES;
        [_reginBtnView addTarget:self action:@selector(resignTap) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _reginBtnView;
   
    

}



-(void)resignTap{
    
    _reginBtnView.enabled = NO;
    if (self.phoneView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号/邮箱") ,errImg,RGB(0xFF830F));
        return;
    }
   else if (self.codeView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入验证码") ,errImg,RGB(0xFF830F));
        return;
    }
    NSString *nameStr = @"mobile";
    if (self.validateType == 1) {
        nameStr = @"userMail";
    }
    [NetwortTool forgetCheckCodeWith:@{@"verificationCode":self.codeView.customTF.text,@"account":self.phoneView.customTF.text} Success:^(id  _Nonnull responseObject) {
        self.reginBtnView.enabled = YES;
        ResetPassViewController *vc = [[ResetPassViewController alloc] init];
        vc.phoneNumber = self.phoneView.customTF.text;
        [self pushController:vc];
    } failure:^(NSError * _Nonnull error) {
        self.reginBtnView.enabled = YES;
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
