//
//  LiveMainChildViewController.h
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveMainChildViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, strong) NSString *CategoryId;
@end

NS_ASSUME_NONNULL_END
