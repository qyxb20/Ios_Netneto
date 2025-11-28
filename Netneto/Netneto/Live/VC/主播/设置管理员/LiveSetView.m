//
//  LiveSetView.m
//  Netneto
//
//  Created by apple on 2024/10/14.
//

#import "LiveSetView.h"
@interface LiveSetView ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *jinChose;
@property (weak, nonatomic) IBOutlet UIButton *kitChose;
@property (weak, nonatomic) IBOutlet UIButton *adminChose;
@property (weak, nonatomic) IBOutlet UILabel *jinLabel;
@property (weak, nonatomic) IBOutlet UILabel *kitLabel;
@property (weak, nonatomic) IBOutlet UILabel *adinLabel;
@property (weak, nonatomic) IBOutlet UIButton *jinTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *kitTimeBtn;
@property (nonatomic, strong) NSString *jinTimeStr;
@property (nonatomic, strong) NSString *kitTimeStr;
@property (nonatomic, strong) NSString *choseStr;
@end
@implementation LiveSetView
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
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    self.jinLabel.text = TransOutput(@"禁言");
    self.kitLabel.text = TransOutput(@"踢出房间");
    self.adinLabel.text =TransOutput(@"设置/取消为管理员");
    [self.jinTimeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.jinTimeClickBlock);
    }];
    [self.kitTimeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ExecBlock(self.kitTimeClickBlock);
            
    }];
    
   
    [self.sureBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        NSString *str;
        if ([self.choseStr  isEqual:@"0"]) {
            str = self.jinTimeStr;
        }
       else if ([self.choseStr  isEqual:@"1"]) {
            str = self.kitTimeStr;
        }
       else{
           str = @"";
       }
        ExecBlock(self.sureClickBlock,str,self.choseStr);
         
    }];
    self.sureBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [self.sureBtn setTitle:TransOutput(@"确定") forState:UIControlStateNormal];
}
-(void)show{
    [_jinChose setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    self.choseStr = @"0";
    [_kitChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [_adminChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
 
    
}

-(void)updateJinStr:(NSString *)jin{
    self.jinTimeStr = jin;
    [self.jinTimeBtn setTitle:[NSString stringWithFormat:@"%@%@",jin,TransOutput(@"分钟")] forState:UIControlStateNormal];
    [self.jinTimeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.jinTimeBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
}
-(void)updateKitStr:(NSString *)kit{
    self.kitTimeStr = kit;
    [self.kitTimeBtn setTitle:[NSString stringWithFormat:@"%@%@",kit,TransOutput(@"分钟")] forState:UIControlStateNormal];
    [self.kitTimeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.kitTimeBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
}


- (IBAction)jinchoseClick:(UIButton *)sender {
    [_jinChose setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    [_kitChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [_adminChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    self.choseStr = @"0";
}

- (IBAction)kitClick:(UIButton *)sender {
    [_jinChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [_kitChose setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    [_adminChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    self.choseStr = @"1";

}

- (IBAction)adminClick:(UIButton *)sender {
    [_jinChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [_kitChose setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [_adminChose setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
    self.choseStr = @"2";

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
