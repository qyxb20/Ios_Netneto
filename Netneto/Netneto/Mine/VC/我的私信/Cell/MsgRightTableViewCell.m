//
//  MsgRightTableViewCell.m
//  Netneto
//
//  Created by apple on 2025/1/6.
//

#import "MsgRightTableViewCell.h"

@implementation MsgRightTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = RGB_ALPHA(0xC4C4C4, 0.23);
        self.timeLabel.textColor = RGB(0x999999);
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.timeLabel];
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = RGB(0x386AF6);
        [self.contentView addSubview:self.bgView];
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.numberOfLines = 0;
        [self.bgView addSubview:self.contentLabel];
       
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = [Tool getLabelWidthWithText:self.contentLabel.text height:30 font:14];
//    CGFloat w = [self wightForContent:self.contentLabel.attributedText];
    if (w > 280) {
        w = 280;
    }
    CGFloat h = [Tool getLabelHeightWithText:self.contentLabel.text width:272 font:14] + 15;
    CGFloat wt = [Tool getLabelWidthWithText:self.timeLabel.text height:22 font:10] + 15;
    self.timeLabel.frame = CGRectMake((WIDTH - wt) / 2, 10, wt, 22);
    if (self.timeLabel.hidden) {
        self.bgView.frame = CGRectMake( WIDTH - (w + 10) - 16, 10, w + 10, h + 10);
       
    }
    else{
        self.bgView.frame = CGRectMake( WIDTH - (w + 10) - 16, self.timeLabel.bottom + 10, w + 10, h + 10);
       
    }
     
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight| UIRectCornerBottomLeft cornerRadii:CGSizeMake(16,16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    
    self.contentLabel.frame = CGRectMake(5, 5, w, h);
    
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
