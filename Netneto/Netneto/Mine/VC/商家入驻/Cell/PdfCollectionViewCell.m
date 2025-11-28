//
//  PdfCollectionViewCell.m
//  Netneto
//
//  Created by apple on 2025/2/27.
//

#import "PdfCollectionViewCell.h"

@implementation PdfCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIView alloc] init];
      
        [self.contentView addSubview:self.imageV];
  
        self.pic = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pic setImage:[UIImage imageNamed:@"组合 642"] forState:UIControlStateNormal] ;
        [self.imageV addSubview:self.pic];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:8];
        self.titleLabel.textColor =RGB(0x4B4B4B);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.imageV addSubview:self.titleLabel];
        
        
        self.deleteButotn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButotn setBackgroundImage:[UIImage imageNamed:@"组合 254"] forState:UIControlStateNormal];
        [self.imageV addSubview:self.deleteButotn];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageV.frame = CGRectMake(0, 0, 70, 70);
    self.pic.frame = CGRectMake(23, 8, 24, 32);
    self.titleLabel.frame = CGRectMake(5, self.pic.bottom +3, 60, 16);
    self.deleteButotn.frame = CGRectMake(50, -6, 26, 26);
}


@end
