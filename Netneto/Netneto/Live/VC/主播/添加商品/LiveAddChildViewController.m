//
//  LiveAddChildViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "LiveAddChildViewController.h"

@interface LiveAddChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIView *topBgView;
@property(nonatomic, strong)UIButton *moBtn;
@property(nonatomic, strong)UIButton *xiaoBtn;
@property(nonatomic, strong)UIButton *xinBtn;
@property(nonatomic, strong)UIButton *priceBtn;
@property(nonatomic, assign)BOOL isPriceSel;
@property(nonatomic, strong)NSString *direction;
@property(nonatomic, strong)NSString *sortType;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *prodIdsArr;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation LiveAddChildViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    self.sortType = @"0";
    self.direction = @"0";
    self.prodIdsArr = [NSMutableArray array];
    [self loadData:self.sortType];
   
}
-(void)CreateView{
   
    [self.view addSubview:self.topBgView];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(35);
    }];
    CGFloat btnWidth = (WIDTH - 32)/ 4;
    self.moBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moBtn.frame = CGRectMake(0, 0, btnWidth, 35);
    [self.moBtn setTitle:TransOutput(@"默认") forState:UIControlStateNormal];
    [self.moBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.moBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateSelected];
    self.moBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.moBtn addTarget:self action:@selector(moBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.moBtn];
    self.moBtn.selected = YES;
    
    self.xiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xiaoBtn.frame = CGRectMake(btnWidth, 0, btnWidth, 35);
    [self.xiaoBtn setTitle:TransOutput(@"销量") forState:UIControlStateNormal];
    [self.xiaoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.xiaoBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateSelected];
    self.xiaoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xiaoBtn addTarget:self action:@selector(xiaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.xiaoBtn];

    
    self.xinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xinBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, 35);
    [self.xinBtn setTitle:TransOutput(@"上新") forState:UIControlStateNormal];
    [self.xinBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.xinBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateSelected];
    self.xinBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.xinBtn addTarget:self action:@selector(xinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.xinBtn];

    self.priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.priceBtn.frame = CGRectMake(btnWidth * 3, 0, btnWidth, 35);
    [self.priceBtn setTitle:TransOutput(@"价格") forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.priceBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:3];
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    self.priceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.priceBtn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:self.priceBtn];
   
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_offset(0);
            make.top.mas_equalTo(self.topBgView.mas_bottom).offset(10);
    }];
 
    
}
-(void)priceBtnClick:(UIButton *)sender{
    self.isPriceSel = YES;
    if (!sender.selected) {
        sender.selected = YES;
        self.direction = @"1";
        [self.priceBtn setImage:[UIImage imageNamed:@"sort_price_up_icon"] forState:UIControlStateNormal];
        [self.priceBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
        
    }else{
        sender.selected = NO;
        self.direction = @"0";
        [self.priceBtn setImage:[UIImage imageNamed:@"sort_price_down_icon"] forState:UIControlStateNormal];
        [self.priceBtn setTitleColor:RGB(0x197CF5) forState:UIControlStateNormal];
     
    }
    
    self.moBtn.selected = NO;
    self.xinBtn.selected = NO;
    self.xiaoBtn.selected = NO;
    
    self.dataArr = [NSMutableArray array];
    self.sortType = @"3";
    self.page = 1;
    [self loadData:self.sortType];
    
    
}

-(void)loadData:(NSString*)sortType {
    
    [NetwortTool getCartByClassListWithParm:@{@"channel":self.channel,@"pageNum":@(self.page),@"pageSize":@(10),@"categoryId":self.dic[@"categoryId"],@"sortType":sortType,@"direction":self.direction} Success:^(id  _Nonnull responseObject) {
        NSLog(@"获取分类下的商品：%@",responseObject);
        NSArray *arr = responseObject;
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:arr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (arr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.nothingView.topCustom.constant = 40;
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, 200);
        
      if (self.dataArr.count == 0) {
          self.tableView.backgroundView = self.nothingView;
         
      }
      else{
         
          self.tableView.backgroundView = nil;
      }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddChildTableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AddChildTableViewCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count == 0) {
        return cell;
    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.dic = dic;
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"pic"]]]];
    cell.titleLabel.text = [NSString isNullStr:dic[@"prodName"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:[NSString isNullStr:dic[@"price"]]]];
    if ([self.prodIdsArr containsObject:dic[@"prodId"]]) {
        cell.choseBtn.selected = YES;
    }
    [cell setAddShopGoodsBlock:^(NSDictionary * _Nonnull dic) {
        [self.prodIdsArr addObject:dic[@"prodId"]];
        ExecBlock(self.addGoodsBlock,dic,dic[@"shopId"]);
    }];
    
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}
-(void)moBtnClick{
  
    self.isPriceSel = NO;
    self.moBtn.selected = YES;
    self.xinBtn.selected = NO;
    self.xiaoBtn.selected = NO;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.sortType = @"0";
    [self loadData:self.sortType];
}
-(void)xiaoBtnClick{
   
    self.isPriceSel = NO;
    self.moBtn.selected = NO;
    self.xinBtn.selected = NO;
    self.xiaoBtn.selected = YES;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.sortType = @"1";
    [self loadData:self.sortType];

}
-(void)xinBtnClick{
    
    self.isPriceSel = NO;
    self.moBtn.selected = NO;
    self.xinBtn.selected = YES;
    self.xiaoBtn.selected = NO;
    self.priceBtn.selected = NO;
    [self.priceBtn setImage:[UIImage imageNamed:@"sort_defaults"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.dataArr = [NSMutableArray array];
    self.page = 1;
    self.sortType = @"2";
    [self loadData:self.sortType];
}
-(UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.layer.cornerRadius = 8;
        _topBgView.clipsToBounds = YES;
        _topBgView.layer.borderColor = RGB(0x197CF5).CGColor;
        _topBgView.layer.borderWidth = 1;
        _topBgView.backgroundColor = RGB(0xF6FAFE);
    }
    return _topBgView;
    
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
            [self loadData:self.sortType];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData:self.sortType];
      
        }];
    }
    return _tableView;
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无商品");
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
