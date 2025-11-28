//
//  GoodDetailCommentTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GoodCommentModel;
@interface GoodDetailCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *positiveRating;
@property (nonatomic, strong) GoodCommentModel *model;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (nonatomic, copy) void (^imgClickBlock) (NSInteger index,UIView *tapView);

@end

NS_ASSUME_NONNULL_END
