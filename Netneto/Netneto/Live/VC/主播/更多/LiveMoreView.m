//
//  LiveMoreView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "LiveMoreView.h"
@interface LiveMoreView ()
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *changCamerBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation LiveMoreView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
-(void)setIsActor:(BOOL)isActor{
    _isActor = isActor;
    if (self.isActor) {
        self.changCamerBtn.hidden = NO;
    }
    else{
        self.changCamerBtn.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
    [self.shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    [self.shareBtn setTitle:TransOutput(@"分享") forState:UIControlStateNormal];
    [self.shareBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
    [self.shareBtn addTapAction:^(UIView * _Nonnull view) {
        ToastShow(TransOutput(@"该功能暂未开放"), errImg,RGB(0xFF830F));
    }];
    [self.changCamerBtn setImage:[UIImage imageNamed:@"qiehuan"] forState:UIControlStateNormal];
    [self.changCamerBtn setTitle:TransOutput(@"切换摄像头") forState:UIControlStateNormal];
    [self.changCamerBtn layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
    
    [self.changCamerBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.changeCamerClickBlock);
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
