//
//  addManagerListView.h
//  Netneto
//
//  Created by apple on 2024/10/15.
//

#import "BaseView.h"
#import "addManagerListViewTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface addManagerListView : BaseView
+ (instancetype)initViewNIB;
-(void)loadData;
@property (nonatomic, strong)NSString *shopId;
@property(nonatomic, copy) void(^setManagerBlock) (NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
