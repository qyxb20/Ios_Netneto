//
//  UILabel+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (tool)
/// 带删除线的商品原价
/// @param price 商品原价
- (void)netneto_setAttributedTextWithOriginalPrice:(float)price;

/// ¥ %.2f
/// 效果：整体红色字体，"¥" #14 号字体，"￥%.0f" #20 号字体，
/// @param price 商品价格
- (void)netneto_setAttributedTextWithGoodsPrice:(float)price;

/// ¥ %.2f
/// @param price 商品价格
/// @param smallFontSize "¥" 字体大小
/// @param bigFontSize "¥%.0f" 字体大小
- (void)netneto_setAttributedTextWithGoodsPrice:(float)price
                            smallFontOfSize:(CGFloat)smallFontSize
                              bigFontOfSize:(CGFloat)bigFontSize;

/// 合计：¥%.0f
/// 效果："合计："灰色字体，"￥%.0f" 红色字体
/// @param totalPrice 合计金额
- (void)netneto_setAttributedTextWithTotalPrice:(float)totalPrice;

/// 共 n 件商品
/// 效果：商品数量带下划线
/// @param amount 商品数量
- (void)netneto_setAttributedTextWithGoodsAmount:(NSInteger)amount;

@end

NS_ASSUME_NONNULL_END
