//
//  MsgLinkRightTableViewCell.h
//  Netneto
//
//  Created by apple on 2025/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgLinkRightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *pic;///图片
@property (weak, nonatomic) IBOutlet UILabel *name;///名称
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;///价格
@property (weak, nonatomic) IBOutlet UILabel *skuNameLabel;///规格名

@end

NS_ASSUME_NONNULL_END
