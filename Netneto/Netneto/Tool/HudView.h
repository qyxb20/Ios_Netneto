//
//  HudView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HudView : NSObject
+ (MBProgressHUD *)showHudForView:(UIView *_Nullable)v;
+ (void)hideHudForView:(UIView *_Nullable)v;
+ (MBProgressHUD *)showAnimateHudForView:(UIView *_Nullable)v;

@end

NS_ASSUME_NONNULL_END
