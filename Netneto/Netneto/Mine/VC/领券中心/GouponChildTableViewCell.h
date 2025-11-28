//
//  GouponChildTableViewCell.h
//  Netneto
//
//  Created by apple on 2025/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GouponChildTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *induceView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *indureBtn;
@property (weak, nonatomic) IBOutlet UIButton *lingBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *resonBtn;

@property(nonatomic, copy) void(^moreInfo) (BOOL open);
@property(nonatomic, copy) void(^moreInfoReson) (BOOL open);
@property(nonatomic, assign)BOOL opened;
@property(nonatomic, assign)BOOL openedReson;
-(void)openCell:(BOOL)open;
-(void)openCellReson:(BOOL)open;
@end

NS_ASSUME_NONNULL_END
