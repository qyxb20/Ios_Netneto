//
//  CSQAlertView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^btnClickBlock)(void);
typedef void(^cancelClickBlock)(void);

@interface CSQAlertView : BaseView
/// 带标题 和 内容的 弹窗
/// @param title 标题
/// @param message 内容
/// @param btnTitle 按钮文案
/// @param btnClick 按钮点击
- (instancetype)initWithTitle:(NSString *_Nullable)title Message:(NSString *_Nullable)message btnTitle:(NSString *_Nullable)btnTitle cancelBtnTitle:(NSString *_Nullable)cancelTitle btnClick:(nullable btnClickBlock)btnClick cancelBlock:(nullable cancelClickBlock)cancleBlock;

- (instancetype)initWithCutomOrderTitle:(NSString *_Nullable)title Message:(NSString *_Nullable)message btnTitle:(NSString *_Nullable)btnTitle cancelBtnTitle:(NSString *_Nullable)cancelTitle btnClick:(nullable btnClickBlock)btnClick cancelBlock:(nullable cancelClickBlock)cancleBlock;

- (instancetype)initWithOtherTitle:(NSString *_Nullable)title Message:(NSString *_Nullable)message btnTitle:(NSString *_Nullable)btnTitle  btnClick:(nullable btnClickBlock)btnClick;

- (void)show;
- (void)hide;

@property(nonatomic,copy)void (^hideBlock) (void);

@end

NS_ASSUME_NONNULL_END
