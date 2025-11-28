//
//  UITabBar+tool.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (tool)
- (void)showBadgeOnItemIndex:(int)index tex:(NSString *)number;
- (void)removeBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
