//
//  UIColor+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (tool)
+ (UIColor*)gradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withHeight:(CGFloat)height;
+ (UIColor*)gradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withWidth:(CGFloat)Width;
+ (UIColor *)gradientColorArr:(NSArray *)colors withWidth:(CGFloat)Width;
+ (UIColor *)gradientColorWithWidth:(CGFloat)width color:(NSArray *)colors;
@end

NS_ASSUME_NONNULL_END
