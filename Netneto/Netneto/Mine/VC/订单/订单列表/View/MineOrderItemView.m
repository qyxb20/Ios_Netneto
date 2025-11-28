//
//  MineOrderItemView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "MineOrderItemView.h"
@interface MineOrderItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *priceLbel;
@property (weak, nonatomic) IBOutlet UILabel *numLbel;
@property (weak, nonatomic) IBOutlet UIView *shopView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UILabel *skuNameLabel;


@end
@implementation MineOrderItemView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
-(void)setIsDetail:(BOOL)isDetail{
    _isDetail = isDetail;
}
-(void)setIsRe:(BOOL)isRe{
    _isRe = isRe;
}
-(void)setStatus:(NSString *)status{
    _status = status;
}
-(void)setReduceAmount:(NSInteger)reduceAmount{
    _reduceAmount = reduceAmount;
}
-(void)setModel:(OrderModel *)model{
    _model = model;
 
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:model.pic]]];
    self.titleName.text = [NSString isNullStr:model.prodName];
    self.priceLbel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:model.price]];
    self.numLbel.text = [NSString stringWithFormat:@"X%@",[NSString isNullStr:model.prodCount]];
    self.shopName.text = [NSString isNullStr:model.shopName];
    self.skuNameLabel.text = [NSString isNullStr:model.skuName];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDTH - 60, 23) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, WIDTH - 60, 23);
    maskLayer.path = maskPath.CGPath;
    self.shopView.layer.mask = maskLayer;
    
    if ([self.status isEqual:@"5"] && [model.orderStatus isEqual:@"1"]) {
        //订单完成
        if (!self.isDetail) {
            
       
        if ([model.isComm isEqual:@"0"]) {
            //未评论
            self.otherBtn.hidden = NO;
            [self.otherBtn setTitle:TransOutput(@"去评价") forState:UIControlStateNormal];
            [self.otherBtn setTitleColor:RGB(0x646464) forState:UIControlStateNormal];
            self.otherBtn.layer.cornerRadius = 3;
            self.otherBtn.clipsToBounds = YES;
            self.otherBtn.layer.borderColor = RGB(0xE7E7E7).CGColor;
            self.otherBtn.layer.borderWidth = 1;
            self.otherBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            @weakify(self);
            [self.otherBtn addTapAction:^(UIView * _Nonnull view) {
                @strongify(self);
                ExecBlock(self.pushAddComBlock,self.model);
            }];
        }
        else{
            self.otherBtn.hidden = YES;
        }
            if (self.reduceAmount == 0) {
                [self.fanJinBtn setTitle:TransOutput(@"申请退款") forState:UIControlStateNormal];
                [self.fanJinBtn setTitleColor:RGB(0x646464) forState:UIControlStateNormal];
                self.fanJinBtn.layer.cornerRadius = 3;
                self.fanJinBtn.clipsToBounds = YES;
                self.fanJinBtn.layer.borderColor = RGB(0xE7E7E7).CGColor;
                self.fanJinBtn.layer.borderWidth = 1;
                self.fanJinBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                @weakify(self);
                [self.fanJinBtn addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    ExecBlock(self.refunApplyBlock,self.model);
                }];
            }
        
        }
        
        if (self.isRe) {
            self.shopView.hidden = YES;
            self.fanJinBtn.hidden = YES;
            self.otherBtn.hidden = YES;
        }
    }
    if ([self.status isEqual:@"2"] || [self.status isEqual:@"3"]) {
        if (([model.orderStatus isEqual:@"0"] || [model.orderStatus isEqual:@"1"]) && [self.status isEqual:@"2"] ) {
            if (!self.isDetail) {
                if (self.reduceAmount == 0) {
                    [self.fanJinBtn setTitle:TransOutput(@"申请退款") forState:UIControlStateNormal];
                    [self.fanJinBtn setTitleColor:RGB(0x646464) forState:UIControlStateNormal];
                    self.fanJinBtn.layer.cornerRadius = 3;
                    self.fanJinBtn.clipsToBounds = YES;
                    self.fanJinBtn.layer.borderColor = RGB(0xE7E7E7).CGColor;
                    self.fanJinBtn.layer.borderWidth = 1;
                    self.fanJinBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                    @weakify(self);
                    [self.fanJinBtn addTapAction:^(UIView * _Nonnull view) {
                        @strongify(self);
                        ExecBlock(self.refunApplyBlock,self.model);
                    }];
                }
            }
            if (self.isRe) {
                self.shopView.hidden = YES;
                self.fanJinBtn.hidden = YES;
                self.otherBtn.hidden = YES;
            }
        }
        if ([model.orderStatus isEqual:@"2"] ) {
            [self.fanJinBtn setTitle:TransOutput(@"退款中") forState:UIControlStateNormal];
            [self.fanJinBtn setTitleColor:RGB(0xDE1135) forState:UIControlStateNormal];
            self.fanJinBtn.layer.cornerRadius = 3;
            self.fanJinBtn.clipsToBounds = YES;
            if (self.isRe) {
            
                self.fanJinBtn.hidden =YES;
               
            }
            
        }
        if ([model.orderStatus isEqual:@"3"] ) {
            [self.fanJinBtn setTitle:TransOutput(@"退款完成") forState:UIControlStateNormal];
            [self.fanJinBtn setTitleColor:RGB(0xDE1135) forState:UIControlStateNormal];
            self.fanJinBtn.layer.cornerRadius = 3;
            self.fanJinBtn.clipsToBounds = YES;
            if (self.isRe) {
            
                self.fanJinBtn.hidden = NO;
               
            }
            
        }
    }
    if ([self.status isEqual:@"6"]) {
        if ([model.orderStatus isEqual:@"2"] ) {
            [self.fanJinBtn setTitle:TransOutput(@"退款中") forState:UIControlStateNormal];
            [self.fanJinBtn setTitleColor:RGB(0xDE1135) forState:UIControlStateNormal];
            self.fanJinBtn.layer.cornerRadius = 3;
            self.fanJinBtn.clipsToBounds = YES;
            
            if (self.isRe) {
            
                self.fanJinBtn.hidden =YES;
               
            }
        }
        if ([model.orderStatus isEqual:@"3"] ) {
            [self.fanJinBtn setTitle:TransOutput(@"退款完成") forState:UIControlStateNormal];
            [self.fanJinBtn setTitleColor:RGB(0xDE1135) forState:UIControlStateNormal];
            self.fanJinBtn.layer.cornerRadius = 3;
            self.fanJinBtn.clipsToBounds = YES;
            
            if (self.isRe) {
            
                self.fanJinBtn.hidden = NO;
               
            }
        }
    }
    if ([self.status isEqual:@"5"]) {
        if ([model.orderStatus isEqual:@"2"] ) {
            [self.fanJinBtn setTitle:TransOutput(@"退款中") forState:UIControlStateNormal];
            [self.fanJinBtn setTitleColor:RGB(0xDE1135) forState:UIControlStateNormal];
            self.fanJinBtn.layer.cornerRadius = 3;
            self.fanJinBtn.clipsToBounds = YES;
            
            if (self.isRe) {
            
                self.fanJinBtn.hidden = YES;
               
            }
        }
        if ([model.orderStatus isEqual:@"3"] ) {
            [self.fanJinBtn setTitle:TransOutput(@"退款完成") forState:UIControlStateNormal];
            [self.fanJinBtn setTitleColor:RGB(0xDE1135) forState:UIControlStateNormal];
            self.fanJinBtn.layer.cornerRadius = 3;
            self.fanJinBtn.clipsToBounds = YES;
            if (self.isRe) {
            
                self.fanJinBtn.hidden = NO;
               
            }
            
        }
    }
    if (self.isRe) {
        self.shopView.hidden = YES;
      
        self.otherBtn.hidden = YES;
    }
}
-(void)setRefModel:(RefunOrderModel *)refModel{
    _refModel = refModel;
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:refModel.pic]]];
    self.titleName.text = [NSString isNullStr:refModel.prodName];

        self.priceLbel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:refModel.price]];
    

    self.numLbel.text = [NSString stringWithFormat:@"%@:%ld",TransOutput(@"申请数量"),(long)refModel.prodCount];
    self.shopName.text = [NSString isNullStr:refModel.shopName];
    self.skuNameLabel.text = [NSString isNullStr:refModel.skuName];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDTH - 60, 23) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, WIDTH - 60, 23);
    maskLayer.path = maskPath.CGPath;
    self.shopView.layer.mask = maskLayer;
    
  
}
-(void)setOrderRefModel:(OrderDetailInfoRefunModel *)OrderRefModel{
    _OrderRefModel = OrderRefModel;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:OrderRefModel.pic]]];
    self.titleName.text = [NSString isNullStr:OrderRefModel.prodName];

    self.priceLbel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceNum:OrderRefModel.price]];

   
    self.numLbel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"申请数量"),OrderRefModel.prodCount];
    self.shopName.text = [NSString isNullStr:OrderRefModel.shopName];
    self.skuNameLabel.text = [NSString isNullStr:OrderRefModel.skuName];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDTH - 60, 23) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, WIDTH - 60, 23);
    maskLayer.path = maskPath.CGPath;
    self.shopView.layer.mask = maskLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
