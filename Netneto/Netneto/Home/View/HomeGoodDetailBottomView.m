//
//  HomeGoodDetailBottomView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "HomeGoodDetailBottomView.h"
@interface HomeGoodDetailBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *nowPay;
@property (weak, nonatomic) IBOutlet UIButton *joinCar;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *shopCar;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;

@property (nonatomic, strong)NSString *num;

@end
@implementation HomeGoodDetailBottomView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self CreateView];
    // Initialization code
}
-(void)CreateView{
    self.nowPay.backgroundColor = RGB(0x0F7CFD);
    self.joinCar.backgroundColor = RGB(0xE6EFFE);
    [self.joinCar setTitleColor:RGB(0x0F7CFD) forState:UIControlStateNormal];
    [self.nowPay addRightCornerPath:20.5];
    [self.joinCar addLeftCornerPath:20.5];
    self.carLabel.text = TransOutput(@"购物车");
    self.keLabel.text = TransOutput(@"客服");
    [self.nowPay setTitle:TransOutput(@"立即购买") forState:UIControlStateNormal];
    [self.joinCar setTitle:TransOutput(@"加入购物车") forState:UIControlStateNormal];
    [self getCarNumber];
    @weakify(self);
    [self.shopCar addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        ExecBlock(self.pushCarClickBlock);
    }];
    [self.joinCar addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        ExecBlock(self.joinCarClickBlock);
    }];
    [self.nowPay addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        ExecBlock(self.buyClickBlock);
    }];
}

-(void)getCarNumber{
    
    [NetwortTool getGoodsNumberWithParm:@{} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.numberLabel.text =[NSString stringWithFormat:@"%@",responseObject];
          
        
        });
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (IBAction)kefuClick:(UIButton *)sender {
    ExecBlock(self.kefuClickBlock);
}

-(void)updateNumber{
   
    [self getCarNumber];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
