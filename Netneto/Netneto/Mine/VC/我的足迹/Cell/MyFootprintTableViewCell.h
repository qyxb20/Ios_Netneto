//
//  MyFootprintTableViewCell.h
//  Netneto
//
//  Created by apple on 2024/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyFootprintTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;///时间
@property (weak, nonatomic) IBOutlet UIImageView *pic;///图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;///名称
@property (weak, nonatomic) IBOutlet UILabel *numLabel;///数量
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;///价格

@end

NS_ASSUME_NONNULL_END
