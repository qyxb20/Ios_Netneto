//
//  HomeSectionViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/13.
//

#import "HomeSectionViewController.h"

@interface HomeSectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation HomeSectionViewController

-(void)returnClick{
    [self popViewControllerAnimate];
}
- (void)initData{
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

}
-(void)CreateView{
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = self.titleStr;
    [self.view addSubview:self.collectionView];
 
 [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.leading.mas_equalTo(16);
     make.trailing.mas_equalTo(-16);
   
     make.top.mas_equalTo(HeightNavBar + 16);
     make.bottom.mas_equalTo(self.view.mas_bottom);
     
 }];
   
}
-(void)GetData{
    if (self.isClass) {
        //通过分类id商品列表信息
        [NetwortTool getClassChildData:@{@"categoryId":self.categoryId,@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                if (![self.dataArr containsObject:arr[i]]) {
                    [self.dataArr addObject:arr[i]];
                }
            }
            
            
//            [self.dataArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            if (arr.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            
          if (self.dataArr.count == 0) {
              self.collectionView.backgroundView = self.nothingView;
             
          }
          else{
             
              self.collectionView.backgroundView = nil;
          }
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
    else if (self.isTag){
        //首页更多
        [NetwortTool getHomeSectionItem:RequestURL(@"/index/prodListByTagId") parm:@{@"tagId":self.tagId,@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                if (![self.dataArr containsObject:arr[i]]) {
                    [self.dataArr addObject:arr[i]];
                }
            }
//            [self.dataArr addObjectsFromArray:arr];
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
    else{
        //首页新品推荐及每日疯抢
        [NetwortTool getHomeHeaderItem:self.urlStr parm:@{@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                if (![self.dataArr containsObject:arr[i]]) {
                    [self.dataArr addObject:arr[i]];
                }
            }
//            [self.dataArr addObjectsFromArray:arr];
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
            [self GetData];
        }];
        _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self GetData];
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
    
    cell.dic = dic;
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
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无分类商品");
    }
    return _nothingView;
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
