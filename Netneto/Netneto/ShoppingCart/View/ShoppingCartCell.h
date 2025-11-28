//
//  ShoppingCartCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import "MGSwipeTableCell.h"

@class ShopCarModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat ShoppingCartCellHeight;
UIKIT_EXTERN NSString *const ShoppingCartCellReuserIdentifier;

// 购物袋商品 cell 单选按钮点击 Block
typedef void(^ShoppingCartSelectGoodsBlock)(BOOL isSelected,ShopCarModel*model);

// 修改商品数量
typedef void(^ShoppingCartUpdateGoodsQuantityBlock)(NSInteger quantity);
// 修改商品数量
typedef void(^ShoppingCartUpdateGoodsQuantityBlock)(NSInteger quantity);
// 删除商品
typedef void(^ShoppingCartDelGoodsBlock)(NSString *basketIds);

@interface ShoppingCartCell : MGSwipeTableCell
@property (nonatomic, strong) ShopCarModel *goods;
@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, copy) ShoppingCartSelectGoodsBlock selectGoodsBlock;
@property (nonatomic, copy) ShoppingCartUpdateGoodsQuantityBlock updateGoodsQuantityBlock;
@property (nonatomic, copy) ShoppingCartDelGoodsBlock delBlock;

@property (nonatomic, copy) void (^updateNumberClickBlock) (ShopCarModel*model,NSInteger quantity,NSInteger currentNumber);
@property (nonatomic, copy) void (^customNumberClickBlock) (ShopCarModel*model,NSInteger quantity);
-(void)updateNumBer:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
