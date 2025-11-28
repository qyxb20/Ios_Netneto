//
//  MineMsgBottomView.h
//  Netneto
//
//  Created by apple on 2024/12/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineMsgBottomView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, strong)NSDictionary *dic;
@property(nonatomic, strong)NSDictionary *seldic;
@property(nonatomic, copy) void(^closeBlock) (void);//关闭block
@property(nonatomic, copy) void(^sendGoodBlock) (NSDictionary *dic);///发送商品block
@end

NS_ASSUME_NONNULL_END
