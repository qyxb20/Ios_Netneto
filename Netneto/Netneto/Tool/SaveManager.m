//
//  SaveManager.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "SaveManager.h"

@implementation SaveManager
+ (void)saveUserModel:(userModel *)model {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SaveUserModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (userModel *)getUserModel {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserModel"];
    userModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}
+ (void)saveUserInfoModel:(UserInfoModel *)model{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"SaveUserInfoModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(UserInfoModel *)getUserInfoModel{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserInfoModel"];
    UserInfoModel *userinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userinfo;
}
+ (void)clearAll {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SaveUserModel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SaveUserInfoModel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  
}
@end
