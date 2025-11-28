//
//  UserApplyTableViewCell.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/11.
//

#import "UserApplyTableViewCell.h"

@implementation UserApplyTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImage = [[UIImageView alloc] init];
        self.bgImage.image = [UIImage imageNamed:@"组合 260"];
        self.bgImage.layer.cornerRadius = 5;
        self.bgImage.clipsToBounds = YES;
        [self.contentView addSubview:self.bgImage];
        self.avatar = [[UIImageView alloc] init];
        self.avatar.layer.cornerRadius = 40.5;
        self.avatar.clipsToBounds = YES;
        self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatar.layer.borderWidth = 5;
        [self.bgImage addSubview:self.avatar];
        
        self.name = [[UILabel alloc] init];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont systemFontOfSize:24];
        [self.bgImage addSubview:self.name];
        
        self.des = [[UILabel alloc] init];
        self.des.textColor = [UIColor whiteColor];
        self.des.font = [UIFont systemFontOfSize:12];
        self.des.numberOfLines = 0;
        [self.bgImage addSubview:self.des];
        
        self.editImage = [[UIImageView alloc] init];
        self.editImage.image = [UIImage imageNamed:@"组合 292"];
        [self.bgImage addSubview:self.editImage];
        
        self.stauseLabel = [[UILabel alloc] init];
        self.stauseLabel.font = [UIFont systemFontOfSize:12];
        self.stauseLabel.textAlignment = NSTextAlignmentCenter;
        self.stauseLabel.backgroundColor = RGB(0xFD9329);
        self.stauseLabel.textColor = [UIColor whiteColor];
        [self.bgImage addSubview:self.stauseLabel];
        
        self.modyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.modyButton.backgroundColor = RGB(0xFCB26D);
        self.modyButton.layer.cornerRadius = 5;
        self.modyButton.clipsToBounds = YES;
        
        
        [self.modyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.modyButton];
        
        self.refLabel = [[UILabel alloc] init];
        self.refLabel.font = [UIFont systemFontOfSize:12];
        self.refLabel.textColor = [UIColor lightGrayColor];
        self.refLabel.numberOfLines = 0;
        [self.contentView addSubview:self.refLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgImage.frame = CGRectMake(16, 16, WIDTH - 32, 145);
    self.avatar.frame = CGRectMake(32, 32, 81, 81);
    self.name.frame = CGRectMake(self.avatar.right+10, 58, WIDTH - 32 - (self.avatar.right+10) - 10, 35);
    CGFloat h = [Tool getLabelHeightWithText:self.des.text width:self.name.width font:12];
    if (h > 50) {
        h = 50;
    }
    self.des.frame = CGRectMake(self.name.left, 62, self.name.width, h);
    
    self.editImage.frame = CGRectMake(self.bgImage.width - 12-26, self.bgImage.height -12-26 , 26, 26);
    CGFloat w = [Tool getLabelWidthWithText:self.stauseLabel.text height:24 font:12];
    
    self.stauseLabel.frame = CGRectMake(WIDTH - 32 - (w +20), 0, w +20, 24);
    [self.stauseLabel addDiagonalNewCornerPath:10];
    self.modyButton.frame = CGRectMake(16, 176, WIDTH - 32, 44);
    CGFloat hj = [Tool getLabelHeightWithText:self.refLabel.text width:WIDTH - 32 font:12];
    self.refLabel.frame = CGRectMake(16, 230, WIDTH - 32, hj);
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
