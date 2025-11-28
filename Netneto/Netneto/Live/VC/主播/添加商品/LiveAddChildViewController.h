//
//  LiveAddChildViewController.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveAddChildViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property(nonatomic, strong)NSDictionary *dic;
@property(nonatomic, strong)NSString *channel;
@property(nonatomic, copy) void(^addGoodsBlock) (NSDictionary *dic,NSString *shopId);
@end

NS_ASSUME_NONNULL_END
