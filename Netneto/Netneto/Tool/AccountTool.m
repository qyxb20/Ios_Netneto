//
//  AccountTool.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "AccountTool.h"
static AccountTool *_manager = nil;
@implementation AccountTool
+ (AccountTool *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[AccountTool alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        if (token) {
            _accessToken = token;
        }
        userModel *model = [SaveManager getUserModel];
        if (model) {
            _user = model;
            _userId = model.userId;
        }
    }
    return self;
}

- (void)setIqkeyboardmanager:(BOOL)enable {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = enable;
    manager.shouldResignOnTouchOutside = enable;
    manager.enable = enable;
}
#pragma mark - 跳转根视图
- (void)loadRootController {
  
    if ([self isLogin]) {

        APPDELEGATE.window.rootViewController = [[BaseTabbarController alloc] init];
        [self loadResource];
        [account loadBank];
    }else {
        APPDELEGATE.window.rootViewController = [[BaseTabbarController alloc] init];
       
    }

        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [UISearchBar appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;

}
#pragma mark - 存储token
- (void)setUser:(userModel *)user {
    _user = user;
    if (user.accessToken.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:user.accessToken forKey:@"Token"];
        _accessToken = user.accessToken;
    }
    _userId = user.userId;
    [SaveManager saveUserModel:user];
}
-(void)setUserInfo:(UserInfoModel *)userInfo{
    _userInfo = userInfo;
    [SaveManager saveUserInfoModel:userInfo];
}
- (BOOL)isLogin {
    NSLog(@"是否有token:%@",self.accessToken);
    return [NSString isNullStr:self.accessToken].length > 0 ;
}
#pragma mark - 登出
- (void)logout {
    [SaveManager clearAll];
    account.userId = @"";
    account.user = nil;
    account.userInfo = nil;
    account.accessToken = @"";
    
    [[RTM sharedRtmTool] uninitRtm];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];

    if (self.isLogin) {
        APPDELEGATE.window.rootViewController = [[BaseTabbarController alloc] init];
        [self loadResource];
        [account loadBank];
    }else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [APPDELEGATE.window.rootViewController pushController:vc]   ;
    }
}
- (void)logoutCancel {
    [self.alert hide];
    [SaveManager clearAll];
    account.userId = @"";
    account.user = nil;
    account.userInfo = nil;
    account.accessToken = @"";
    [[RTM sharedRtmTool] uninitRtm];

    if (self.isLogin) {
        APPDELEGATE.window.rootViewController = [[BaseTabbarController alloc] init];
        [self loadResource];
        [account loadBank];
    }else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.isCancel = @"1";
        [APPDELEGATE.window.rootViewController pushController:vc]   ;
    }
}
#pragma mark - 被踢掉
- (void)Kitout {
    
    [[RTC sharedRTCTool] stopPreview];
    [[RTC sharedRTCTool] leaveChannel];
    [[RTM sharedRtmTool] signoutRtm];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeLive" object:nil userInfo:nil];
 
        [self.alert hide];
        self.alert = [[CSQAlertView alloc] initWithOtherTitle:TransOutput(@"提示") Message:TransOutput(@"您的账号已在其他设备登录，请重新登录") btnTitle:TransOutput(@"确定") btnClick:^{
               [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];
                [self  logoutCancel];
             

            }];
        @weakify(self);
        [self.alert setHideBlock:^{
            @strongify(self);
            [SaveManager clearAll];
            account.userId = @"";
            account.user = nil;
            account.userInfo = nil;
            account.accessToken = @"";
            [[RTM sharedRtmTool] uninitRtm];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];

            [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
           
            
        }];
            [self.alert show];
            
 
}
#pragma mark - 加载资源
- (void)loadResource {
    [NetwortTool getUserInfoSuccess:^(id  _Nonnull responseObject) {
        self.userInfo = [UserInfoModel mj_objectWithKeyValues:responseObject];
        if (![Socket sharedSocketTool].autoReconnect && ![Socket sharedSocketTool].isLogin) {
            [[Socket sharedSocketTool] initSocket];
        }
        if ([Socket sharedSocketTool].autoReconnect && ![Socket sharedSocketTool].isLogin) {
            //已连接 未登录
            [[Socket sharedSocketTool] loginSocket];
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataCoupon" object:nil userInfo:nil];
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      
    }];
   
}
#pragma mark - 加载银行数据
- (void)loadBank {
    [NetwortTool getBankInfoCusWithParm:@{@"pid":@(0)} Success:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject;
       
        NSUInteger length = MIN(6, arr.count); // 确保不超出数组长度
        NSRange range = NSMakeRange(0, length);
        self.bankArray= [arr subarrayWithRange:range];

    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
#pragma mark -加载rtm
- (void)loadAgroaResource:(NSString *)channel {
    [NetwortTool getRtmInfoUserWithParm:@{@"userId":[NSString isNullStr:account.userInfo.userId],@"uid":[NSString isNullStr:account.userInfo.uid],@"channel":channel} Success:^(id  _Nonnull responseObject) {
        self.userInfo = [UserInfoModel mj_objectWithKeyValues:responseObject];
       
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      
    }];
   
}
@end
