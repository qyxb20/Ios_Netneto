//
//  MineOrderItemView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class RefunOrderModel,OrderDetailInfoRefunModel;
@interface MineOrderItemView : BaseView
+ (instancetype)initViewNIB;
@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) RefunOrderModel *refModel;
@property(nonatomic, copy) void (^pushAddComBlock) (OrderModel *model);
@property(nonatomic, copy) void (^refunApplyBlock) (OrderModel *model);
@property (nonatomic, strong) OrderDetailInfoRefunModel *OrderRefModel;
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, assign) BOOL isRe;
@property (weak, nonatomic) IBOutlet UIButton *fanJinBtn;
@property (nonatomic, assign) NSInteger reduceAmount;
@end

NS_ASSUME_NONNULL_END
