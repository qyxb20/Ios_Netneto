//
//  OrderDetailInfoFootView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailInfoFootView : BaseView
@property(nonatomic, strong)NSString *status;
@property (nonatomic, strong)OrderDetailModel *model;
@property (nonatomic, strong)OrderDetailInfoRefunModel *remodel;
@property (nonatomic, copy) void (^btnClickBlock) (void);
@property (nonatomic, copy) void (^surePayClickBlock) (void);
@property (nonatomic, copy) void (^cancelPayClickBlock) (void);
@property (nonatomic, copy) void (^sureRevClickBlock) (void);
@property (nonatomic, copy) void (^checkWuClickBlock) (void);
@property (nonatomic, copy) void (^cancelApplyClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
