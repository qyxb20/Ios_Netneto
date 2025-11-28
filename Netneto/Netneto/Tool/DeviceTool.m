//
//  DeviceTool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "DeviceTool.h"

@implementation DeviceTool
+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    }else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return 0;
}
+ (CGFloat)navigationBarHeight {
    return 44 + [DeviceTool statusBarHeight];
}
+ (CGFloat)tabbarExtraHeight {
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
+ (CGFloat)tabbarHeight {
    return 49 + [DeviceTool tabbarExtraHeight];
}
+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}



@end
