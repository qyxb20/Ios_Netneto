//
//  HudView.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "HudView.h"

@implementation HudView
+ (MBProgressHUD *)showHudForView:(UIView *_Nullable)v {
    if (!v) {
        v = [UIViewController currentViewController].view;
    }
    __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showHUDAddedTo:v animated:YES];
    });
    return hud;
}

+ (void)hideHudForView:(UIView *_Nullable)v {
    if (!v) {
        v = [UIViewController currentViewController].view;
    }

       dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideHUDForView:v animated:YES];
           
       });
 }
+ (MBProgressHUD *)showAnimateHudForView:(UIView *_Nullable)v {
    if (!v) {
        v = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:v animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.margin = 0.f;
    return hud;
}
@end
