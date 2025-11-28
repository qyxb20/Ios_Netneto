//
//  UserApplyTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserApplyTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *bgImage;
@property (nonatomic, strong)UIImageView *avatar;
@property (nonatomic, strong)UILabel *name;
@property (nonatomic, strong)UILabel *des;
@property (nonatomic, strong)UIImageView *editImage;
@property (nonatomic, strong)UILabel *stauseLabel;
@property (nonatomic, strong)UIButton *modyButton;
@property (nonatomic, strong)UILabel *refLabel;
@end

NS_ASSUME_NONNULL_END
