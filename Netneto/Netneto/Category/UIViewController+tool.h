//
//  UIViewController+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (tool)
+ (UIViewController *)topViewController;
+ (UIViewController *)currentViewController;
- (void)popViewControllerAnimate;
- (void)popRootViewControllerAnimate;
- (void)dismissViewController:(BOOL)isAnimate;
- (void)pushController:(UIViewController *)vc;
- (void)pushControllerNoAnimate:(UIViewController *)vc;
- (void)removeControllerWithController:(NSString *)vc;
@end

NS_ASSUME_NONNULL_END
