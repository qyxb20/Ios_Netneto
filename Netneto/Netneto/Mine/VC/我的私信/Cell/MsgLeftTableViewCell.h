//
//  MsgLeftTableViewCell.h
//  Netneto
//
//  Created by apple on 2025/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgLeftTableViewCell : UITableViewCell
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong)UILabel *contentLabel;//文本
@property(nonatomic, strong)UILabel *timeLabel;//时间
@end

NS_ASSUME_NONNULL_END
