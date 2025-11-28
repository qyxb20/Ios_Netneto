//
//  shopUserApplyTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shopUserApplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusLabel;

@end

NS_ASSUME_NONNULL_END
