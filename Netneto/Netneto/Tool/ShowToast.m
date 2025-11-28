//
//  ShowToast.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/23.
//

#import "ShowToast.h"

@implementation ShowToast
+ (void)showText:(NSString *)text withImgName:(nonnull NSString *)imgName color:(UIColor *)color {
    [self showText:text yOffset:0 withImgName:imgName color:color];
}
+ (void)showText:(NSString *)text inView:(UIView *)view withImgName:(NSString *)imgName color:(UIColor *)color{
    [self showText:text inView:view yOffset:0 withImgName:imgName color:color];
}
+ (void)showText:(NSString *)text yOffset:(float)yOffset withImgName:(NSString *)imgName color:(UIColor *)color{
    [self showText:text inView:nil yOffset:yOffset withImgName:imgName color:color];
}
+ (void)showText:(NSString *)text inView:(UIView *_Nullable)view yOffset:(float)yOffset withImgName:(NSString *)imgName color:(UIColor *)color{
    [self showText:text inView:view yOffset:yOffset afterDismiss:3 withImgName:imgName color:color];
}
+ (void)showText:(NSString *)text inView:(UIView *_Nullable)view yOffset:(float)yOffset afterDismiss:(CGFloat)secs withImgName:(NSString *)imgName color:(UIColor *)color{
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *sv = view;
        if (!sv) {
            sv = [UIApplication sharedApplication].keyWindow;
        }
        UIView *v = [sv viewWithTag:31415926];
        if (v) {
            [v removeFromSuperview];
        }
        CGFloat imgW = 32;
        if (imgName.length == 0) {
            imgW = 0;
        }
        CGFloat labelW = [Tool getLabelWidthWithText:text height:30 font:16] + imgW;
        CGFloat viewW = WIDTH - 44 ;
        if (labelW > WIDTH - 44 - 32) {
            labelW = WIDTH - 44 - 32;
            
        }
        else{
            viewW = labelW + 32;
        }
        CGFloat labelH = [Tool getLabelHeightWithText:text width:WIDTH - 44 - 32 - imgW font:16];
        
      
        if (labelH < 22) {
            labelH = 22;
        }
        UIView *laV = [[UIView alloc] initWithFrame:CGRectMake(22, 100, viewW, labelH + 16)];
        laV.backgroundColor = color;
        laV.layer.cornerRadius = (labelH + 16) / 2;
        laV.clipsToBounds = YES;
        laV.center = CGPointMake(sv.center.x, laV.center.y);
        [sv addSubview:laV];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:imgName];
        attch.bounds = CGRectMake(0, -5, 18,18);
        NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)attch];
        if (imgName.length != 0) {
            [attriStr insertAttributedString:space atIndex:0];
            [attriStr insertAttributedString:string atIndex:0];
        }
   
 
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16 , 8, labelW, labelH)];
        label.attributedText = attriStr;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        [laV addSubview:label];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //3秒后 执行block内的代码
            [laV removeFromSuperview];
            [sv removeFromSuperview];
            [v removeFromSuperview];
            });
       
    });
}
@end
