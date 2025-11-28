//
//  ChatTableViewCell.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) MessageModel *model;
@property (nonatomic, strong) NSString *zhuboID;
@end

NS_ASSUME_NONNULL_END
