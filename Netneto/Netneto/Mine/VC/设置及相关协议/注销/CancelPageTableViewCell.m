//
//  CancelPageTableViewCell.m
//  Netneto
//
//  Created by apple on 2024/12/19.
//

#import "CancelPageTableViewCell.h"

@implementation CancelPageTableViewCell
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
}

- (IBAction)choseBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
    }else{
        sender.selected = NO;
    }
    ExecBlock(self.choseItemBlock,self.dic);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
