//
//  ClassContentTopCollectionViewCell.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "ClassContentTopCollectionViewCell.h"
@interface ClassContentTopCollectionViewCell ()

/** 图片 */
@property (nonatomic, strong) UIImageView *topImageView;
/** 数据模型 */
@property (nonatomic, strong) ClassNameModel *topBlockModel;


@end
@implementation ClassContentTopCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChildView];
    }
    return self;
}


#pragma mark - UI
- (void)setChildView{
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(0);
    }];
    
}


#pragma mark - Model
- (void)setTopModel:(ClassNameModel *)topModel{
//    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:topModel.pic]]];
    self.topBlockModel = topModel;
}


#pragma mark - 手势事件
- (void)imageTapAction{
    
    if (self.itemBlock) {
        self.itemBlock(self.topBlockModel);
    }
}

#pragma mark - lazy
- (UIImageView *)topImageView{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_store_allGoods"]];
        _topImageView.userInteractionEnabled = YES;
        
        /** 手势 */
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction)];
        [_topImageView addGestureRecognizer:imageTap];
    }
    return _topImageView;
}









@end
