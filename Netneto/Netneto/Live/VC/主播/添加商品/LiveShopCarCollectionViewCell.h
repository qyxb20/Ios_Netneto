//
//  LiveShopCarCollectionViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveShopCarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oripriceLabel;

@end

NS_ASSUME_NONNULL_END
