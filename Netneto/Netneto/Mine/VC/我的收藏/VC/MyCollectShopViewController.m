//
//  MyCollectShopViewController.m
//  Netneto
//
//  Created by apple on 2024/10/24.
//

#import "MyCollectShopViewController.h"

@interface MyCollectShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation MyCollectShopViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
}

-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
  
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.bottom.mas_offset(0);
        make.top.mas_offset(0);
        
    }];
    
}
#pragma mark - 获取收藏店铺数据
-(void)loadData{
    [NetwortTool getCollShopsListWithParm:@{@"queryParam":self.searchCount,@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        
        [self.dataArr addObjectsFromArray:responseObject[@"records"]];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.tableView.backgroundView = self.nothingView;
         
      }
      else{
         
          self.tableView.backgroundView = nil;
      }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 16)];
    vi.backgroundColor =  RGB(0xF9F9F9);
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectShopTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyCollectShopTableViewCell" owner:self options:nil].lastObject;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArr[indexPath.section];
    [cell.shopLogo sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
    cell.shopName.text = [NSString isNullStr:dic[@"shopName"]];
    [cell.joinShopBtn setTitle:TransOutput(@"进店") forState:UIControlStateNormal];
    [cell.joinShopBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [cell.joinShopBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
      @weakify(self);
    [cell.joinShopBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        HomeShopViewControll *vc = [[HomeShopViewControll alloc] init];
        vc.shopId = dic[@"shopId"];
        [self pushController:vc];
    }];
    if ([dic[@"prods"] isKindOfClass:[NSArray class]]) {
        NSArray *arr = dic[@"prods"];
        NSInteger num = 0;
        for (NSDictionary *dict in arr) {
            NSString *soldNum = [NSString stringWithFormat:@"%@",dict[@"soldNum"]];
            
            num += [[NSString isNullStr:soldNum] integerValue];
            
        }
  
        switch (arr.count) {
            case 1:
            {
                cell.goodOne.tag = 1;
                [cell.goodOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[0][@"pic"]]] forState:UIControlStateNormal];
                @weakify(self);
                [cell.goodOne addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[0][@"prodId"];
                    [self pushController:vc];
                }];
            }
                break;
            case 2:
            {
                cell.goodOne.tag = 1;
                [cell.goodOne sd_setBackgroundImageWithURL:[NSURL URLWithString:arr[0][@"pic"]] forState:UIControlStateNormal];
                @weakify(self);
                [cell.goodOne addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[0][@"prodId"];
                    [self pushController:vc];
                }];
                
                cell.goodTwo.tag = 2;
                [cell.goodTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[1][@"pic"]]] forState:UIControlStateNormal];
                [cell.goodTwo addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[1][@"prodId"];
                    [self pushController:vc];
                }];
                
            }
                break;
            case 3:
            {
                cell.goodOne.tag = 1;
                [cell.goodOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[0][@"pic"]]] forState:UIControlStateNormal];
                @weakify(self);
                [cell.goodOne addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[0][@"prodId"];
                    [self pushController:vc];
                }];
                
                cell.goodTwo.tag = 2;
                [cell.goodTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[1][@"pic"]]] forState:UIControlStateNormal];
                [cell.goodTwo addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[1][@"prodId"];
                    [self pushController:vc];
                }];
                
                cell.goodThree.tag = 3;
                [cell.goodThree sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[2][@"pic"]]] forState:UIControlStateNormal];
                [cell.goodThree addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[2][@"prodId"];
                    [self pushController:vc];
                }];
            }
               
                break;
            case 4:
            {
                cell.goodOne.tag = 1;
                [cell.goodOne sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[0][@"pic"]]] forState:UIControlStateNormal];
                @weakify(self);
                [cell.goodOne addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[0][@"prodId"];
                    [self pushController:vc];
                }];
                
                cell.goodTwo.tag = 2;
                [cell.goodTwo sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[1][@"pic"]]] forState:UIControlStateNormal];
                [cell.goodTwo addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[1][@"prodId"];
                    [self pushController:vc];
                }];
                
                cell.goodThree.tag = 3;
                [cell.goodThree sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[2][@"pic"]]] forState:UIControlStateNormal];
                [cell.goodThree addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[2][@"prodId"];
                    [self pushController:vc];
                }];
                
                cell.goodFour.tag = 4;
                [cell.goodFour sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString isNullStr:arr[3][@"pic"]]] forState:UIControlStateNormal];
                
                [cell.goodFour addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self);
                    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                    vc.prodId = arr[3][@"prodId"];
                    [self pushController:vc];
                }];
            }
              
        
                break;
            default:
                break;
        }

    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 158;
}

#pragma mark - lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        @weakify(self)
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData];
        }];
        
    }
    return _tableView;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无收藏店铺");
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
