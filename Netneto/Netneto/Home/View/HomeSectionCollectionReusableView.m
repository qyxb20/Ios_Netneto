//
//  HomeSectionCollectionReusableView.m
//  Netneto
//
//  Created by apple on 2024/11/22.
//

#import "HomeSectionCollectionReusableView.h"

@implementation HomeSectionCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
      self.labelHot = [[UILabel alloc] init];
      self.labelHot.font = [UIFont boldSystemFontOfSize:20];
      self.labelHot.textColor = RGB(0x4B4B4B);
      [self addSubview:self.labelHot];
      
        self.moreBtnHot = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreBtnHot setTitle:TransOutput(@"更多") forState:UIControlStateNormal];
        [self.moreBtnHot.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size:14]];
        [self.moreBtnHot setTitleColor:RGB(0x8D8B8B) forState:UIControlStateNormal];
      
        [self addSubview:self.moreBtnHot];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.labelHot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_offset(13);
        make.height.mas_offset(26);
        
    }];
    [self.moreBtnHot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-20);
        make.top.mas_offset(13);
        make.height.mas_offset(26);
    }];
}
@end
