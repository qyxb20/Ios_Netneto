//
//  MineOrderChildViewController.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineOrderChildViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)NSString *timeRange;
@end

NS_ASSUME_NONNULL_END
