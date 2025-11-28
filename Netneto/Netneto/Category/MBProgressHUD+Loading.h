//
//  MBProgressHUD+Loading.h
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Loading)
+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+ (void)showError:(NSString *)error;
+(void)updateMess:(NSString *)text hud:(MBProgressHUD *)hud;

@end

NS_ASSUME_NONNULL_END
