//
//  NSString+tool.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "NSString+tool.h"

@implementation NSString (tool)
+ (NSString *)isNullStr:(id)str {
    if (([str isEqual:[NSNull null]] || str == nil || [str isEqual:@""]|| [str isEqual:@"<null>"])) {
        return @"";
    }
    return str;
}
+ (NSString *)ChangePriceStr:(NSString *)amountString {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:kCFNumberFormatterDecimalStyle];
    NSNumber *amount = [NSNumber numberWithDouble:[amountString doubleValue]];
    NSString *formattedString = [numFormat stringFromNumber:amount];
    return formattedString;
}
+ (NSString *)ChangePriceNum:(CGFloat )amountString {
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:kCFNumberFormatterDecimalStyle];
    NSNumber *num = [NSNumber numberWithDouble:amountString];
    NSString *formattedString = [numFormat stringFromNumber:num];
    return formattedString;
}
- (NSAttributedString *)attributedStringWithImage:(UIImage *)image forSubstring:(NSString *)substring {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:substring];
    
    // 创建一个NSTextAttachment，并将其初始化为图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -2, image.size.width, image.size.height); // 根据需要调整图片位置
    
    // 用NSTextAttachment创建NSAttributedString
    NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 将字符串中的指定字符替换为图片
    [attributedString replaceCharactersInRange:range withAttributedString:imageAttributedString];
    
    return attributedString;
}
- (BOOL)containsChineseEnglishOrJapanese {
    for (NSInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        
//        // 中文字符范围是0x4E00到0x9FA5
//        if (c >= 0x4E00 && c <= 0x9FA5) {
//            return YES;
//        }
        // 日文字符范围是0x0800-0x4e00
        if (c >= 0x0800 && c <= 0x4e00) {
            return YES;
        }
        // 英文字符范围是0x0020-0x007F，0x00A0-0x00FF，0x2000-0x2BFF
        if ((c >= 0x0020 && c <= 0x007F) || (c >= 0x00A0 && c <= 0x00FF) || (c >= 0x2000 && c <= 0x2BFF)) {
            return YES;
        }
    }
    return NO;
}
 

@end
