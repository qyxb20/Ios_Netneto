//
//  MineOrderChildTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineOrderChildTableViewCell : UITableViewCell
@property (nonatomic, strong) OrderModel *model;
@property(nonatomic, copy) void(^pushComAddBlock) (OrderModel *model);
@property(nonatomic, copy) void(^applyTuiBlock) (OrderModel *model);
@property(nonatomic, strong) UIButton *fanJinBtn;

@end

NS_ASSUME_NONNULL_END
