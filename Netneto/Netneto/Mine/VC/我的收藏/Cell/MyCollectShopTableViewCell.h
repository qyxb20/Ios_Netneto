//
//  MyCollectShopTableViewCell.h
//  Netneto
//
//  Created by apple on 2024/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopLogo;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *sellNum;
@property (weak, nonatomic) IBOutlet UIButton *joinShopBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodOne;
@property (weak, nonatomic) IBOutlet UIButton *goodTwo;
@property (weak, nonatomic) IBOutlet UIButton *goodThree;
@property (weak, nonatomic) IBOutlet UIButton *goodFour;

@end

NS_ASSUME_NONNULL_END
