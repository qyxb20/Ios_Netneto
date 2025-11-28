//
//  askAndQuestionTableViewCell.h
//  Netneto
//
//  Created by apple on 2025/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface askAndQuestionTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *qImage;
@property (nonatomic,strong) UILabel *qLabel;
@property (nonatomic,strong) UIImageView *aImage;
@property (nonatomic,strong) UILabel *aLabel;
@property (nonatomic,strong) UILabel *line;
@end

NS_ASSUME_NONNULL_END
