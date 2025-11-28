//
//  followLiveViewController.m
//  Netneto
//
//  Created by apple on 2024/10/18.
//

#import "followLiveViewController.h"

@interface followLiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation followLiveViewController

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
        _nothingView.titleLabel.text = TransOutput(@"暂无关注主播");
    }
    return _nothingView;
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
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"我的关注");
    [self.view addSubview:self.collectionView];
    
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(109);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            
        }];
    
    // Do any additional setup after loading the view.
}
-(void)GetData{
   
    [NetwortTool getMyFollowWithParm:@{@"pageSize":@(10),@"pageNum":@(self.page)} Success:^(id  _Nonnull responseObject) {
        NSLog(@"关注列表:%@",responseObject);

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
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.dataArr.count;
    
  
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    followLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"followLiveCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"followLiveCollectionViewCell" owner:self options:nil].lastObject;
    }
    NSDictionary *dic= self.dataArr[indexPath.row];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"shopLogo"]]]];
    cell.shopNameLabel.text = [NSString isNullStr:dic[@"shopName"]];
    cell.livingLabel.layer.cornerRadius = 5;
    if ([dic[@"showStatus"] intValue] == 1) {
        cell.livingLabel.hidden = NO;
        cell.livingLabel.clipsToBounds = YES;
        cell.livingLabel.text = [NSString stringWithFormat:@"  %@  ",TransOutput(@"直播中")];

    }
    else{
        cell.livingLabel.hidden = YES;
    }
     @weakify(self);
    [cell.delBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self delFollow:dic];
    }];

      return cell;
}
-(void)delFollow:(NSDictionary *)dic{
    [NetwortTool getUpdateFollowWithParm:@{@"shopId":dic[@"shopId"]} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ToastShow(TransOutput(@"取消关注成功"), @"chenggong", RGB(0x36D053));
            [self.dataArr removeObject:dic];
            [self.collectionView reloadData];
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic= self.dataArr[indexPath.row];
    
    [NetwortTool getRtmInfoUserWithParm:@{@"userId":[NSString isNullStr:account.userInfo.userId],@"uid":[NSString isNullStr:account.userInfo.uid],@"channel":[NSString stringWithFormat:@"%@",dic[@"channel"]]} Success:^(id  _Nonnull responseObject) {
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
            vc.showtype =[NSString stringWithFormat:@"%@",responseObject[@"uid"]];
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
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 64) / 2,224);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"followLiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"followLiveCollectionViewCell"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
