//
//  UIViewController+tool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "UIViewController+tool.h"

@implementation UIViewController (tool)
+ (UIViewController *)topViewController {
    return [self topViewControllerWithRootVC:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)topViewControllerWithRootVC:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)rootVC;
        return [self topViewControllerWithRootVC:tabbarVC.selectedViewController];
    }else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)rootVC;
        return [self topViewControllerWithRootVC:navVC.visibleViewController];
    }else if (rootVC.presentedViewController) {
        UIViewController *vc = rootVC.presentedViewController;
        return [self topViewControllerWithRootVC:vc];
    }else {
        return rootVC;
    }
}

+ (UIViewController *)currentViewController {
    UIViewController *vc = [self topViewController];
    BOOL isFin = YES;
    while (isFin) {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else {
            if ([vc isKindOfClass:[UINavigationController class]]) {
                vc = ((UINavigationController *)vc).visibleViewController;
            }else if ([vc isKindOfClass:[UITabBarController class]]) {
                vc = ((UITabBarController *)vc).selectedViewController;
            }else {
                break;
            }
        }
    }
    return vc;
}

- (void)popViewControllerAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)popRootViewControllerAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)dismissViewController:(BOOL)isAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:isAnimate completion:^{
        }];
    });
}

- (void)pushController:(UIViewController *)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self class] currentViewController].navigationController pushViewController:vc animated:YES];
    });
}

- (void)pushControllerNoAnimate:(UIViewController *)vc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self class] currentViewController].navigationController pushViewController:vc animated:NO];
    });
}

- (void)removeControllerWithController:(NSString *)vc {
    if (!self.navigationController) {
        return;
    }
    NSMutableArray *vcArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *tempvc in vcArr) {
        if ([tempvc isKindOfClass:NSClassFromString(vc)]) {
            [vcArr removeObject:tempvc];
            break;
        }
    }
    [self.navigationController setViewControllers:vcArr];
}

@end
