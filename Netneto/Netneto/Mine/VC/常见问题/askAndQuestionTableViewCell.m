//
//  askAndQuestionTableViewCell.m
//  Netneto
//
//  Created by apple on 2025/3/14.
//

#import "askAndQuestionTableViewCell.h"

@implementation askAndQuestionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = RGB(0xF9F9F9);
        [self.contentView addSubview:self.bgView];
        self.qImage = [[UIImageView alloc] init];
        self.qImage.image = [UIImage imageNamed:@"组合 461-2"];
        [self.bgView addSubview:self.qImage];
        self.qLabel = [[UILabel alloc] init];
        self.qLabel.font = [UIFont systemFontOfSize:14];
        self.qLabel.textColor = RGB(0x1A1A1A);
        self.qLabel.numberOfLines = 0;
        [self.bgView addSubview:self.qLabel];
        
        self.aImage = [[UIImageView alloc] init];
        self.aImage.image = [UIImage imageNamed:@"组合 470-2"];
        [self.bgView addSubview:self.aImage];
        self.aLabel = [[UILabel alloc] init];
        self.aLabel.font = [UIFont systemFontOfSize:12];
        self.aLabel.textColor = RGB(0x717272);
        self.aLabel.numberOfLines = 0;
        [self.bgView addSubview:self.aLabel];
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = RGB(0xEAE9E9);
        [self.bgView addSubview:self.line];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat qH = [Tool getLabelHeightWithText:self.qLabel.text width:WIDTH - 59 font:14];
    if (qH < 16) {
        qH = 16;
    }
    CGFloat aH = [Tool getLabelHeightWithText:self.aLabel.text width:WIDTH - 59 font:12];
    if (aH < 16) {
        aH = 16;
    }
    CGFloat bgH = 14 + qH + 6 + aH + 14;
    self.bgView.frame = CGRectMake(14, 0, WIDTH - 28, bgH);
    
    self.qImage.frame = CGRectMake(9, 15, 14, 14);
    self.qLabel.frame = CGRectMake(32, 14, WIDTH - 59, qH);
    
    self.aImage.frame = CGRectMake(9, self.qLabel.bottom + 8, 14, 14);
    self.aLabel.frame = CGRectMake(32, self.qLabel.bottom + 6, WIDTH - 59, aH);
    
    self.line.frame = CGRectMake(9, self.aLabel.bottom + 13, WIDTH - 28 - 18, 0.5);
    
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
