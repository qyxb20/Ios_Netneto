//
//  MyAddressViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/24.
//

#import "MyAddressViewController.h"

@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation MyAddressViewController
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无地址数据");
    }
    return _nothingView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    self.navigationItem.title = TransOutput(@"地址管理");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(HeightNavBar + 16);
        make.bottom.mas_offset(-60);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:TransOutput(@"新增收货地址") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    button.layer.cornerRadius = 22;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(15);
        make.bottom.mas_offset(-8);
        make.height.mas_offset(44);
        make.trailing.mas_offset(-15);
    }];
    @weakify(self)
    [button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        AddAddressViewController *vc = [[AddAddressViewController alloc] init];
        [self pushViewController:vc];
    }];
    
}
-(void)loadData{
    [NetwortTool getUserAddressListWithParm:@{} Success:^(id  _Nonnull responseObject) {
       
        self.dataArr = responseObject;
        [self.tableView reloadData];
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.tableView.backgroundView = self.nothingView;
      }
      else{
          self.tableView.backgroundView = nil;
      }
        
       
    } failure:^(NSError * _Nonnull error) {
        
    }];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"addressCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    addressModel *model = [addressModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    
    cell.model = model;
    @weakify(self)
    [cell setDelClickBlock:^(NSString * _Nonnull addId, addressModel * _Nonnull addmodel) {
        @strongify(self)
        [self delClick:addId model:addmodel];
    }];
    [cell setChoseClickBlock:^(NSString * _Nonnull addId, addressModel * _Nonnull addmodel) {
        @strongify(self)
        [self setDefault:addId model:addmodel];
        
    }];
    [cell setEditClickBlock:^{
        AddAddressViewController *vc = [[AddAddressViewController alloc] init];
        vc.model = model;
        vc.isMody = YES;
        [self pushViewController:vc];
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    addressModel *model = [addressModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    
    if (self.isOrder) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadAddOrder" object:nil userInfo:@{@"addId":model.addrId}];
        [self popViewControllerAnimate];
    }
}
-(void)setDefault:(NSString *)ids model:(addressModel *)model{
    [NetwortTool getDefaultAddWithParm:ids Success:^(id  _Nonnull responseObject) {
        NSString *msg =  [NSString stringWithFormat:@"%@「%@」%@",TransOutput(@"收货人"),model.receiver,TransOutput(@"地址修改成功")];
        
        ToastShow(TransOutput(msg),@"chenggong",RGB(0x36D053));
        [self loadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)delClick:(NSString *)ids model:(addressModel *)model{
    @weakify(self)
    CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否删除吗？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
        @strongify(self)
        [NetwortTool delAddressWithParm:ids Success:^(id  _Nonnull responseObject) {
            NSString *msg =  [NSString stringWithFormat:@"%@「%@」%@",TransOutput(@"收货人"),model.receiver,TransOutput(@"地址删除成功")];
            
            ToastShow(TransOutput(msg),@"chenggong",RGB(0x36D053));
            [self loadData];
          
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    } cancelBlock:^{
        
    }];
    [alert show];
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    addressModel *model = [addressModel mj_objectWithKeyValues:self.dataArr[indexPath.row]];
    NSString *code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:model.postCode] substringToIndex:3],[[NSString isNullStr:model.postCode] substringFromIndex:3]];
    NSString *addStr = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:model.province],[NSString isNullStr:model.city],[NSString isNullStr:model.area],[NSString isNullStr:model.addr]];
    
    CGFloat h = [Tool getLabelHeightWithText:addStr width:WIDTH - 144 font:12];
    if (14 +17 + 5 + h > 68) {
        return 130;
    }
    else{
        return 110;
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
