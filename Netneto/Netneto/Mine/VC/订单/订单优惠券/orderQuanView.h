//
//  orderQuanView.h
//  Netneto
//
//  Created by apple on 2025/2/5.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface orderQuanView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, strong)NSString  *selCouponId;

@property(nonatomic, copy) void(^sureBlock) (NSArray *couponIdArr);
@end

NS_ASSUME_NONNULL_END
