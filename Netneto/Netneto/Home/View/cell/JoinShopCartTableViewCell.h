//
//  JoinShopCartTableViewCell.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKTagView;
@interface JoinShopCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet SKTagView *tagView;

@end

NS_ASSUME_NONNULL_END
