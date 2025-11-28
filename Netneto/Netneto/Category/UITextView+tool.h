//
//  UITextView+tool.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (tool)
- (void)setPlaceholderWithText:(NSString *)text Color:(UIColor *)color;
- (void)setRightPlaceholderWithText:(NSString *)text Color:(UIColor *)color;
- (void)setCustomPlaceholderWithText:(NSString *)text Color:(UIColor *)color font:(NSInteger)font;
@end

NS_ASSUME_NONNULL_END
