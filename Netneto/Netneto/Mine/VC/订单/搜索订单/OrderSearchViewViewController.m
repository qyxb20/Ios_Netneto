//
//  OrderSearchViewViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "OrderSearchViewViewController.h"

@interface OrderSearchViewViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@end

@implementation OrderSearchViewViewController

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
    self.navigationItem.title = TransOutput(@"搜索");
   
 
    
    [self.view addSubview:self.searchView];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = RGB(0xE1E1E1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(0);
        make.leading.mas_offset(0);
        make.trailing.mas_offset(0);
        make.height.mas_offset(1);
    }];
    
    
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(12);
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(30);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-12);
        make.top.mas_offset(6.5);
        make.width.height.mas_offset(17);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(self.SearchImageView.mas_leading).offset(-10);
        make.top.mas_offset(5);
        make.height.mas_offset(20);
    }];
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = RGB(0xE1E1E1);
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(10);
        make.leading.mas_offset(0);
        make.trailing.mas_offset(0);
        make.height.mas_offset(1);
    }];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_equalTo(line2.mas_bottom).offset(10);
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行任何必要的异步操作
        // 当所有必要操作完成后，返回主线程设置searchTextField为第一响应者
        dispatch_async(dispatch_get_main_queue(), ^{
           
                [self.searchTF becomeFirstResponder];
            
        });
    });
    
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无订单数据");
    }
    return _nothingView;
}
-(void)loadData{
    if (self.index == 5) {
        [HudView showHudForView:self.view];
        if (self.page == 0) {
            self.page += 1;
        }
        NSDictionary *parm = @{@"orderNumber":self.searchTF.text,@"current":@(self.page),@"size":@(10)};
          [NetwortTool getUserRefunOrderWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSLog(@"退货订单列表%@",responseObject);
            [HudView hideHudForView:self.view];
            NSArray *arr = responseObject;
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                RefunOrderModel *model = [RefunOrderModel mj_objectWithKeyValues:arr[i]];
                [self.dataArr addObject:model];
            }
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.dataArr.count == 0) {
                self.tableView.backgroundView = self.nothingView;
            }
            else{
                self.tableView.backgroundView = nil;
            }
            
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
        
    }else{
        if (self.index == 4) {
            self.status = @"5";
            
        }
        else{
            self.status = [NSString stringWithFormat:@"%ld",(long)self.index];
        }
        
        NSDictionary *parm = @{@"orderNumber":self.searchTF.text,@"status":self.status,@"current":@(self.page)};
        [HudView showHudForView:self.view];
        [NetwortTool getUserOrderWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSLog(@"订单列表%@",responseObject);
            [HudView hideHudForView:self.view];
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                OrderModel *model = [OrderModel mj_objectWithKeyValues:arr[i]];
                [self.dataArr addObject:model];
            }
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.dataArr.count == 0) {
                self.tableView.backgroundView = self.nothingView;
            }
            else{
                self.tableView.backgroundView = nil;
            }
            
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
   
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index != 5) {
        MineOrderChildTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
           cell = [[MineOrderChildTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArr.count != 0) {
            OrderModel *model = self.dataArr[indexPath.row];
            cell.model = model;
            @weakify(self);
            [cell setPushComAddBlock:^(OrderModel * _Nonnull model) {
                @strongify(self);
                            AddCommViewController *vc = [[AddCommViewController alloc] init];
                            vc.model = model;
                            [self pushController:vc];
            }];
        }
        
        return cell;
    }
    else{
        MineOrderRefunTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[MineOrderRefunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RefunOrderModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index != 5) {
        if (self.dataArr.count != 0) {
            OrderModel *model = self.dataArr[indexPath.row];
            OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
            vc.orderNumber =model.orderNumber;
            vc.staus = model.status;
            [self pushController:vc];
        }
       
    }else
    {
        if (self.dataArr.count != 0 ) {
            RefunOrderModel *model = self.dataArr[indexPath.row];
            OrderDetailInfoRefunViewController *vc = [[OrderDetailInfoRefunViewController alloc] init];
            vc.refundId =model.refundId;
            vc.orderNumber = model.orderNumber;
            [self pushController:vc];
        }
      
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index != 5) {
        
        OrderModel *model = self.dataArr[indexPath.row];
        return model.orderItemDtos.count * 98 + 66 + 12;
    }
    else{
        
        return  98 + 66 + 12;
  
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
    return YES;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 15;
        _searchView.clipsToBounds = YES;
        _searchView.backgroundColor = RGB(0xF9F9F9);
        @weakify(self)
        
    }
    return _searchView;
}
-(UIImageView *)SearchImageView{
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = YES;
        @weakify(self)
        [_SearchImageView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [self loadData];
        }];
    }
    return _SearchImageView;;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = YES;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.placeholder = TransOutput(@"请输入商品名称/订单编号");
        _searchTF.delegate = self;
    }
    return _searchTF;
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
