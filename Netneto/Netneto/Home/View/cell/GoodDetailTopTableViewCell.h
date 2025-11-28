//
//  GoodDetailTopTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodDetailTopTableViewCell : UITableViewCell
@property (nonatomic, strong) GoodDetailModel *model;
@property (nonatomic, copy) void (^skuItemClickBlock) (NSDictionary *skuDic);
@property (nonatomic, copy) void (^shopClickBlock) (NSString *shopId);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updataHeight;
@property (nonatomic, copy) void (^showCounponViewClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
