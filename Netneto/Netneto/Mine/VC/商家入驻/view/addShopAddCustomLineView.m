//
//  addShopAddCustomLineView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "addShopAddCustomLineView.h"

@implementation addShopAddCustomLineView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
