//
//  GoodsSureOrderView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/9.
//

#import "GoodsSureOrderView.h"
@interface GoodsSureOrderView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *hejiNumber;
@property (weak, nonatomic) IBOutlet UILabel *oederPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UILabel *youLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *youPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *freePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *heijiLabel;
@property (weak, nonatomic) IBOutlet UITextView *peiLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upheight;

@end
@implementation GoodsSureOrderView

+ (instancetype)initViewNIB{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderTotalPriceTipLabel.text = TransOutput(@"订单总额");
    self.oederPriceLabel.text = TransOutput(@"订单价格");
    self.freeLabel.text = TransOutput(@"运费");
    self.youLabel.text = TransOutput(@"优惠金额");
    NSString *str = TransOutput(@"配送策略和退货·取消时的退款策略，在本公司的服务利用规章中，以简单能理解的形式记载着。");
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *valueString1 = [[NSString stringWithFormat:@"secondPerson://2"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [attstring addAttribute:NSLinkAttributeName value:valueString range:[str rangeOfString:TransOutput(@"配送政策")]];
    [attstring addAttribute:NSLinkAttributeName value:valueString1 range:[str rangeOfString:TransOutput(@"退款政策")]];
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[str rangeOfString:TransOutput(@"配送政策")]];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:[str rangeOfString:TransOutput(@"配送政策")]];
 
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[str rangeOfString:TransOutput(@"退款政策")]];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:[str rangeOfString:TransOutput(@"退款政策")]];
 
    self.peiLabel.delegate = self;
    self.peiLabel.attributedText =attstring;

    self.peiLabel.editable = NO;

}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        ExecBlock(self.peiClickBlock);
        return NO;
    } else if ([[URL scheme] isEqualToString:@"secondPerson"]) {
        ExecBlock(self.tuiClickBlock);
        return NO;
    }
 
    return YES;
 
}
-(void)updataWithDic:(NSDictionary *)dataDic{
    self.hejiNumber.text = [NSString stringWithFormat:@"%@%@%@",TransOutput(@"合计"),dataDic[@"totalCount"],TransOutput(@"件商品")];
    self.orderTotalPriceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:dataDic[@"total"]]];
    self.freePriceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:dataDic[@"totalTransfee"]]];
    self.youPriceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:dataDic[@"orderReduce"]]];
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:dataDic[@"actualTotal"]]];
    NSString *str =[NSString stringWithFormat:@"%@:%@",TransOutput(@"合计"),priceStr];
    NSMutableAttributedString *attstr =[[NSMutableAttributedString alloc] initWithString:str];
    [attstr addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(str.length - priceStr.length, priceStr.length)];
    self.heijiLabel.attributedText = attstr;
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
