//
//  AppDelegate.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "AppDelegate.h"
@import LineSDK;
static UIBackgroundTaskIdentifier bgTask;
@interface AppDelegate ()
@property(nonatomic, strong)UIAlertView *alertView;
@property(nonatomic, strong)UIAlertView *alertTi;
@end

@implementation AppDelegate

+ (instancetype)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 检查是否通过 URL Scheme 启动
    NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
    if (url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self application:application openURL:url options:launchOptions];
        });
    }
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyWindow];
   
    [SQIPInAppPaymentsSDK setSquareApplicationID:SQIAPPID];
    
    [self configureLineSDK];

    // Override point for customization after application launch.
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 检查是否是 Line SDK 的回调
    if ([url.scheme hasPrefix:@"line3rdp."]) {
        BOOL handled = [[LineSDKLoginManager sharedManager] application:app open:url options:options];
        if (handled) {
            return YES;
        }
    }
    return NO;
}

// iOS 9.0 之前的旧方法（兼容性）
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSDictionary *options = @{UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication ?: @""};
    return [self application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        
        // 检查是否是 Line 的回调 URL
        if ([webpageURL.host isEqualToString:@"netneto.co.jp"] && [webpageURL.path hasPrefix:@"/oauth/callback/line"]) {
            BOOL handled = [[LineSDKLoginManager sharedManager] application:application open:webpageURL options:@{}];
            if (handled) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - 检查版本更新
-(void)checkVersionUpdate{
    [NetwortTool getAppVersionWithParm:@{@"appType":@"1",@"appVersion":versionNum} Success:^(id  _Nonnull responseObject) {
        NSLog(@"输出app版本信息:%@",responseObject);
        if ([responseObject[@"forcedUpdate"] isEqual:@(1)]) {
            NSString *mes = [NSString stringWithFormat:@"%@%@,%@",TransOutput(@"发现最新版本"),responseObject[@"newAppVersion"],TransOutput(@"需更新后才能继续使用")];
            
            if (self.alertTi) {
                [self.alertView setHidden:YES];
                [self.alertView show];
            }else{
                self.alertView = [[UIAlertView alloc] initWithTitle:TransOutput(@"提示") message:mes delegate:self cancelButtonTitle:nil otherButtonTitles:TransOutput(@"确定"), nil];
                self.alertView.tag = 1001;
                [self.alertView show];
            }
           

                
        }else{
            if ([responseObject[@"update"] isEqual:@(1)]) {
                NSString *mes = [NSString stringWithFormat:@"%@%@,%@",TransOutput(@"发现最新版本"),responseObject [@"newAppVersion"],TransOutput(@"是否更新?")];
                
                if (self.alertTi) {
                    [self.alertTi setHidden:YES];
                    [self.alertTi show];
                }else{
                    self.alertTi = [[UIAlertView alloc] initWithTitle:TransOutput(@"提示") message:mes delegate:self cancelButtonTitle:TransOutput(@"取消") otherButtonTitles:TransOutput(@"确定"), nil];
                    self.alertTi.tag = 1002;
                    [self.alertTi show];
                }
            }
        }
            
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/6737018234"] options:@{} completionHandler:^(BOOL res) {
           //
                           }];
        }
    }
    if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/6737018234"] options:@{} completionHandler:^(BOOL res) {
           
                           }];
        }
    }
}

- (void)configureLineSDK {
    LineSDKLoginManager *manager = [LineSDKLoginManager sharedManager];
    if (manager.isSetupFinished) {
        return;
    }

    NSString *channelID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LineChannelID"];
    if (channelID.length == 0 || [channelID containsString:@"YOUR_LINE_CHANNEL_ID"]) {
        return;
    }
    NSString *universalLinkString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LineUniversalLinkURL"];
    NSURL *universalLinkURL = nil;
    
    // 使用 Universal Link 配置
    if (universalLinkString.length > 0 && ![universalLinkString containsString:@"your.domain.com"]) {
        universalLinkURL = [NSURL URLWithString:universalLinkString];
    }

    @try {
        [manager setupWithChannelID:channelID universalLinkURL:universalLinkURL];
    } @catch (NSException *exception) {
        // Setup failed
    }
}

- (void)diagnoseUniversalLinkConfiguration {
    // 诊断方法已移除，不再输出日志
}

#pragma mark - 进入前台
-(void)applicationDidBecomeActive:(UIApplication *)application{
    [self checkVersionUpdate];

    if (![Socket sharedSocketTool].autoReconnect) {
        [[Socket sharedSocketTool] initSocket];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self getBackgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endBackgroundTask];
}

//获取后台任务
- (void)getBackgroundTask {
    
    NSLog(@"getBackgroundTask");
    UIBackgroundTaskIdentifier tempTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //后台任务
    }];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        [self endBackgroundTask];
    }
    
    bgTask = tempTask;
    
    [self performSelector:@selector(getBackgroundTask) withObject:nil afterDelay:120];
}

//结束后台任务
- (void)endBackgroundTask {
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}
@end
