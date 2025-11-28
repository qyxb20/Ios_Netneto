//
//  UIColor+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "UIColor+tool.h"

@implementation UIColor (tool)
+ (UIColor*)gradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withHeight:(CGFloat)height {
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSArray* colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, (id)toColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor*)gradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor withWidth:(CGFloat)Width {
    CGSize size = CGSizeMake(Width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSArray* colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, (id)toColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 0), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)gradientColorArr:(NSArray *)colors withWidth:(CGFloat)Width {
    CGSize size = CGSizeMake(Width, 1);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colorsArr = [NSMutableArray array];
    for (UIColor *c in colors) {
        [colorsArr addObject:(id)c.CGColor];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colorsArr, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(size.width, 0), 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)gradientColorWithWidth:(CGFloat)width color:(NSArray *)colors{
    return [UIColor gradientColorArr:colors withWidth:width];
}


@end
