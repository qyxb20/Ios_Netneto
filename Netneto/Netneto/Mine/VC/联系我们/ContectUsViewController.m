//
//  ContectUsViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "ContectUsViewController.h"

@interface ContectUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)int page;
@property (nonatomic, strong) NothingView *nothingView;
@property (nonatomic, strong) TMSInputView *inputView;
@end

@implementation ContectUsViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
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
  
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
  
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"联系我们");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(10);
        make.bottom.mas_offset(70);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:TransOutput(@"新增提问信息") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    button.layer.cornerRadius = 22;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(15);
        make.bottom.mas_offset(-24);
        make.height.mas_offset(44);
        make.trailing.mas_offset(-15);
    }];
    @weakify(self)
    [button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        addContactViewController *vc = [[addContactViewController alloc] init];
        [self pushController:vc];
    }];

}
-(void)loadData{
    [HudView showHudForView:self.view];
  
    [NetwortTool getContactUsListWithParm:@{@"size":@(10),@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
      
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
        [HudView hideHudForView:self.view];
      
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContectUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContectUsTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ContectUsTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ContectUsModel *model = [ContectUsModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    cell.model = model;
    @weakify(self)
    [cell.delbtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self delClick:self.dataArr[indexPath.row][@"id"] cnmodel:model];
    }];
    [cell.edbtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        
            addContactViewController *vc = [[addContactViewController alloc] init];
            vc.model = model;
            [self pushController:vc];
        
        
    }];
    return cell;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无数据");
    }
    return _nothingView;
}
-(void)delClick:(NSString *)ids cnmodel:(ContectUsModel *)model{
    @weakify(self)
    CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除吗？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
        @strongify(self)
        [NetwortTool delContactUsWithParm:ids Success:^(id  _Nonnull responseObject) {
            for (NSDictionary *dic  in self.dataArr) {
                if ([dic[@"id"] isEqual:ids]) {
                    
                    NSString *msg =  [NSString stringWithFormat:@"お問い合わせ「%@」を削除しました。",dic[@"topic"]];
                    
                    ToastShow(TransOutput(msg),@"chenggong",RGB(0x36D053));
                    [self.dataArr removeObject:dic];
                    break;
                }
            }
            
            
            [self.tableView reloadData];
          
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    } cancelBlock:^{
        
    }];
    [alert show];
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContectUsModel *model = [ContectUsModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    
    
        ContectUsDetailViewController *vc = [[ContectUsDetailViewController alloc] init];
        vc.idStr =[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"id"]];
        [self pushController:vc];

    
}
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
