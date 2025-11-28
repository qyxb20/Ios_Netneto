//
//  MyCollectGoodsViewController.m
//  Netneto
//
//  Created by apple on 2024/10/24.
//

#import "MyCollectGoodsViewController.h"

@interface MyCollectGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation MyCollectGoodsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
}


-(void)CreateView{
    
    
    [self.view addSubview:self.collectionView];
 
 [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.leading.mas_equalTo(16);
     make.trailing.mas_equalTo(-16);
   
     make.top.mas_equalTo(0);
     make.bottom.mas_equalTo(self.view.mas_bottom);
     
 }];
   
}
#pragma mark - 获取收藏商品数据
-(void)loadData{

    [NetwortTool getCollGoodsListWithParm:@{@"queryParam":self.searchCount,@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
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

      return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
 
        dic= self.dataArr[indexPath.row];
   
    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
    vc.prodId = dic[@"prodId"];
    [self pushController:vc];
}
#pragma mark - lazy
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无收藏商品");
    }
    return _nothingView;
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
- (UIView *)listView {
    return self.view;
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
