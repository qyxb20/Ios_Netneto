//
//  MineMsgBottomView.m
//  Netneto
//
//  Created by apple on 2024/12/25.
//

#import "MineMsgBottomView.h"
@interface MineMsgBottomView ()
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendGoodsBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;


@end
@implementation MineMsgBottomView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
-(void)setSeldic:(NSDictionary *)seldic{
    _seldic = seldic;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:seldic[@"pic"]] placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:seldic[@"price"]]];
    self.skuLabel.text =[NSString stringWithFormat:@"%@",seldic[@"skuName"]];

}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    GoodDetailModel *model = [GoodDetailModel mj_objectWithKeyValues:dic];
  
    self.nameLabel.text = self.dic[@"prodName"];
     [self.sendGoodsBtn setTitle:TransOutput(@"发送商品") forState:UIControlStateNormal];
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        ExecBlock(self.closeBlock);
        
    }];
    [self.sendGoodsBtn addTapAction:^(UIView * _Nonnull view) {
        ExecBlock(self.sendGoodBlock,self.dic);
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
