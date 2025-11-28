//
//  NSString+tool.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (tool)
+ (NSString *)isNullStr:(id)str;
+ (NSString *)ChangePriceStr:(NSString *)amountString;
+ (NSString *)ChangePriceNum:(CGFloat )amountString;
- (NSAttributedString *)attributedStringWithImage:(UIImage *)image forSubstring:(NSString *)substring;
- (BOOL)containsChineseEnglishOrJapanese;
@end

NS_ASSUME_NONNULL_END
