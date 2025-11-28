//
//  PhoneBindingViewController.h
//  Netneto
//
//  Created on 2025/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhoneBindingViewController : UIViewController

@property (nonatomic, copy) NSString *lineUserId; // 从 LINE 登录返回的 userId，用于绑定

@end

NS_ASSUME_NONNULL_END

