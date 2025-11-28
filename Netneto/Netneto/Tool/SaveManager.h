//
//  SaveManager.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveManager : NSObject
+ (void)saveUserModel:(userModel *)model;
+ (userModel *)getUserModel;

+ (void)saveUserInfoModel:(UserInfoModel *)model;
+ (UserInfoModel *)getUserInfoModel;
+ (void)clearAll;
@end

NS_ASSUME_NONNULL_END
