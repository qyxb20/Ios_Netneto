//
//  mecharnAddressView.h
//  Netneto
//
//  Created by apple on 2025/2/28.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface mecharnAddressView : BaseView
@property (nonatomic, strong) OrderDetailInfoRefunModel *remodel;
+ (instancetype)initViewNIB;
@end

NS_ASSUME_NONNULL_END
