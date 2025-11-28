
#import "UIDevice+VGAddition.h"

@implementation UIDevice (VGAddition)
/// 顶部安全区高度
+ (CGFloat)vg_safeDistanceTop {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 底部安全区高度
+ (CGFloat)vg_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

+(UIEdgeInsets)dt_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    } else {
        // Fallback on earlier versions
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}
/// 顶部状态栏高度（包括安全区）
+ (CGFloat)vg_statusBarHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

/// 导航栏高度
+ (CGFloat)vg_navigationBarHeight {
    return 44.0f;
}

/// 状态栏+导航栏的高度
+ (CGFloat)vg_navigationFullHeight {
    return [UIDevice vg_statusBarHeight] + [UIDevice vg_navigationBarHeight];
}

/// 底部导航栏高度
+ (CGFloat)vg_tabBarHeight {
    return 49.0f;
}

/// 底部导航栏高度（包括安全区）
+ (CGFloat)vg_tabBarFullHeight {
    return [UIDevice vg_tabBarHeight] + [UIDevice vg_safeDistanceBottom];
}
@end
