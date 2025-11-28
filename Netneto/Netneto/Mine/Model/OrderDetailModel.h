//
//  OrderDetailModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface addressModel : BaseModel

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
///是否默认地址
@property (nonatomic, copy) NSString *commonAddr;
///省id
@property (nonatomic, copy) NSString *provinceId;
///市id
@property (nonatomic, copy) NSString *cityId;
///区id
@property (nonatomic, copy) NSString *areaId;
///邮编
@property (nonatomic, copy) NSString *postCode;
@end



@interface OrderDetailModel : BaseModel
///店铺id
@property (nonatomic, copy) NSString *shopId;
///商铺名称
@property (nonatomic, copy) NSString *shopName;
///实际总值
@property (nonatomic, copy) NSString *actualTotal;
///商品总值
@property (nonatomic, copy) NSString *total;
///商品总数
@property (nonatomic, copy) NSString *totalNum;
///地址
@property (nonatomic, copy) NSDictionary *userAddrDto;
///收货人
@property (nonatomic, copy) NSString *receiver;
//银行卡品牌
@property (nonatomic, copy) NSString *cardAbbreviation;
@property (nonatomic, copy) NSString *cardUrl;
//银行卡后四位
@property (nonatomic, copy) NSString *cardNumber;
//运费
@property (nonatomic, copy) NSString *freightAmount;
///省
@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *postCode;
///市
@property (nonatomic, copy) NSString *city;
///区
@property (nonatomic, copy) NSString *area;
///地址
@property (nonatomic, copy) NSString *addr;
///手机
@property (nonatomic, copy) NSString *mobile;

///地址model
@property (nonatomic, copy) addressModel *addModel;
///商品信息model
@property (nonatomic, copy) OrderModel *orderInfoModel;

///运费
@property (nonatomic, copy) NSString *transfee;
///优惠总额
@property (nonatomic, copy) NSString *reduceAmount;
///促销活动优惠金额
@property (nonatomic, copy) NSString *discountMoney;
///优惠卷优惠金额
@property (nonatomic, copy) NSString *couponMoney;
///订单创建时间
@property (nonatomic, copy) NSString *createTime;
///付款时间
@property (nonatomic, copy) NSString *payTime;
///发货时间
@property (nonatomic, copy) NSString *dvyTime;
///完成时间
@property (nonatomic, copy) NSString *finallyTime;
///取消时间
@property (nonatomic, copy) NSString *cancelTime;
///订单备注信息
@property (nonatomic, copy) NSString *remarks;
///订单状态
@property (nonatomic, copy) NSString *status;
///订单退款状态
@property (nonatomic, copy) NSString *refundSts;

//商品列表
@property (nonatomic, copy) NSArray *orderItemDtos;
@property (nonatomic, copy) NSArray *orderItemList;
///订单id
@property (nonatomic, copy) NSString *orderItemId;
///订单状态 0-订单进行中 1-订单完成 2-退款中 3-退款完成 4-取消
@property (nonatomic, copy) NSString *orderStatus;
///图片
@property (nonatomic, copy) NSString *pic;
///商品价格
@property (nonatomic, copy) NSString *price;

///是否评论 0-否 1-是
@property (nonatomic, copy) NSString *isComm;
///商品数量
@property (nonatomic, copy) NSString *prodCount;
///商品id
@property (nonatomic, copy) NSString *prodId;
///商品名称
@property (nonatomic, copy) NSString *prodName;

///skuName
@property (nonatomic, copy) NSString *skuName;

///订单号
@property (nonatomic, copy) NSString *orderNumber;
///商品数量
@property (nonatomic, copy) NSString *productNums;


///物流单号
@property (nonatomic, copy) NSString *expressNo;
///物流公司名称
@property (nonatomic, copy) NSString *expressName;
///返金金额
@property (nonatomic, copy) NSString *refundAmount;
///实际支付金额
@property (nonatomic, copy) NSString *actualPayAmount;
@end

NS_ASSUME_NONNULL_END
