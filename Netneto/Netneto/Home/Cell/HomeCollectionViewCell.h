//
//  HomeCollectionViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oriPrice;

@property (strong, nonatomic)  UIView *shopView;
@property (strong, nonatomic)  UILabel *shopName;
@property (nonatomic, strong) NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
