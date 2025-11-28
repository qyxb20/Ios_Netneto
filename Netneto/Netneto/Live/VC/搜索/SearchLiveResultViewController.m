//
//  SearchLiveResultViewController.m
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "SearchLiveResultViewController.h"

@interface SearchLiveResultViewController () <UICollectionViewDelegate,
UICollectionViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIImageView *bgHeaderView;
@property(nonatomic, strong) UIView *searchView;
@property(nonatomic, strong) UIImageView *SearchImageView;
@property(nonatomic, strong) UITextField *searchTF;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation SearchLiveResultViewController
- (void)returnClick {
    [self popViewControllerAnimate];
}
- (void)initData {
    UIView *leftButtonView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn =
    [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButtonView addSubview:returnBtn];
    [returnBtn setImage:[UIImage imageNamed:@"white_back"]
               forState:UIControlStateNormal];
    [returnBtn addTarget:self
                  action:@selector(returnClick)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView =
    [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
}
- (void)CreateView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    
    self.navigationItem.title = TransOutput(@"直播搜索");
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(109);
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(37);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.top.mas_offset(11);
        make.width.height.mas_offset(15);
    }];
    self.searchTF.text = self.queryParam;
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(self.SearchImageView.mas_leading).offset(-10);
        make.top.mas_offset(8.5);
        make.height.mas_offset(20);
    }];
   
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(156);
        make.bottom.mas_equalTo(-10);
    }];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadSearchResult" object:nil];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    NSString *userID=@"";
    if (account.isLogin) {
        userID = account.userInfo.userId;
    }
    
    [NetwortTool getLiveListWithParm:@{@"pageSize":@(10),@"pageNum":@(self.page),@"userId":userID,@"queryParam":self.searchTF.text} Success:^(id  _Nonnull responseObject) {
        NSLog(@"直播列表:%@",responseObject);
        
  
        NSArray *arr = responseObject;
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
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
         
        }];
    
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.page = 1;
    [self loadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadSearchResult" object:nil];
    return YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.dataArr.count;
    
  
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveListCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveListCollectionViewCell" owner:self options:nil].lastObject;
    }
    NSDictionary *dic;
 
        dic= self.dataArr[indexPath.row];
    cell.dataDic = dic;
  
      return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.collectionView.userInteractionEnabled = NO;
    [NetwortTool getRtmInfoUserWithParm:@{@"userId":[NSString isNullStr:account.userInfo.userId],@"uid":[NSString isNullStr:account.userInfo.uid],@"channel":[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"channel"]]} Success:^(id  _Nonnull responseObject) {
         NSString *joinStatus = [NSString stringWithFormat:@"%@",responseObject[@"joinStatus"]];
        
        if ([joinStatus isEqual:@"1"]) {
          
            [self joinRoom:self.dataArr[indexPath.row] daDic:responseObject];
            

        }else{
            self.collectionView.userInteractionEnabled = YES;
            ToastShow(TransOutput(@"您已被踢出该房间"), errImg,RGB(0xFF830F));
            
        }
    } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        self.collectionView.userInteractionEnabled = YES;
        }];
     
}
-(void)joinRoom:(NSDictionary *)dic daDic:(NSDictionary *)dt{
    
    [NetwortTool getLookRoomMsgWithParm:@{@"channel":dic[@"channel"]} Success:^(id  _Nonnull responseObject) {
        NSString *showStatus =[NSString stringWithFormat:@"%@",responseObject[@"showStatus"]];
        if ([showStatus isEqual:@"1"]) {
            self.collectionView.userInteractionEnabled = YES;
            lookVideoViewController *vc = [[lookVideoViewController alloc] init];
            vc.channel = [NSString stringWithFormat:@"%@",dic[@"channel"]];
            vc.userId = [NSString stringWithFormat:@"%@",dt[@"userId"]];
            vc.uid = [NSString stringWithFormat:@"%@",dt[@"uid"]];
            vc.dataDic = dic;
            vc.showtype = [NSString stringWithFormat:@"%@",responseObject[@"showType"]];
            [self pushController:vc];
        }
        else{
            self.collectionView.userInteractionEnabled = YES;
            ToastShow(TransOutput(@"主播暂未开播"), errImg,RGB(0xFF830F));
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        self.collectionView.userInteractionEnabled = YES;
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (UIImageView *)bgHeaderView {
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
    }
    return _bgHeaderView;
}

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 18.5;
        _searchView.clipsToBounds = YES;
        _searchView.userInteractionEnabled = YES;
        _searchView.backgroundColor =
        [UIColor gradientColorArr:@[ RGB(0xF7F7F7), RGB(0xF7F7F7) ]
                        withWidth:WIDTH - 32];
    }
    return _searchView;
}
- (UIImageView *)SearchImageView {
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_SearchImageView addTapAction:^(UIView *_Nonnull view) {
            @strongify(self);
            self.page = 1;
            [self loadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadSearchResult" object:nil];
        }];
    }
    return _SearchImageView;
    ;
}
- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = YES;
        _searchTF.delegate = self;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.placeholder = TransOutput(@"搜索");
    }
    return _searchTF;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 64) / 2,263 - 17);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"LiveListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LiveListCollectionViewCell"];
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
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无直播");
        _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
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
