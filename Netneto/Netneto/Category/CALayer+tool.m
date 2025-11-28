//
//  CALayer+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/5.
//

#import "CALayer+tool.h"

@implementation CALayer (tool)
- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

-(void)setShadowColorWithUIColor:(UIColor *)color {
    self.shadowColor = color.CGColor;
}
@end
