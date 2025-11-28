//
//  ShaiXuanView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/18.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShaiXuanView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, copy) void (^sureBlock) (NSString *timeStr);
@end

NS_ASSUME_NONNULL_END
