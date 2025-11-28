//
//  GoodsCommonViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/29.
//

#import "GoodsCommonViewController.h"

@interface GoodsCommonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *moBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)int page;
@property(nonatomic, assign)int index;
@end

@implementation GoodsCommonViewController

-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
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
-(void)GetData{
    [NetwortTool getGoodCommentWithParam:@{@"prodId":self.prodId} Success:^(id  _Nonnull responseObject) {
        
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.allBtn setTitle:[NSString stringWithFormat:@"%@(%@)",TransOutput(@"全部"),responseObject[@"number"]] forState:UIControlStateNormal];
            [self.goodBtn setTitle:[NSString stringWithFormat:@"%@(%@)",TransOutput(@"好评"),responseObject[@"praiseNumber"]] forState:UIControlStateNormal];
            [self.moBtn setTitle:[NSString stringWithFormat:@"%@(%@)",TransOutput(@"中评"),responseObject[@"secondaryNumber"]] forState:UIControlStateNormal];
            [self.badBtn setTitle:[NSString stringWithFormat:@"%@(%@)",TransOutput(@"差评"),responseObject[@"negativeNumber"]] forState:UIControlStateNormal];
            
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"评论");
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_equalTo(self.allBtn.mas_bottom).offset(10);
    }];
    
   
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData:-1];
    self.index = -1;
    @weakify(self)
    [self.allBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        
        self.index = -1;
        self.page = 1;
        self.dataArr = [NSMutableArray array];
        [self loadData:-1];
    }];
    [self.goodBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.index = 0;
        self.page = 1;
        self.dataArr = [NSMutableArray array];
        [self loadData:0];
    }];
    [self.moBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.page = 1;
        self.index = 1;
        self.dataArr = [NSMutableArray array];
        [self loadData:1];
    }];
    [self.badBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        self.page = 1;
        self.index = 2;
        self.dataArr = [NSMutableArray array];
        [self loadData:2];
    }];
}
-(void)loadData:(NSInteger)index{
    [NetwortTool getGoodsCommonWithParm:@{@"prodId":self.prodId,@"evaluate":@(index),@"current":@(self.page)} Success:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject[@"records"];
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        for (int i = 0; i < arr.count; i++) {
            GoodCommentModel *model = [[GoodCommentModel alloc] initWithDic:arr[i]];
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (arr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CommonTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodCommentModel *model = self.dataArr[indexPath.row];
    
    cell.model = model;
   
return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodCommentModel *model = self.dataArr[indexPath.row];
    return model.rowH ;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        @weakify(self)
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData:self.index];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData:self.index];
        }];
        
    }
    return _tableView;
}
#pragma mark - 获取更多数据
-(void)loadMore{
    self.page++;
    [self loadData:self.index];
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
