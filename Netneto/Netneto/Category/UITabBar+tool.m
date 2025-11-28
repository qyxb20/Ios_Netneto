//
//  UITabBar+tool.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/29.
//

#import "UITabBar+tool.h"
#define TabbarItemNums 5.0
@implementation UITabBar (tool)
// 显示红点
- (void)showBadgeOnItemIndex:(int)index tex:(NSString *)number {

    [self removeBadgeOnItemIndex:index];
    // 新建小红点
    UILabel *bview = [[UILabel alloc]init];
    bview.tag = 888 + index;
    bview.layer.cornerRadius = 8;
    bview.clipsToBounds = YES;
    bview.textColor = [UIColor whiteColor];
    bview.font = [UIFont systemFontOfSize:8];
    bview.textAlignment = NSTextAlignmentCenter;
    bview.text = number;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFram.size.width);
    CGFloat y = ceilf(0.1 * tabFram.size.height);
    bview.frame = CGRectMake(x, y, 16, 16);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}
// 移除控件
- (void)removeBadgeOnItemIndex:(int)index {

    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}
@end
