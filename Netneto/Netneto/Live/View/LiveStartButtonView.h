//
//  LiveStartButtonView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/7.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveStartButtonView : BaseView
@property(nonatomic, copy) void(^startLiveBtnClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
