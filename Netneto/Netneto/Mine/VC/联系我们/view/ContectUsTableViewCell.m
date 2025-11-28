//
//  ContectUsTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "ContectUsTableViewCell.h"

@implementation ContectUsTableViewCell
- (void)setModel:(ContectUsModel *)model{
    _model = model;
    NSString *yaoStr = [NSString stringWithFormat:@"%@:%@",TransOutput(@"要件"),[NSString isNullStr:model.topic]];
    NSString *stas;
    if ([model.status isEqual:@"1"]) {
        
        stas = TransOutput(@"审核完成");
        self.delbtn.hidden = YES;
        self.edbtn.hidden = YES;
    }
    else{
        stas = TransOutput(@"审核中");
    }
    NSString *statusStr = [NSString stringWithFormat:@"%@:%@",TransOutput(@"状态"),stas];
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",TransOutput(@"创建时间"),[NSString isNullStr:model.createTime]];
    NSMutableAttributedString *attYao = [[NSMutableAttributedString alloc] initWithString:yaoStr];
    [attYao addAttributes:@{NSForegroundColorAttributeName:RGB(0x0F7CFD)} range:NSMakeRange(0, TransOutput(@"要件").length +1)];
    self.yaojianLabel.attributedText = attYao;
    
    NSMutableAttributedString *staYao = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [staYao addAttributes:@{NSForegroundColorAttributeName:RGB(0x0F7CFD)} range:NSMakeRange(0, TransOutput(@"状态").length +1)];
    self.statusLabel.attributedText = staYao;
    
    NSMutableAttributedString *timeYao = [[NSMutableAttributedString alloc] initWithString:timeStr];
    [timeYao addAttributes:@{NSForegroundColorAttributeName:RGB(0x0F7CFD)} range:NSMakeRange(0, TransOutput(@"创建时间").length +1)];
    self.createLabel.attributedText = timeYao;
   
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
