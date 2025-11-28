//
//  OrderModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : BaseModel
///总价
@property (nonatomic, copy) NSString *actualTotal;
///优惠金额
@property (nonatomic, assign) NSInteger reduceAmount;
///订单id
@property (nonatomic, copy) NSString *orderItemId;
///订单状态 0-订单进行中 1-订单完成 2-退款中 3-退款完成 4-取消
@property (nonatomic, copy) NSString *orderStatus;
///图片
@property (nonatomic, copy) NSString *pic;
///商品价格
@property (nonatomic, copy) NSString *price;
///订单状态
@property (nonatomic, copy) NSString *status;
///是否评论 0-否 1-是
@property (nonatomic, copy) NSString *isComm;
///商品数量
@property (nonatomic, copy) NSString *prodCount;
///商品id
@property (nonatomic, copy) NSString *prodId;
///商品名称
@property (nonatomic, copy) NSString *prodName;
///商铺名称
@property (nonatomic, copy) NSString *shopName;
///商品总金额
@property (nonatomic, copy) NSString *productTotalAmount;
///skuName
@property (nonatomic, copy) NSString *skuName;
///skuID
@property (nonatomic, copy) NSString *skuId;
///满折优惠ID
@property (nonatomic, copy) NSString *discountId;
///basketId
@property (nonatomic, copy) NSString *basketId;

///分摊优惠金额
@property (nonatomic, copy) NSString *shareReduce;
///运费
@property (nonatomic, copy) NSString *freightAmount;

///订单号
@property (nonatomic, copy) NSString *orderNumber;
///商品数量
@property (nonatomic, copy) NSString *productNums;

///退货状态 0:默认,1:在处理,2:处理完成
@property (nonatomic, copy) NSString *refundSts;
//商品列表
@property (nonatomic, copy) NSArray *orderItemDtos;
@end

NS_ASSUME_NONNULL_END
