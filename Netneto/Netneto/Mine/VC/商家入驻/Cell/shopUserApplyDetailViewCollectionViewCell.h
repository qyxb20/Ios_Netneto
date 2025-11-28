//
//  shopUserApplyDetailViewCollectionViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface shopUserApplyDetailViewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ima;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;///上架、下架
@property (weak, nonatomic) IBOutlet UIButton *editBtn;//编辑
@property (weak, nonatomic) IBOutlet UIView *prductView;

@end

NS_ASSUME_NONNULL_END
