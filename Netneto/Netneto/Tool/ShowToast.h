//
//  ShowToast.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define ToastShow(s,a,r) [ShowToast showText:s withImgName:a color:r]

@interface ShowToast : NSObject
+ (void)showText:(NSString *)text withImgName:(NSString *)imgName color:(UIColor *)color;
+ (void)showText:(NSString *)text inView:(UIView *)view withImgName:(NSString *)imgName color:(UIColor *)color;
+ (void)showText:(NSString *)text yOffset:(float)yOffset withImgName:(NSString *)imgName color:(UIColor *)color;
+ (void)showText:(NSString *)text inView:(UIView *_Nullable)view yOffset:(float)yOffset withImgName:(NSString *)imgName color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
