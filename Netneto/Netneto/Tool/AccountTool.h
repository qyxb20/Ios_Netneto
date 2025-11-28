//
//  AccountTool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define account [AccountTool sharedManager]
@class userModel,UserInfoModel,CSQAlertView;
@interface AccountTool : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) userModel *user;
@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, strong) NSArray *bankArray;
@property (nonatomic, strong) CSQAlertView *alert;
- (void)Kitout;
+ (AccountTool *)sharedManager;
- (void)setIqkeyboardmanager:(BOOL)enable;
- (void)loadRootController;
- (BOOL)isLogin;
- (void)logout;
- (void)loadResource;
- (void)loadBank;
- (void)loadAgroaResource:(NSString *)channel;
- (void)logoutCancel;
@end

NS_ASSUME_NONNULL_END
