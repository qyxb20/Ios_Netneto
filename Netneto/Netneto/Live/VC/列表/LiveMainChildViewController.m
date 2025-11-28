//
//  LiveMainChildViewController.m
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "LiveMainChildViewController.h"

@interface LiveMainChildViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSString *channel;
@property (nonatomic, strong) NothingView *nothingView;
@property(nonatomic, strong)NSString *showRole;

@end

@implementation LiveMainChildViewController

-(void)CreateView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
}
-(void)GetData{
    NSString *userID=@"";
    if (account.isLogin) {
        userID = account.userInfo.userId;
    }
    
    [NetwortTool getLiveListWithParm:@{@"pageSize":@(10),@"pageNum":@(self.page),@"userId":userID,@"categoryId":self.CategoryId} Success:^(id  _Nonnull responseObject) {
        NSLog(@"直播列表:%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
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
            self.nothingView.topCustom.constant = 80;
          if (self.dataArr.count == 0) {
              self.collectionView.backgroundView = self.nothingView;
             
          }
          else{
             
              self.collectionView.backgroundView = nil;
          }
          
        }
        else{
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            self.nothingView.topCustom.constant = 80;
          if (self.dataArr.count == 0) {
              self.collectionView.backgroundView = self.nothingView;
             
          }else{
              
              self.collectionView.backgroundView = nil;
          }
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
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无直播数据");
        _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nothingView;
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
