//
//  resginPassCustomTFView.m
//  Netneto
//
//  Created by apple on 2024/10/31.
//

#import "resginPassCustomTFView.h"

@implementation resginPassCustomTFView
-(void)CreateView{
    self.backgroundColor = RGB_ALPHA(0xFFFFFF, 1);
    self.layer.cornerRadius = 23;
    self.clipsToBounds = YES;
    self.layer.borderColor = RGB(0xCCCCCC).CGColor;
    self.layer.borderWidth = 1;
  
    [self addSubview:self.customTF];
    [self.customTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(46);
        make.trailing.mas_offset(-10);
        make.top.bottom.mas_offset(0);
    }];
    
    [self addSubview:self.eyeBtn];
    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(15);
        make.height.mas_offset(10);
        make.leading.mas_offset(14.5);
        make.centerY.mas_equalTo(self);
    }];
    [self.eyeBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)eyeClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [_eyeBtn setImage:[UIImage imageNamed:@"login_password_show"] forState:UIControlStateNormal];
        _customTF.secureTextEntry = NO;
    }
    else{
        sender.selected = NO;
        [_eyeBtn setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
        _customTF.secureTextEntry = YES;
    }
}
-(UITextField *)customTF{
    if (!_customTF) {
        _customTF = [[UITextField alloc] init];
        _customTF.textAlignment = NSTextAlignmentLeft;
        _customTF.font = [UIFont systemFontOfSize:14];
        _customTF.secureTextEntry = YES;
    }
    return _customTF;
}
-(UIButton *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeBtn setImage:[UIImage imageNamed:@"login_password"] forState:UIControlStateNormal];
          
    }
    return _eyeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
