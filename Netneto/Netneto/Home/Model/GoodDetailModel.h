//
//  GoodDetailModel.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodDetailModel : BaseModel
/** 店铺id */
@property (nonatomic, copy) NSString *shopId;
/** 商品名称 */
@property (nonatomic, copy) NSString *prodName;
/** 商品图片 */
@property (nonatomic, copy) NSString *pic;
/** 商品分类ID */
@property (nonatomic, copy) NSString *categoryId;
/** 店铺名称 */
@property (nonatomic, copy) NSString *shopName;
/** 商品价格 */
@property (nonatomic, copy) NSString *price;
/** 商品原价 */
@property (nonatomic, copy) NSString *oriPrice;
/** 商品库存 */
@property (nonatomic, copy) NSString *totalStocks;
/** 商品规格列表 */
@property (nonatomic, copy) NSArray *skuList;
/** 商品分类名称 */
@property (nonatomic, copy) NSString *categoryName;
/** 是否包邮 */
@property (nonatomic, assign) BOOL isFreeFee;
/** 商品邮寄 */
@property (nonatomic, copy) NSDictionary *transport;
/** 商家状态 */
@property (nonatomic, copy) NSString *shopStatus;
/** 销售量 */
@property (nonatomic, copy) NSString *soldNum;
/** 优惠券列表 */
@property (nonatomic, copy) NSArray *couponsList;
@end

NS_ASSUME_NONNULL_END
