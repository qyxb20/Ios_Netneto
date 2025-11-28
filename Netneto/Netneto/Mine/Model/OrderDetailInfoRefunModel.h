//
//  OrderDetailInfoRefunModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailInfoRefunModel : BaseModel
///itemid
@property (nonatomic, copy) NSString *orderItemId;
///itemid
@property (nonatomic, copy) NSString *refundId;
///商品图片
@property (nonatomic, copy) NSString *pic;
///商品名称
@property (nonatomic, copy) NSString *prodName;
///商铺名称
@property (nonatomic, copy) NSString *shopName;
///商品购买数量
@property (nonatomic, copy) NSString *prodCount;
///商品退货数量
@property (nonatomic, copy) NSString *goodsNum;
///商品价格
@property (nonatomic, assign) NSInteger price;

///商品总价格
@property (nonatomic, copy) NSString *productTotalAmount;
///退款商品单价
@property (nonatomic, copy) NSString *returnPrice;
///退款商品总价
@property (nonatomic, copy) NSString *refundAmount;
///邮费金额
@property (nonatomic, copy) NSString *freightAmount;
///申请原因
@property (nonatomic, copy) NSString *buyerMsg;
///申请凭证
@property (nonatomic, copy) NSString *photoFiles;
///订单号
@property (nonatomic, copy) NSString *orderNumber;
///处理状态 1 待审核 2 同意 3 不同意
@property (nonatomic, copy) NSString *refundSts;
///拒绝原因
@property (nonatomic, copy) NSString *rejectMessage;
///退款状态 1 退款处理中 2 退款成功 3 退款失败
@property (nonatomic, copy) NSString *returnMoneySts;
///申请类型 1 仅退款 2退款退货
@property (nonatomic, copy) NSString *applyType;
///物流公司名称
@property (nonatomic, copy) NSString *expressName;
///物流单号
@property (nonatomic, copy) NSString *expressNo;
///卖家备注
@property (nonatomic, copy) NSString *sellerMsg;
///规格名
@property (nonatomic, copy) NSString *skuName;
///地址id
@property (nonatomic, copy) NSString *addrId;
///收货人
@property (nonatomic, copy) NSString *receiver;
///省
@property (nonatomic, copy) NSString *province;
///市
@property (nonatomic, copy) NSString *city;
///区
@property (nonatomic, copy) NSString *area;
///地址
@property (nonatomic, copy) NSString *addr;
///手机
@property (nonatomic, copy) NSString *mobile;
///是否是默认地址 1是 0 否
@property (nonatomic, copy) NSString *commonAddr;
///省id
@property (nonatomic, copy) NSString *provinceId;
///城市Id
@property (nonatomic, copy) NSString *cityId;
///区域id
@property (nonatomic, copy) NSString *areaId;
///邮编
@property (nonatomic, copy) NSString *postCode;
///申请退款时间
@property (nonatomic, copy) NSString *applyTime;
///卖家处理时间
@property (nonatomic, copy) NSString *handelTime;
///退款时间
@property (nonatomic, copy) NSString *refundTime;
///买家发货时间
@property (nonatomic, copy) NSString *shipTime;
@property (nonatomic, copy) NSArray *orderItems;
///优惠金额
@property (nonatomic, assign) NSInteger reduceAmount;


@end

NS_ASSUME_NONNULL_END
