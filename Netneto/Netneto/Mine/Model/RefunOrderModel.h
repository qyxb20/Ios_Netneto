//
//  RefunOrderModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefunOrderModel : BaseModel

///订单id
@property (nonatomic, copy) NSString *refundId;
///申请类型
@property (nonatomic, copy) NSString *applyType;
///图片
@property (nonatomic, copy) NSString *pic;
///退款金额
@property (nonatomic, copy) NSString *returnPrice;
///审核状态
@property (nonatomic, copy) NSString *refundSts;
///退款状态
@property (nonatomic, copy) NSString *returnMoneySts;
///退货数量
@property (nonatomic, copy) NSString *returnCount;
///商品订单号
@property (nonatomic, copy) NSString *orderNumber;
///商品名称
@property (nonatomic, copy) NSString *prodName;
///商铺名称
@property (nonatomic, copy) NSString *shopName;

///skuName
@property (nonatomic, copy) NSString *skuName;
@property (nonatomic, copy) NSString *expressNo;

@property (nonatomic, copy) NSString *expressName;
@property (nonatomic, copy) NSString *refundAmount;

@property (nonatomic, copy) NSArray *orderItems;
///优惠金额
@property (nonatomic, assign) NSInteger reduceAmount;
///金额
@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger prodCount;
@end

NS_ASSUME_NONNULL_END
