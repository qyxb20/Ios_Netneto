//
//  ContectUsTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContectUsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *yaojianLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;

@property (weak, nonatomic) IBOutlet UIButton *edbtn;
@property (weak, nonatomic) IBOutlet UIButton *delbtn;

@property (nonatomic, strong) ContectUsModel *model;
@end

NS_ASSUME_NONNULL_END
