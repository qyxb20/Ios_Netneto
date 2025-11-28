//
//  userModel.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface userModel : BaseModel
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *expiresIn;
@property (nonatomic, copy) NSString *refreshToken;
@end

NS_ASSUME_NONNULL_END
