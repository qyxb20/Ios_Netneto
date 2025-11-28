//
//  UILabel+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import "UILabel+tool.h"

@implementation UILabel (tool)
- (void)netneto_setAttributedTextWithOriginalPrice:(float)price {
    NSAssert(price >= 0, @"商品原价应该大于等于零！");
    
    NSString *string = [NSString stringWithFormat:@"¥ %@",[NSString ChangePriceNum:price]];
    
    UIFont *textFont = [UIFont systemFontOfSize:11.0f];
    UIColor *textColor = [UIColor grayColor];
    NSDictionary *attributes = @{
        NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: textFont
    };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    self.attributedText = attributedString;
}

- (void)netneto_setAttributedTextWithGoodsPrice:(float)price {
    [self netneto_setAttributedTextWithGoodsPrice:price smallFontOfSize:14.0f bigFontOfSize:18.0f];
}

- (void)netneto_setAttributedTextWithGoodsPrice:(float)price
                            smallFontOfSize:(CGFloat)smallFontSize
                              bigFontOfSize:(CGFloat)bigFontSize
{
    NSAssert((price >= 0) && (smallFontSize > 0) && (bigFontSize > 0) &&
             (smallFontSize <= bigFontSize), @"参数断言异常！");
  
    NSString *string = [NSString stringWithFormat:@"¥ %@",[NSString ChangePriceNum:price]];
//    string = [NSString ChangePriceStr: string];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    UIColor *redColor =RGB(0xF29359);
    UIFont *smallFont = [UIFont systemFontOfSize:smallFontSize weight:UIFontWeightMedium];
    UIFont *bigFont = [UIFont systemFontOfSize:bigFontSize weight:UIFontWeightMedium];
    
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName: redColor,
        NSFontAttributeName: smallFont
    };
    [attributedString addAttributes:attributes1 range:NSMakeRange(0, 1)];
    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName:redColor,
        NSFontAttributeName:bigFont
    };
    [attributedString addAttributes:attributes2 range:NSMakeRange(2, string.length - 2)];
    
    self.attributedText = attributedString;
}

- (void)netneto_setAttributedTextWithTotalPrice:(float)totalPrice {
    NSAssert(totalPrice >= 0, @"合计金额应该大于等于零！");
    
    NSString *totalPriceString = [NSString stringWithFormat:@"¥%@", [NSString ChangePriceNum:totalPrice]];
    NSString *string = [NSString stringWithFormat:@"合计：%@", totalPriceString];
    
    UIFont *textFont = [UIFont systemFontOfSize:14];
    UIColor *grayTextColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
    UIColor *redTextColor = [UIColor colorWithRed:210/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSDictionary *attributes1 = @{
//        NSForegroundColorAttributeName: grayTextColor,
//        NSFontAttributeName: textFont
//    };
//    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 3)];
//    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName: redTextColor,
        NSFontAttributeName: textFont
    };
    [attributedString setAttributes:attributes2 range:[string rangeOfString:totalPriceString]];
    
    self.attributedText = attributedString;
}

- (void)netneto_setAttributedTextWithGoodsAmount:(NSInteger)amount {
    NSAssert(amount >= 0, @"商品数量应该大于等于零！");
    
    NSString *amountString = [NSString stringWithFormat:@"%ld", (long)amount];
    NSString *string = [NSString stringWithFormat:@"共 %@ 件商品", amountString];
    
    UIFont *textFont = [UIFont systemFontOfSize:14];
    UIColor *textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
    
    NSDictionary *defaultAttributes = @{
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: textFont
    };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:defaultAttributes];

    NSDictionary *underlineAttributes = @{
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: textFont,
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSUnderlineColorAttributeName: textColor
    };
    NSRange amountStringRange = NSMakeRange(2, amountString.length);
    [attributedString addAttributes:underlineAttributes range:amountStringRange];
    
    self.attributedText = attributedString;
}

@end
