//
//  BaseNavgationController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseNavgationController.h"

@interface BaseNavgationController ()

@end

@implementation BaseNavgationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
        
       
            viewController.navigationItem.leftBarButtonItem = item;
      
    }
    [super pushViewController:viewController animated:animated];
}

- (void)popAction {
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

@end
