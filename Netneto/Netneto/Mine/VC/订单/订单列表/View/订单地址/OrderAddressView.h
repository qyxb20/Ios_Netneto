//
//  OrderAddressView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class OrderDetailInfoRefunModel;
@interface OrderAddressView : BaseView
@property (nonatomic, strong) OrderDetailInfoRefunModel *remodel;
@property (nonatomic, strong) OrderDetailModel *detailmodel;
@property (nonatomic, strong) addressModel *addrmodel;
@property (weak, nonatomic) IBOutlet UIButton *addAdsBtn;
@property(nonatomic, copy) void (^checkWuBlock)(void);
+ (instancetype)initViewNIB;
@end

NS_ASSUME_NONNULL_END
