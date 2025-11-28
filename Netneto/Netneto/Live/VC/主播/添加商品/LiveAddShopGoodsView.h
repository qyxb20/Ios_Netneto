//
//  LiveAddShopGoodsView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveAddShopGoodsView : BaseView
@property(nonatomic, strong)NSString *channel;
+ (instancetype)initViewNIB;
-(void)updataData;
@end

NS_ASSUME_NONNULL_END
