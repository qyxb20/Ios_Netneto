//
//  MineMessageTableViewCell.m
//  Netneto
//
//  Created by apple on 2024/12/23.
//

#import "MineMessageTableViewCell.h"

@implementation MineMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setDealDeleteButtonAndClassButton];
}
- (void)setDealDeleteButtonAndClassButton{
    
    if (CYL_IS_IOS_11)
    {
       
        for (UIView *subview in self.superview.subviews)
        {
            
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                NSLog(@"输出视图：%@",subview.subviews);
                
                UIButton *deleteButton = subview.subviews[0];
                [deleteButton setImage:[UIImage imageNamed:@"elements"] forState:(UIControlStateNormal)];
                [deleteButton setTitle:@"" forState:UIControlStateNormal];
                deleteButton.backgroundColor = RGB_ALPHA(0xFF6979,0.2);

            }
        }
    } else {
       
        for (UIView *subview in self.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                
                    UIButton *deleteButton = subview.subviews[0];
                    [deleteButton setImage:[UIImage imageNamed:@"elements"] forState:(UIControlStateNormal)];
                    [deleteButton setTitle:@"" forState:UIControlStateNormal];
                deleteButton.backgroundColor = RGB_ALPHA(0xFF6979,0.2);
        
            }
        }
    }
}

@end
