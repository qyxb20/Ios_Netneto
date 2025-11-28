//
//  PaymentView.h
//  Netneto
//
//  Created by apple on 2024/10/16.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, copy) void(^nextBlock) (void);
@property(nonatomic, copy) void(^cancelPayBlock) (void);
@end

NS_ASSUME_NONNULL_END
