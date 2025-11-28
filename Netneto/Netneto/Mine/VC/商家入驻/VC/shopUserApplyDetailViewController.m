//
//  shopUserApplyDetailViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import "shopUserApplyDetailViewController.h"

@interface shopUserApplyDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)shopUserApplyDetailView *headerView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UICollectionView *collectionView;
@end

@implementation shopUserApplyDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self GetInfoData];
}
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
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
  
}

-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
  
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"我的店铺");
    [self.view addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {

          self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

      }
     [self.view addSubview:self.collectionView];
  
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.trailing.mas_equalTo(0);
      make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(0);
      make.bottom.mas_equalTo(self.view.mas_bottom);
      
  }];
    // Do any additional setup after loading the view.
}
-(void)GetInfoData{
    [NetwortTool getShopApplyListWithParm:@{} Success:^(id  _Nonnull responseObject) {
        NSArray *arr =responseObject;
        self.dataDic =arr[0];
        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
      
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (void)loadData{
    [NetwortTool getShopFindProdsWithParm:@{@"shopId":self.dataDic[@"shopId"],@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray: responseObject[@"records"]];
        
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(shopUserApplyDetailView *)headerView{
    if (!_headerView) {
        _headerView = [[shopUserApplyDetailView alloc] init];
        _headerView.dataDic = self.dataDic;
        @weakify(self);
        [_headerView setAddGoodsBlock:^{
            @strongify(self);
            PostGoodsVC *vc =[[PostGoodsVC alloc] init];
            [self pushController:vc];
            
        }];
        [_headerView setModyShopInfoBlock:^{
            @strongify(self);
            ModeyShopInfoViewController *vc = [[ModeyShopInfoViewController alloc] init];
            vc.dataDic = self.dataDic;
            vc.isShopVC = @"1";
            [self pushController:vc];
        }];
        [_headerView setIntrBlock:^(NSString * _Nonnull info) {
            @strongify(self);
            shopindructViewController *vc = [[shopindructViewController alloc] init];
            vc.into = info;
            [self pushController:vc];
        }];
    }
    return _headerView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 64) / 2,245);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"shopUserApplyDetailViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"shopUserApplyDetailViewCollectionViewCell"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
       
        @weakify(self);
        _collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData];
        }];
       
   
       
        }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = nil;
     
   
   
        [headerView removeFromSuperview];
    [self.headerView removeFromSuperview];
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
     
    self.headerView.dataDic = self.dataDic;
        [headerView addSubview:self.headerView];
        @weakify(self);
    CGFloat nameH = [Tool getLabelHeightWithText:[NSString isNullStr:self.dataDic[@"shopName"]] width:WIDTH - 182 font:25];
    CGFloat desH = [Tool getLabelHeightWithText:[NSString isNullStr:self.dataDic[@"intro"]] width:WIDTH - 182 font:10];
    CGFloat custH = 81;
    if (nameH + desH > 81) {
        custH = nameH + desH;
    }
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(180 +72 + 54);
    }];
        return headerView;
  
   
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat nameH = [Tool getLabelHeightWithText:[NSString isNullStr:self.dataDic[@"shopName"]] width:WIDTH - 182 font:25];
    CGFloat desH = [Tool getLabelHeightWithText:[NSString isNullStr:self.dataDic[@"intro"]] width:WIDTH - 182 font:10];
    CGFloat custH = 81;
    if (nameH + desH > 81) {
        custH = nameH + desH;
    }
    
        return  CGSizeMake(WIDTH,180 +72 +54);
  
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataArr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    shopUserApplyDetailViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopUserApplyDetailViewCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"shopUserApplyDetailViewCollectionViewCell" owner:self options:nil].lastObject;
    }
    NSDictionary *dic = self.dataArr[indexPath.item];
    [cell.ima sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
    cell.title.text = [NSString isNullStr:dic[@"prodName"]];
    cell.price.text = [NSString stringWithFormat:@"¥%@",[NSString isNullStr:[NSString ChangePriceStr:dic[@"price"]]]];
    cell.price.font = [UIFont fontWithName:@"DINOT" size:18];
    [cell.prductView addDiagonalCornerPath:5];
    if ([dic[@"status"] isEqual:@(1)]) {
        [cell.downBtn setImage:[UIImage imageNamed:@"组合 344"] forState:UIControlStateNormal];
    }
    else{
        [cell.downBtn setImage:[UIImage imageNamed:@"组合 343"] forState:UIControlStateNormal];
    }
    cell.downBtn.tag = indexPath.row;
    [cell.downBtn addTapAction:^(UIView * _Nonnull view) {
        [self upDownGoos:indexPath.row];
    }];
    
        return cell;
}
-(void)upDownGoos:(NSInteger)tag{
    NSDictionary *dic = self.dataArr[tag];
    NSInteger staus;
    if ([dic[@"status"] isEqual:@(1) ]) {
        staus = 0;
    }
    else{
        staus = 1;
    }
    [NetwortTool getUpdateProdStatusWithParm:@{@"prodId":dic[@"prodId"],@"prodStatus":@(staus)} Success:^(id  _Nonnull responseObject) {
        
        NSMutableDictionary *dataDic= [NSMutableDictionary dictionaryWithDictionary:dic];
        [dataDic setValue:@(staus) forKey:@"status"];
        [self.dataArr replaceObjectAtIndex:tag withObject:dataDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            if (staus == 0) {
                ToastShow(TransOutput(@"下架成功"), @"chenggong", RGB(0x36D053));
            }
            else{
                ToastShow(TransOutput(@"上架成功"), @"chenggong", RGB(0x36D053));
            }
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.item];
   
    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
    vc.prodId = dic[@"prodId"];
    [self pushController:vc];
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
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
