//
//  BaseTabbarController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseTabbarController.h"

@interface BaseTabbarController ()
@property (nonatomic, strong) UIBlurEffect *backgroundEffect;
@end

@implementation BaseTabbarController

- (instancetype)init {
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, 0);
    if (self = [super initWithViewControllers:[self controllersForTabBar]
                        tabBarItemsAttributes:[self attributesForTabBar]
                                  imageInsets:imageInsets
                      titlePositionAdjustment:titlePositionAdjustment
                                      context:@""
                ]) {
        [self customizeTabBarAppearance:titlePositionAdjustment];
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInterface];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)customInterface {
    [self setViewDidLayoutSubViewsBlockInvokeOnce:YES block:^(CYLTabBarController * _Nonnull tabBarController) {
        
    }];
}

- (NSArray *)controllersForTabBar {
    BaseNavgationController *home = [[BaseNavgationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    BaseNavgationController *classification = [[BaseNavgationController alloc] initWithRootViewController:[[ClassificationViewController alloc] init]];
    BaseNavgationController *shoppingCart = [[BaseNavgationController alloc] initWithRootViewController:[[ShopCarViewController alloc] init]];
    BaseNavgationController *live = [[BaseNavgationController alloc] initWithRootViewController:[[LiveMainViewController alloc] init]];
    BaseNavgationController *mine = [[BaseNavgationController alloc] initWithRootViewController:[[MineViewController alloc] init]];
    return @[home,classification,shoppingCart,live,mine];
}

- (NSArray *)attributesForTabBar {
    NSDictionary *home = @{CYLTabBarItemImage : [UIImage imageNamed:@"tabbar_home"],CYLTabBarItemSelectedImage:@"tabbar_home_s",CYLTabBarItemTitle:TransOutput(@"首页")};
    NSDictionary *video = @{CYLTabBarItemImage : [UIImage imageNamed:@"tabbar_video"],CYLTabBarItemSelectedImage:@"tabbar_video_s",CYLTabBarItemTitle:TransOutput(@"分类")};
    NSDictionary *message = @{CYLTabBarItemImage : [UIImage imageNamed:@"shopcar_no_check"],CYLTabBarItemSelectedImage:@"shopcar_check",CYLTabBarItemTitle:TransOutput(@"购物车")};
    NSDictionary *dymic = @{CYLTabBarItemImage : [UIImage imageNamed:@"tabbar_dymic"],CYLTabBarItemSelectedImage:@"tabbar_dymic_s",CYLTabBarItemTitle:TransOutput(@"LIVE")};
    NSDictionary *mine = @{CYLTabBarItemImage : [UIImage imageNamed:@"tabbar_mine"],CYLTabBarItemSelectedImage:@"tabbar_mine_s",CYLTabBarItemTitle:TransOutput(@"我的")};
    return @[home,video,message,dymic,mine];
}

- (void)customizeTabBarAppearance:(UIOffset)offset {
    [self rootWindow].backgroundColor = [UIColor cyl_systemBackgroundColor];
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor cyl_systemGrayColor];
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor cyl_labelColor];
    [UITabBar appearance].translucent = NO;
    if (@available(iOS 13.0, *)) {
        UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance  alloc] init];
        inlineLayoutAppearance.normal.titlePositionAdjustment = offset;
        [inlineLayoutAppearance.normal setTitleTextAttributes:normalAttrs];
        [inlineLayoutAppearance.selected setTitleTextAttributes:selectedAttrs];
        UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
        standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance;
        standardAppearance.backgroundColor = [UIColor whiteColor];
        standardAppearance.shadowColor = RGB_ALPHA(0x18181D, 0.2);
        self.tabBar.standardAppearance = standardAppearance;
        self.backgroundEffect = standardAppearance.backgroundEffect;
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        
        

    } else {
        UITabBarItem *tabBar = [UITabBarItem appearance];
        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, HeightTabbar)]];
        [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedBackGenertor impactOccurred];
    [self updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController shouldSelect:YES];
  
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    NSLog(@"点击的是第 %lu 个按钮",(unsigned long)tabBarController.selectedIndex);
    if ([control cyl_isTabButton]) {
        animationView = [control cyl_tabImageView];
    }
    
    UIButton *button = CYLExternPlusButton;
    BOOL isPlusButton = [control cyl_isPlusButton];
    if (isPlusButton) {
        animationView = button.imageView;
    }
    [self addAnimation:animationView];
    
        self.tabBar.standardAppearance.backgroundColor = [UIColor whiteColor];
        self.tabBar.standardAppearance.backgroundEffect = self.backgroundEffect;
        self.tabBar.standardAppearance.shadowColor = RGB_ALPHA(0x18181D, 0.2);
        self.tabBar.backgroundColor = [UIColor whiteColor];
        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.translucent = NO;
    if (tabBarController.selectedIndex == 2) {
        if (!account.isLogin) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.isCancel = @"2";
            [self pushControllerNoAnimate:vc];
            
        }
    }
}

- (void)addAnimation:(UIView *)v {
    dispatch_async(dispatch_get_main_queue(), ^{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
        animation.duration = 1;
        animation.repeatCount = 1;
        animation.calculationMode = kCAAnimationCubic;
        [v.layer addAnimation:animation forKey:nil];
    });
}


@end
