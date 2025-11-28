//
//  OrderquanTableViewCell.m
//  Netneto
//
//  Created by apple on 2025/2/5.
//

#import "OrderquanTableViewCell.h"

@implementation OrderquanTableViewCell
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.induceView.layer.borderColor = RGB(0xDEDCDC).CGColor;
    self.induceView.layer.borderWidth = 0.5;
    // Initialization code
}
- (IBAction)moreTasdkInfo:(id)sender {
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

-(void)openCell:(BOOL)open
{
    if (open) {

        _induceView.hidden = NO;
    }else{

        _induceView.hidden = YES;
        
    }
    _opened = open;
}
- (IBAction)choseClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
    }else{
        sender.selected = NO;
    }
    ExecBlock(self.addQuanBlock,self.dic);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
