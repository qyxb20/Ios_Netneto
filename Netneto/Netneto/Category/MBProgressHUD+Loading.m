//
//  MBProgressHUD+Loading.m
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "MBProgressHUD+Loading.h"

@implementation MBProgressHUD (Loading)
+ (void)showError:(NSString *)error
{

    [self showError:error withView:nil];
}
+ (void)showError:(NSString *)error withView:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].delegate window];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = error;
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 1;
    hud.label.numberOfLines = 0;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:[UIApplication sharedApplication].keyWindow];
}
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    
    if (!view){
        view = [[UIApplication sharedApplication].windows lastObject];
    }
   
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

  
    
    return hud;
}
+(void)updateMess:(NSString *)text hud:(MBProgressHUD *)hud{
    hud.label.text = text;
    
}
@end
