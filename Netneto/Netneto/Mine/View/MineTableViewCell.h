//
//  MineTableViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ima;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

NS_ASSUME_NONNULL_END
