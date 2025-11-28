//
//  ShopCarModel.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCarModel : NSObject
///产品id
@property (nonatomic, strong) NSString *prodId;
///店铺id
@property (nonatomic, strong) NSString *shopId;
///规格id
@property (nonatomic, strong) NSString *skuId;
///店铺名称
@property (nonatomic, copy) NSString *shopName;
///产品名称
@property (nonatomic, copy) NSString *prodName;
///图片
@property (nonatomic, strong) NSString  *pic;
///商品总金额
@property (nonatomic, strong) NSString *productTotalAmount;
///产品价格
@property (nonatomic, strong) NSString *price;
///购物车id
@property (nonatomic, strong) NSString *basketId;
///结算金额
@property (nonatomic, copy) NSString *actualTotal;
///产品原价
@property (nonatomic, copy) NSString *oriPrice;
///加入购物车时间
@property (nonatomic, strong) NSString  *basketDate;
///规格名称
@property (nonatomic, strong) NSString  *skuName;
///产品个数
@property (nonatomic, strong) NSString  *prodCount;
///库存
@property (nonatomic, strong) NSString  *stocks;
///限购数量
@property (nonatomic, strong) NSString  *limitSum;
///产品个数修改
@property (nonatomic, assign) NSInteger  prodCountSel;
@property (nonatomic, strong) NSNumber *selectedState;
-(instancetype)initWithDic:(NSDictionary *)dic;
-(instancetype)modelWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
