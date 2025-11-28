//
//  PaymentView.m
//  Netneto
//
//  Created by apple on 2024/10/16.
//

#import "PaymentView.h"
@interface PaymentView ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end
@implementation PaymentView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.cancelPayBlock);
        [self removeFromSuperview];
    }];
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.cancelPayBlock);
        [self removeFromSuperview];
    }];
    
    self.titleLabel.text = TransOutput(@"支付方法确认");
    self.subTitle.text = TransOutput(@"信用卡");
    self.contentLabel.text = TransOutput(@"仅支持Visa、Mastercard、American Express、JCB、Diners Club、Discover等6个主要卡品牌的信用卡");
    self.sunContentLabel.text = TransOutput(@"本公司不保存顾客的卡信息");
    [self.nextBtn setTitle:TransOutput(@"下一步") forState:UIControlStateNormal];
    self.nextBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    
    [self.nextBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.nextBlock);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
