//
//  UIBezierPath+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (tool)
+ (instancetype)polygonInRect:(CGRect)rect sides:(NSInteger)sides linewidth:(CGFloat)linewidth cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
