//
//  GouponChildTableViewCell.m
//  Netneto
//
//  Created by apple on 2025/1/17.
//

#import "GouponChildTableViewCell.h"

@implementation GouponChildTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.induceView.layer.borderColor = RGB(0xDEDCDC).CGColor;
    self.induceView.layer.borderWidth = 0.5;
    // Initialization code
}
- (IBAction)moreTasdkInfo:(id)sender {
    _openedReson = NO;
   
    if (_opened) {
           //已经打开就关闭
           [self openCell:NO];
       
       }else{
           //打开
           [self openCell:YES];
       }
       
       if (self.moreInfo) {
           self.moreInfo(_opened);
       }

  
}
- (IBAction)resonClick:(UIButton *)sender {
    _opened = NO;
   
    if (_openedReson) {
           //已经打开就关闭
        
           [self openCellReson:NO];
       
       }else{
           //打开
           
           [self openCellReson:YES];
       }
       
    if (self.moreInfoReson) {
           self.moreInfoReson(_openedReson);
       }

}
-(void)openCellReson:(BOOL)open
{
    if (open) {

        _induceView.hidden = NO;
    }else{

        _induceView.hidden = YES;
        
    }
    _openedReson = open;
}

-(void)openCell:(BOOL)open
{
    if (open) {

        _induceView.hidden = NO;
    }else{

        _induceView.hidden = YES;
        
    }
    _opened = open;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
