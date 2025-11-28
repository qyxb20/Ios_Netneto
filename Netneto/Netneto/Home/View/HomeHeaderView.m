//
//  HomeHeaderView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "HomeHeaderView.h"
@interface HomeHeaderView ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UILabel *labelEvery;
    NotiTurnView *turnView;
}
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *giftView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)UIImageView *notiBgView;
@property(nonatomic, strong)NSMutableArray *bannerArray;
@property(nonatomic, strong)NSMutableArray *bannerDataArray;
@property(nonatomic, strong)NSString *idStr;
@end
@implementation HomeHeaderView
-(void)initData{
    self.bannerArray = [NSMutableArray array];
}
-(void)CreateView{
    [self addSubview:self.bgHeaderView];
    [self.bgHeaderView addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.banner];
    [self addSubview:self.giftView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
//        if ([[Tool getCurrentSeason] isEqual:@"Autumn"]) {
//            make.height.mas_offset(304);
//        }
//       else if ([[Tool getCurrentSeason] isEqual:@"Winter"]) {
//           
//           make.height.mas_offset(310 * WIDTH / 750);
//        }
//       else{
           make.height.mas_offset(155);
//       }
    }];
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-6);
        make.top.mas_offset(22);
        make.width.mas_offset(147);
        make.height.mas_offset(113);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(50);
        make.leading.mas_offset(25);
        make.trailing.mas_offset(-25);
        make.height.mas_offset(37);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.top.mas_offset(9.23);
        make.width.height.mas_offset(17);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.SearchImageView.mas_trailing).offset(10);
        make.trailing.mas_offset(-10);
        make.top.mas_offset(8);
        make.height.mas_offset(20);
    }];
    [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(125 + 18);
    }];
    
    NSArray *buttonArr = @[@{@"img":[NSString stringWithFormat:@"%@-xin",[Tool getCurrentSeason]],@"title":TransOutput(@"新品推荐")},
                           @{@"img":[NSString stringWithFormat:@"%@-xian",[Tool getCurrentSeason]],@"title":TransOutput(@"限时优惠")},
                           @{@"img":[NSString stringWithFormat:@"%@-mei",[Tool getCurrentSeason]],@"title":TransOutput(@"每日疯抢")},
                           @{@"img":[NSString stringWithFormat:@"%@-ling",[Tool getCurrentSeason]],@"title":TransOutput(@"领优惠券")}];
    CGFloat space = (WIDTH - 44 - 240) / 3;
    for (int i = 0; i <buttonArr.count; i++) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(22 + (60 + space) * i, 16 + 143 + 19, 60 , 89)];
        vi.tag = i;
        [vi addTapAction:^(UIView * _Nonnull view) {
            ExecBlock(self.btnItemClickBlock,buttonArr[i][@"title"]);
        }];
        [self.headerView addSubview: vi];
        
        UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60 , 60)];
        button.image =[UIImage imageNamed:buttonArr[i][@"img"]];
        button.contentMode = UIViewContentModeScaleAspectFit;
        button.userInteractionEnabled = YES;
        [vi addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 39)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.numberOfLines = 2;
        titleLabel.text = buttonArr[i][@"title"];
        [vi addSubview:titleLabel];
        
     
    }
    [self.notiBgView removeFromSuperview];
    [self addSubview:self.notiBgView];
    [self.notiBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.top.mas_equalTo(self.banner.mas_bottom).offset(126);
        make.height.mas_offset(76);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = TransOutput(@"平台通知");
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Source Han Sans SC" size:14];
    [self.notiBgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.top.mas_offset(7);
        make.height.mas_offset(20);
    }];
    
    turnView = [[NotiTurnView alloc] initWithFrame:CGRectMake(0, 36, WIDTH - 32, 40)];
    [turnView addBottomCornerPath:5];
    turnView.backgroundColor = RGB_ALPHA(0xFFFFFF, 0.7);
    
    [self.notiBgView addSubview:turnView];
    
    UIButton *push = [UIButton buttonWithType:UIButtonTypeCustom];
    push.frame = CGRectMake(WIDTH - 32 - 19 , 36, 5, 40);
    [push setImage:[UIImage imageNamed:@"path 2"] forState:UIControlStateNormal];
    [self.notiBgView addSubview:push];
    
 
   
 
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.bannerDataArray.count > 0) {
        ExecBlock(self.bannerItemClickBlock,self.bannerDataArray[index]);
      
    }
    
}

-(void)GetData{
    self.bannerArray = [NSMutableArray array];
    self.bannerDataArray = [NSMutableArray array];
    [NetwortTool getHomeBannerSuccess:^(id  _Nonnull responseObject) {
        NSLog(@"首页banner数据:%@",responseObject);
        
        NSArray *arr = responseObject;
        for (int i = 0; i< arr.count; i++ ) {
            [self.bannerArray addObject:[NSString isNullStr:arr[i][@"imgUrl"]]];
            [self.bannerDataArray addObject:arr[i]];
        }
        
        self.banner.imageURLStringsGroup = self.bannerArray;
        
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    
    [NetwortTool getHomeNotificationSuccess:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject;
        
        self->turnView.turnArray =arr;
        
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    [NetwortTool getHomeAllGoodsSuccess:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject;
        self.dataArr =arr.firstObject[@"productDtoList"];
        self->labelEvery.text =[NSString isNullStr:arr.firstObject[@"title"]];
        self.idStr =arr.firstObject[@"id"];
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
  
    
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
#pragma mark - lazy
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
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.contentMode = UIViewContentModeScaleToFill;
        _bgHeaderView.image = [UIImage imageNamed:[Tool getCurrentSeason]];
        
    }
    return _bgHeaderView;
}
-(UIImageView *)notiBgView{
    if (!_notiBgView) {
        _notiBgView = [[UIImageView alloc] init];
        _notiBgView.userInteractionEnabled = YES;
        _notiBgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-n",[Tool getCurrentSeason]]];
        _notiBgView.layer.cornerRadius = 7;
        _notiBgView.contentMode = UIViewContentModeScaleToFill;
        _notiBgView.clipsToBounds = YES;
        _notiBgView.userInteractionEnabled = YES;
        @weakify(self);
        [_notiBgView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.notifiClickBlock);
            
        }];
        
    }
    return _notiBgView;
}
-(UIImageView *)giftView{
    if (!_giftView) {
        _giftView = [[UIImageView alloc] init];
        _giftView.userInteractionEnabled = NO;
        _giftView.image = [UIImage imageNamed:@""];
        
    }
    return _giftView;

    
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, WIDTH, 380)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addTopCornerPath:10];
    }
    return _headerView;
}
-(SDCycleScrollView *)banner{
    if (!_banner) {
        _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _banner.backgroundColor = [UIColor clearColor];
        _banner.layer.masksToBounds = YES;
        
        _banner.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _banner.autoScrollTimeInterval = 3.0f;
        _banner.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _banner.showPageControl = YES;
        _banner.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
       
        
    }
    return _banner;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 18.5;
        _searchView.clipsToBounds = YES;
        _searchView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xFFFFFF),RGB(0xFFFFFF)] withWidth:WIDTH - 50];
        @weakify(self)
        [_searchView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            ExecBlock(self.searchClickBlock);
                }];
    }
    return _searchView;
}
-(UIImageView *)SearchImageView{
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = YES;
    }
    return _SearchImageView;;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = NO;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.text = TransOutput(@"搜索");
    }
    return _searchTF;
}
@end
