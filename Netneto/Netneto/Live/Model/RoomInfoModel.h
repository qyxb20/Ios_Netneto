//
//  RoomInfoModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/8.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomInfoModel : BaseModel
/** 直播间详情/列表可以不展示 */
@property (nonatomic, copy) NSString *msg;
/** 直播间公告详情 */
@property (nonatomic, copy) NSString *notice;
/** 封面图 */
@property (nonatomic, copy) NSString *imgPath;
/** 频道号 */
@property (nonatomic, copy) NSString *channel;
/** 直播间人数 */
@property (nonatomic, copy) NSString *userCount;
/** 商品名称 */
@property (nonatomic, copy) NSString *shopName;
/** 商户userID */
@property (nonatomic, copy) NSString *userId;
/** 商铺id */
@property (nonatomic, copy) NSString *shopId;
/** 商铺logo */
@property (nonatomic, copy) NSString *shopLogo;
/** 直播权限 0-封禁 1-正常 */
@property (nonatomic, copy) NSString *showRole;
/** 直播权限id */
@property (nonatomic, copy) NSString *showRoleId;
/** 直播分类 */
@property (nonatomic, copy) NSString *showCategoryName;
/** 直播分类id */
@property (nonatomic, copy) NSString *showCategoryId;


@end

NS_ASSUME_NONNULL_END
