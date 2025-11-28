//
//  AddChildTableViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "AddChildTableViewCell.h"

@implementation AddChildTableViewCell
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    
}
- (IBAction)choseClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
    }else{
        sender.selected = NO;
    }
    ExecBlock(self.addShopGoodsBlock,self.dic);
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
