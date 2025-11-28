//
//  LiveBottomView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/11.
//

#import "LiveBottomView.h"

@implementation LiveBottomView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTF.returnKeyType = UIReturnKeySend;
    self.contentTF.delegate = self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    ExecBlock(self.SendMessageBlock,textField.text);
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
