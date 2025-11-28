//
//  UIBezierPath+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "UIBezierPath+tool.h"

@implementation UIBezierPath (tool)
+ (instancetype)polygonInRect:(CGRect)rect sides:(NSInteger)sides linewidth:(CGFloat)linewidth cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *path  = [UIBezierPath bezierPath];
    CGFloat theta = 2.0 * M_PI / sides;
    CGFloat offset = cornerRadius * tanf(theta / 2.0);
    CGFloat squareWidth = MIN(rect.size.width,rect.size.height);
    CGFloat length = squareWidth - linewidth;
    if (sides % 4 != 0) {
        length = length * cosf(theta / 2.0) + offset/2.0;
    }
    CGFloat sideLength = length * tanf(theta / 2.0);
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2.0 + sideLength / 2.0 - offset,rect.origin.y + rect.size.height / 2.0 + length / 2.0);
    CGFloat angle = M_PI;
    [path moveToPoint:point];
    for (NSInteger side = 0; side < sides; side++) {
        point = CGPointMake(point.x + (sideLength - offset * 2.0) * cosf(angle),point.y + (sideLength - offset * 2.0) * sinf(angle));
        [path addLineToPoint:point];
        CGPoint center = CGPointMake(point.x + cornerRadius * cosf(angle + M_PI_2),point.y + cornerRadius * sinf(angle + M_PI_2));
        [path addArcWithCenter:center radius:cornerRadius startAngle:angle - M_PI_2 endAngle:angle + theta - M_PI_2 clockwise:YES];
        point = path.currentPoint;
        angle += theta;
    }
    [path closePath];
    path.lineWidth = linewidth;
    path.lineJoinStyle = kCGLineJoinRound;
    return path;
}
@end
