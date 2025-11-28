//
//  HomeOneCollectionViewCell.m
//  Netneto
//
//  Created by apple on 2024/11/22.
//

#import "HomeOneCollectionViewCell.h"
@interface HomeOneCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic, strong)UICollectionView *collectionView;

@end
@implementation HomeOneCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(0xEEF7FE);
        self.contentView.backgroundColor = RGB(0xEEF7FE);
        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_offset(0);
        }];
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     
    HomeHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeHeaderCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
    cell.titleLabel.text = [NSString isNullStr:dic[@"prodName"]];
    cell.titleLabel.font = [UIFont systemFontOfSize:14];
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    ExecBlock(self.cellItemClickBlock,dic);
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(148,172);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeHeaderCollectionViewCell"];
   
       
    }
    return _collectionView;
}
@end
