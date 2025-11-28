//
//  AppDelegate.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) UIWindow *window;
+ (instancetype)sharedDelegate;
@end

