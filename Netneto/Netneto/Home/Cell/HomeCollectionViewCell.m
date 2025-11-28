//
//  HomeCollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
-(void)setDic:(NSDictionary *)dic{
   
        _dic = dic;
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
    self.title.text = [NSString isNullStr:dic[@"prodName"]];
    NSString *oldPriceStr =[NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:[NSString isNullStr:dic[@"oriPrice"]]]];
    
    NSString *priceStr = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:[NSString isNullStr:dic[@"price"]]]];
    
    NSString *toalStr = [NSString stringWithFormat:@"%@ %@",priceStr,oldPriceStr];
      if (![oldPriceStr isEqual:self.price.text]) {
        
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:toalStr];
          [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(priceStr.length+1, oldPriceStr.length)];// 如果不加这个，横线的颜色跟随label字体颜色改变
    [attri addAttribute:NSStrikethroughColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange(priceStr.length +1, oldPriceStr.length)];
      [attri addAttribute:NSForegroundColorAttributeName value:RGB(0xA1A0A0) range:NSMakeRange(priceStr.length +1, oldPriceStr.length)];
          [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(priceStr.length +1, oldPriceStr.length)];
          [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0 , priceStr.length)];
         
          self.price.attributedText = attri;
    }
      else{
          self.price.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:[NSString isNullStr:dic[@"price"]]]];
          self.price.font = [UIFont systemFontOfSize:14];
      }

    self.oriPrice.font = [UIFont systemFontOfSize:11];
    NSString *soldNum = [NSString stringWithFormat:@"%@",dic[@"soldNum"]];
    if ([[NSString isNullStr:soldNum] length] > 0) {
        self.oriPrice.text =[NSString stringWithFormat:@"%@%@",[NSString isNullStr:soldNum],TransOutput(@"件 販売済み") ];

    }else{
        self.oriPrice.text =[NSString stringWithFormat:@"%@%@",@"0",TransOutput(@"件 販売済み")];

    }

   
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
