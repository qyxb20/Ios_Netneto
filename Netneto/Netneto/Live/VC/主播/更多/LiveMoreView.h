//
//  LiveMoreView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveMoreView : BaseView
+ (instancetype)initViewNIB;
@property (nonatomic, assign) BOOL isActor;
@property(nonatomic, copy) void(^changeCamerClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
