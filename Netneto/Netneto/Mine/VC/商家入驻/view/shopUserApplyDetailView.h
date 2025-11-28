//
//  shopUserApplyDetailView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface shopUserApplyDetailView : BaseView
@property(nonatomic, strong)NSDictionary *dataDic;
@property(nonatomic, copy) void (^addGoodsBlock) (void);//添加
@property(nonatomic, copy) void (^modyShopInfoBlock) (void);///修改
@property(nonatomic, copy) void (^intrBlock) (NSString *info);
@end

NS_ASSUME_NONNULL_END
