//
//  AddCollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/30.
//

#import "AddCollectionViewCell.h"

@implementation AddCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.addImageV];
        
        
    }
    return self;
}

- (UIButton *)addImageV{
    if (!_addImageV) {
        self.addImageV =[UIButton buttonWithType:UIButtonTypeCustom];
        self.addImageV.frame = self.bounds;
        
            _addImageV.backgroundColor = RGB(0xF6FAFE);
            _addImageV.layer.borderColor = RGB(0xA3CCF9).CGColor;
            _addImageV.layer.borderWidth = 0.5;
            _addImageV.titleLabel.font = [UIFont systemFontOfSize:12];
            [_addImageV setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
            _addImageV.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _addImageV.userInteractionEnabled =NO;
         
    }
    return _addImageV;
}
@end
