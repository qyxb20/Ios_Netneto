//
//  CancelPageTableViewCell.h
//  Netneto
//
//  Created by apple on 2024/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CancelPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *choseBtn;
@property (nonatomic, strong)NSDictionary *dic;
@property(nonatomic, copy) void(^choseItemBlock) (NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
