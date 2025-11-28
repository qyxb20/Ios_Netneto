//
//  GouponModel.h
//  Netneto
//
//  Created by apple on 2025/2/11.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GouponModel : BaseModel


@property (nonatomic, copy) NSString *chantType;
///优惠id
@property (nonatomic, assign) NSInteger couponId;
///部分商品还是全部商品
@property (nonatomic, assign) NSInteger couponStatus;
///创建时间
@property (nonatomic, copy) NSString *createTime;
///使用说明
@property (nonatomic, copy) NSString *des;
///早期终了理由
@property (nonatomic, copy) NSString *disableMsg;
///截止时间
@property (nonatomic, copy) NSString *endTime;
///是否领取
@property (nonatomic, assign) NSInteger isReceive;
///名称
@property (nonatomic, copy) NSString *name;
///店铺Id
@property (nonatomic, copy) NSString *shopId;
///优惠券类型
@property (nonatomic, assign) NSInteger type;
///优惠券价格
@property (nonatomic, assign) NSInteger value;
///商铺名称
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, assign) NSInteger SelType;
///0-発行中 1-早期終了
@property (nonatomic, assign) NSInteger disableStatus;
@end

NS_ASSUME_NONNULL_END
