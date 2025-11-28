//
//  addManagerListViewTableViewCell.h
//  Netneto
//
//  Created by apple on 2024/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface addManagerListViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

NS_ASSUME_NONNULL_END
