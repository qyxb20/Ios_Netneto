//
//  UserInfoModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : BaseModel
/**生日*/
@property (nonatomic, copy) NSString *birthDay;
/**是否是商户 1是 0否*/
@property (nonatomic, copy) NSString *merchant;
/**昵称*/
@property (nonatomic, copy) NSString *nickName;
/**头像*/
@property (nonatomic, copy) NSString *pic;
/**性别*/
@property (nonatomic, copy) NSString *sex;
/**用户状态 0禁用 1正常*/
@property (nonatomic, copy) NSString *status;
/**uid*/
@property (nonatomic, copy) NSString *uid;
 /**账户*/
@property (nonatomic, copy) NSString *userAccount;
 /**邮箱*/
@property (nonatomic, copy) NSString *userMail;
 /**手机*/
@property (nonatomic, copy) NSString *userMobile;
 /**userID*/
@property (nonatomic, copy) NSString *userId;
 /**是否为管理员*/
@property (nonatomic, copy) NSString *isManager;

 /**是否关注*/
@property (nonatomic, copy) NSString *isFollow;

 /**是否禁言*/
@property (nonatomic, copy) NSString *speechStatus;
 /**是否被踢出房间*/
@property (nonatomic, copy) NSString *joinStatus;
 /**频道号*/
@property (nonatomic, copy) NSString *channel;
@end

NS_ASSUME_NONNULL_END
