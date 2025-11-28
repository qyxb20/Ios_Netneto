//
//  resignCustomTFView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/18.
//

#import "resignCustomTFView.h"


@implementation resignCustomTFView
- (void)setIsCode:(BOOL)isCode{
    _isCode = isCode;
    if (self.isCode) {
        [self.customTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(46);
            make.trailing.mas_offset(-142);
            make.top.bottom.mas_offset(0);
        }];
    }
}
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
    
}
-(UITextField *)customTF{
    if (!_customTF) {
        _customTF = [[UITextField alloc] init];
        _customTF.textAlignment = NSTextAlignmentLeft;
        _customTF.font = [UIFont systemFontOfSize:14];
          
    }
    return _customTF;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
