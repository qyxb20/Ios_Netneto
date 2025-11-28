//
//  GouponCenterChildViewController.h
//  Netneto
//
//  Created by apple on 2025/1/16.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GouponCenterChildViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property(nonatomic, strong)NSString *titleStr;
@property(nonatomic, strong)NSString *type;
@property(nonatomic, strong)NSString *rootTitleStr;
@property(nonatomic, strong)NSString *searchStr;
@end

NS_ASSUME_NONNULL_END
