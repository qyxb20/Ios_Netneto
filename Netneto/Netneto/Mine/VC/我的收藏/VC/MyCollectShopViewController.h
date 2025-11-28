//
//  MyCollectShopViewController.h
//  Netneto
//
//  Created by apple on 2024/10/24.
//

#import "BaseViewController.h"
#import "MyCollectShopTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyCollectShopViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, strong)NSString *searchCount;
@end

NS_ASSUME_NONNULL_END
