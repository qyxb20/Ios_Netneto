//
//  HomeShopViewControll.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "HomeShopViewControll.h"

@interface HomeShopViewControll ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UIImageView *avatar;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *desLabel;
@property(nonatomic, strong)UIView *topBgView;
@property(nonatomic, strong)NSDictionary *dataDic;
@property(nonatomic, strong)UIButton *moBtn;
@property(nonatomic, strong)UIButton *xiaoBtn;
@property(nonatomic, strong)UIButton *xinBtn;
@property(nonatomic, strong)UIButton *priceBtn;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)BOOL isPriceSel;
@property(nonatomic, strong)NSString *direction;
@property(nonatomic, strong)NSString *sortType;
@property (nonatomic, assign) NSInteger isCollec;
@property (nonatomic, strong)UIButton *modyButton;
@property (nonatomic, strong)NSString *into;
@end

@implementation HomeShopViewControll

-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
     UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    
    [self getIsColl];
    
    self.page = 1;
    self.direction = @"0";
    self.dataArr = [NSMutableArray array];
    self.sortType = @"0";
    [self loadData:self.sortType];
}
#pragma mark - 获取是否收藏
-(void)getIsColl{
    if (!account.isLogin) {
        UIImage *rightImage = [UIImage imageNamed:@"like"] ;
        UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
          [leftButtonView addSubview:returnBtn];
          [returnBtn setImage:rightImage forState:UIControlStateNormal];
          [returnBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
       UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
        self.navigationItem.rightBarButtonItem = leftCunstomButtonView;
       
    }else{
        [NetwortTool getIsCollectionShopWithParm:@{@"shopId":self.shopId} Success:^(id  _Nonnull responseObject) {
            
            UIImage *rightImage = [UIImage imageNamed:@"like"] ;
            UIImage *rightImageS = [UIImage imageNamed:@"yishoucang"] ;
            
            self.isCollec = [responseObject intValue];
            if ([responseObject intValue] == 1) {
                
                UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [leftButtonView addSubview:returnBtn];
                [returnBtn setImage:rightImageS forState:UIControlStateNormal];
                [returnBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
                self.navigationItem.rightBarButtonItem = leftCunstomButtonView;
                
                
                
            }else{
                
                UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                [leftButtonView addSubview:returnBtn];
                [returnBtn setImage:rightImage forState:UIControlStateNormal];
                [returnBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
                self.navigationItem.rightBarButtonItem = leftCunstomButtonView;
                
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
}
#pragma mark - 收藏&取消收藏
-(void)collectClick{
    if (account.isLogin) {
        [NetwortTool getAddOrCancelShopWithParm:@{@"shopId":self.shopId} Success:^(id  _Nonnull responseObject) {
            if (self.isCollec == 1) {
                ToastShow(TransOutput(@"取消收藏成功"), @"chenggong",RGB(0x36D053));
            }
            else{
                ToastShow(TransOutput(@"收藏成功"), @"chenggong",RGB(0x36D053));
            }
            [self getIsColl];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCollec" object:nil userInfo:nil];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self pushController:vc];
    }
}
-(void)CreateView{
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView addSubview:self.avatar];
    [self.bgHeaderView addSubview:self.nameLabel];

    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.collectionView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(198);
    }];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(86);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(35);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.bottom.mas_offset(0);
        make.top.mas_equalTo(self.topBgView.mas_bottom).mas_offset(16);
        
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(50);
        make.top.mas_offset(94);
        make.width.height.mas_offset(81);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatar.mas_trailing).offset(20);
        make.trailing.mas_offset(-16);
        make.top.mas_offset(117);
    }];

    
    self.modyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.modyButton.backgroundColor = RGB(0x0F7CFD);
    self.modyButton.frame = CGRectMake(16, 198 +23 , WIDTH - 32, 40);
    self.modyButton.layer.cornerRadius = 5;
    self.modyButton.clipsToBounds = YES;
    
    [self.modyButton setTitle:TransOutput(@"店铺简介") forState:UIControlStateNormal];
    [self.modyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.modyButton];
    @weakify(self);
    [self.modyButton addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        shopindructViewController *vc = [[shopindructViewController alloc] init];
        vc.into = self.into;
        [self pushController:vc];
    }];
    CGFloat btnWidth = (WIDTH - 32)/ 4;
    self.moBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moBtn.frame = CGRectMake(0, 0, btnWidth, 35);
    [self.moBtn setTitle:TransOutput(@"默认") forState:UIControlStateNormal];
    [self.moBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    [self.moBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateSelected];
    self.moBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.moBtn addTarget:self action:@selector(moBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.moBtn];
    self.moBtn.selected = YES;
    
    self.xiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xiaoBtn.frame = CGRectMake(btnWidth, 0, btnWidth, 35);
    [self.xiaoBtn setTitle:TransOutput(@"销量") forState:UIControlStateNormal];
    [self.xiaoBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    [self.xiaoBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateSelected];
    self.xiaoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xiaoBtn addTarget:self action:@selector(xiaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.xiaoBtn];

    
    self.xinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xinBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, 35);
    [self.xinBtn setTitle:TransOutput(@"上新") forState:UIControlStateNormal];
    [self.xinBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    [self.xinBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateSelected];
    self.xinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xinBtn addTarget:self action:@selector(xinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.xinBtn];

    self.priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceBtn.frame = CGRectMake(btnWidth * 3, 0, btnWidth, 35);
    [self.priceBtn setTitle:TransOutput(@"价格") forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    [self.priceBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:3];
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    self.priceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.priceBtn];

  }
#pragma mark - 加载数据
-(void)loadData:(NSString*)sortType {
    
    [NetwortTool getHomeShopGoodListDetail:@{@"shopId":self.shopId,@"current":@(self.page),@"sortType":sortType,@"direction":self.direction} Success:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject[@"records"];
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:arr];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (arr.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
#pragma mark - 价格排序
-(void)priceBtnClick:(UIButton *)sender{
    self.isPriceSel = YES;
    if (!sender.selected) {
        sender.selected = YES;
        self.direction = @"1";
        [self.priceBtn setImage:[UIImage imageNamed:@"sort_price_up_icon"] forState:UIControlStateNormal];
        [self.priceBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
        
    }else{
        sender.selected = NO;
        self.direction = @"0";
        [self.priceBtn setImage:[UIImage imageNamed:@"sort_price_down_icon"] forState:UIControlStateNormal];
        [self.priceBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
     
    }
    
    self.moBtn.selected = NO;
    self.xinBtn.selected = NO;
    self.xiaoBtn.selected = NO;
    self.dataArr = [NSMutableArray array];
    self.sortType = @"3";
    self.page = 1;
    [self loadData:self.sortType];
}
#pragma mark - 默认排序
-(void)moBtnClick{
  
    self.isPriceSel = NO;
    self.moBtn.selected = YES;
    self.xinBtn.selected = NO;
    self.xiaoBtn.selected = NO;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.sortType = @"0";
    [self loadData:self.sortType];
}
#pragma mark - 销量排序
-(void)xiaoBtnClick{
   
    self.isPriceSel = NO;
    self.moBtn.selected = NO;
    self.xinBtn.selected = NO;
    self.xiaoBtn.selected = YES;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.sortType = @"1";
    [self loadData:self.sortType];

}
#pragma mark - 上新排序
-(void)xinBtnClick{
    
    self.isPriceSel = NO;
    self.moBtn.selected = NO;
    self.xinBtn.selected = YES;
    self.xiaoBtn.selected = NO;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:RGB(0xBBB8B8) forState:UIControlStateNormal];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.sortType = @"2";
    [self loadData:self.sortType];
}
-(void)GetData{
    [NetwortTool getHomeShopDetail:self.shopId Success:^(id  _Nonnull responseObject) {
        self.dataDic = responseObject;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:self.dataDic[@"shopLogo"]]]];
        self.nameLabel.text = [NSString isNullStr:self.dataDic[@"shopName"]];
//        self.desLabel.text = [NSString isNullStr:self.dataDic[@"intro"]];
        self.into =[NSString isNullStr:self.dataDic[@"intro"]];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"矩形 4957"];
        
    }
    return _bgHeaderView;
}

-(UIImageView *)avatar{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.layer.cornerRadius = 40.5;
        _avatar.clipsToBounds = YES;
        _avatar.layer.borderColor = RGB(0xDAEDFB).CGColor;
        _avatar.layer.borderWidth = 5;
    }
    return _avatar;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:24];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}
-(UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.layer.cornerRadius = 8;
        _topBgView.clipsToBounds = YES;
        _topBgView.layer.borderColor = RGB(0x197CF5).CGColor;
        _topBgView.layer.borderWidth = 1;
        _topBgView.backgroundColor = RGB(0xF6FAFE);
    }
    return _topBgView;
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 48) / 2,244);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
        @weakify(self);
        _collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData:self.sortType];
        }];
        _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData:self.sortType];
        }];
        }
    return _collectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.dataArr.count;
    
  
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HomeCollectionViewCell" owner:self options:nil].lastObject;
    }
    NSDictionary *dic;
 
        dic= self.dataArr[indexPath.row];
    
    cell.dic =dic;
//    [cell.img sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]]];
//    cell.title.text = dic[@"prodName"];
//    cell.price.text = [NSString stringWithFormat:@"%@",dic[@"price"]];
//    cell.price.font = [UIFont fontWithName:@"DINOT" size:18];
//    cell.product.text = dic[@"shopName"];
//    [cell.prductView addDiagonalCornerPath:5];
      return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
 
        dic= self.dataArr[indexPath.row];
   
    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
    vc.prodId = dic[@"prodId"];
    [self pushController:vc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
