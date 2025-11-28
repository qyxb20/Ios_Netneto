//
//  ShaiXuanView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/18.
//

#import "ShaiXuanView.h"
@interface ShaiXuanView ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *choseLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneMothBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeMotnBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixMothBtn;
@property (weak, nonatomic) IBOutlet UIButton *tYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
@implementation ShaiXuanView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
   
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    self.titleLabel.text = TransOutput(@"按时间");
    [self.oneMothBtn setTitle:TransOutput(@"1个月") forState:UIControlStateNormal];
    [self.oneMothBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            self.oneMothBtn.backgroundColor = RGB(0x197CF5);
            [self.oneMothBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.choseLabel.text =TransOutput(@"1个月");
        self.threeMotnBtn.backgroundColor = [UIColor systemGray6Color];
        [self.threeMotnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sixMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.sixMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.tYearBtn.backgroundColor = [UIColor systemGray6Color];
        [self.tYearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    
   
    [self.threeMotnBtn setTitle:TransOutput(@"3个月") forState:UIControlStateNormal];
    [self.threeMotnBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            self.threeMotnBtn.backgroundColor = RGB(0x197CF5);
            [self.threeMotnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.choseLabel.text =TransOutput(@"3个月");
        self.oneMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.oneMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sixMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.sixMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.tYearBtn.backgroundColor = [UIColor systemGray6Color];
        [self.tYearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    
    [self.sixMothBtn setTitle:TransOutput(@"6个月") forState:UIControlStateNormal];
    [self.sixMothBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            self.sixMothBtn.backgroundColor = RGB(0x197CF5);
            [self.sixMothBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.choseLabel.text =TransOutput(@"6个月");
        self.oneMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.oneMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.threeMotnBtn.backgroundColor = [UIColor systemGray6Color];
        [self.threeMotnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.tYearBtn.backgroundColor = [UIColor systemGray6Color];
        [self.tYearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    
    [self.tYearBtn setTitle:TransOutput(@"今年") forState:UIControlStateNormal];
    [self.tYearBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            self.tYearBtn.backgroundColor = RGB(0x197CF5);
            [self.tYearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.choseLabel.text =TransOutput(@"今年");
        self.oneMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.oneMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.threeMotnBtn.backgroundColor = [UIColor systemGray6Color];
        [self.threeMotnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sixMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.sixMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
    [self.resetBtn setTitle:TransOutput(@"重置") forState:UIControlStateNormal];
    self.resetBtn.backgroundColor = [UIColor gradientColorArr:@[RGB(0xEFB675),RGB(0xEA8A2F)] withWidth:141];
    [self.sureBtn setTitle:TransOutput(@"确定") forState:UIControlStateNormal];
    self.sureBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:141];
    
    [self.resetBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.oneMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.oneMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.threeMotnBtn.backgroundColor = [UIColor systemGray6Color];
        [self.threeMotnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.sixMothBtn.backgroundColor = [UIColor systemGray6Color];
        [self.sixMothBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      self.tYearBtn.backgroundColor = [UIColor systemGray6Color];
        [self.tYearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.choseLabel.text = @"";
        
    }];
    [self.sureBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.sureBlock,self.choseLabel.text);
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
