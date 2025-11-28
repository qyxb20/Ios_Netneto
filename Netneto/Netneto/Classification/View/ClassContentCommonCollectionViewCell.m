//
//  ClassContentCommonCollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "ClassContentCommonCollectionViewCell.h"
@interface ClassContentCommonCollectionViewCell ()

/** 图片 */
@property (nonatomic, strong) UIImageView *topImageView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;


@end
@implementation ClassContentCommonCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

#pragma mark - UI
- (void)createView{
    [self addSubview:self.topImageView];
    [self addSubview:self.nameLabel];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.width.equalTo(@(([UIScreen mainScreen].bounds.size.width *0.7 - 4*10)*0.33));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_bottom).offset(5);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
    }];
    
}


#pragma mark - Model
- (void)setModel:(ClassContentModel *)model{
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:model.pic]] placeholderImage:[UIImage imageNamed:@"tupian"]];
    self.nameLabel.text = [NSString isNullStr:model.categoryName];
    
}


#pragma mark - lazy
- (UIImageView *)topImageView{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_store_allGoods"]];
    }
    return _topImageView;
}

- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
      
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}



@end
