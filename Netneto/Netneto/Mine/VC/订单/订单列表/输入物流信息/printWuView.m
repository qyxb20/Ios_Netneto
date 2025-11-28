//
//  printWuView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "printWuView.h"

@implementation printWuView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
   
    return views[0];
}
- (IBAction)buttonTap:(UIButton *)sender {
    if (self.wuGTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入物流公司名称"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.numLabel.text.length == 0) {
        ToastShow(TransOutput(@"请输入订单号"), errImg,RGB(0xFF830F));
        return;
    }
    ExecBlock(self.subClickBlock,self.wuGTF.text,self.numLabel.text);
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    @weakify(self)
    self.backVIew.backgroundColor = RGB_ALPHA(0x0202024, 0.3);
    [self.backVIew addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
       
        [self removeFromSuperview];
    }];
   
    self.subBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [self.subBtn setTitle:TransOutput(@"确定") forState:UIControlStateNormal];
    self.titleLabel.text = TransOutput(@"物流信息");
    self.wuGName.text = TransOutput(@"物流公司名称");
    self.wuGTF.placeholder = TransOutput(@"请输入物流公司名称");
    self.wuGTF.delegate = self;
    self.numName.text = TransOutput(@"运单号");
    self.numLabel.placeholder = TransOutput(@"请输入订单号");
    self.numLabel.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  }
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = kbFrame.size.height ;
    
    CGRect begin = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[aNotification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat curkeyBoardHeight = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        CGFloat keyBoardHeight = curkeyBoardHeight;
         NSLog(@"第三次：%f",keyBoardHeight);
        // 调整视图位置
        self.frame = CGRectMake(0, -keyBoardHeight, self.frame.size.width, self.frame.size.height);
       }
    else{
        self.frame = CGRectMake(0, -curkeyBoardHeight, self.frame.size.width, self.frame.size.height);
    }
}
- (void)keyboardWillHide:(NSNotification*)aNotification {
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.numLabel) {
        NSUInteger newLength = textField.text.length + string.length - range.length;
       
        return newLength <= 20;
    }else{
        NSUInteger newLength = textField.text.length + string.length - range.length;
        
        return newLength <= 50;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
