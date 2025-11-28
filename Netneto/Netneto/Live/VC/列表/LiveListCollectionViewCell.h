//
//  LiveListCollectionViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *onlineNum;
//prductView
//product
@property (strong, nonatomic)  UIView *shopView;
@property (strong, nonatomic)  UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *notice;
@property (nonatomic, strong)NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
