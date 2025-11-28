//
//  AddChildTableViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddChildTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (nonatomic, strong)NSDictionary *dic;
@property(nonatomic, copy) void(^addShopGoodsBlock) (NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
