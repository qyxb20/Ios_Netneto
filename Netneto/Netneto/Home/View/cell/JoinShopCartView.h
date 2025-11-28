//
//  JoinShopCartView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/8.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
// 修改商品数量
typedef void(^ShoppingCartUpdateGoodsQuantityBlock)(NSInteger quantity);

@interface JoinShopCartView : BaseView
+ (instancetype)initViewNIB;
-(void)updataWithDic:(NSDictionary *)dataDic;
@property (nonatomic, strong) NSDictionary *selecSkuDic;
@property (nonatomic, copy) ShoppingCartUpdateGoodsQuantityBlock updateGoodsQuantityBlock;
@property (nonatomic, copy) void (^joinItemClickBlock) (NSDictionary *dic,CGFloat num);
@property (nonatomic, copy) void (^NowBuyClickBlock) (NSDictionary *dic,CGFloat num);

@property (nonatomic, assign) BOOL isJoin;
@end

NS_ASSUME_NONNULL_END
