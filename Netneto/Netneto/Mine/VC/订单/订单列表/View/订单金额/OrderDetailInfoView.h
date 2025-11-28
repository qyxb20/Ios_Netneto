//
//  OrderDetailInfoView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseView.h"
#import "OrderDetailInfoResaonViewTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailInfoView : BaseView
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)OrderDetailModel *model;
@property (nonatomic, strong)OrderDetailInfoRefunModel *remodel;
@property(nonatomic, strong)NSString *orderNumber;
+ (instancetype)initViewNIB;
@end

NS_ASSUME_NONNULL_END
