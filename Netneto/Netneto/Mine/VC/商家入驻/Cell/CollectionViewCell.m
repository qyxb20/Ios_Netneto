//
//  CollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/30.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageV];
  
        
    }
    return self;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        self.imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}

- (UIButton *)deleteButotn{
    if (!_deleteButotn) {
        self.deleteButotn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButotn.frame = CGRectMake(50, -6, 26, 26);
        [_deleteButotn setBackgroundImage:[UIImage imageNamed:@"组合 254"] forState:UIControlStateNormal];
    }
    return _deleteButotn;
}

@end
