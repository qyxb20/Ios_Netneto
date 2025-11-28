//
//  followLiveCollectionViewCell.h
//  Netneto
//
//  Created by apple on 2024/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface followLiveCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *livingLabel;

@end

NS_ASSUME_NONNULL_END
