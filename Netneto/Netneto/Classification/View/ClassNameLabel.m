//
//  ClassNameLabel.m
//  Netneto
//
//  Created by apple on 2024/10/31.
//

#import "ClassNameLabel.h"

@implementation ClassNameLabel
- (void)drawTextInRect:(CGRect)rect {
    CGSize padding = self.padding;
    CGRect insetRect = CGRectMake(rect.origin.x + padding.width,
                                  rect.origin.y + padding.height,
                                  rect.size.width - padding.width * 2,
                                  rect.size.height - padding.height * 2);
    [super drawTextInRect:insetRect];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
