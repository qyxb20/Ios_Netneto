//
//  OrderquanTableViewCell.h
//  Netneto
//
//  Created by apple on 2025/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderquanTableViewCell : UITableViewCell
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

@property(nonatomic, copy) void(^moreInfo) (BOOL open);
@property(nonatomic, assign)BOOL opened;
-(void)openCell:(BOOL)open;
@property (nonatomic, strong)NSDictionary *dic;
@property(nonatomic, copy) void(^addQuanBlock) (NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
