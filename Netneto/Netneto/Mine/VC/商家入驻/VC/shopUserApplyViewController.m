//
//  shopUserApplyViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/26.
//

#import "shopUserApplyViewController.h"

@interface shopUserApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)int page;
@property(nonatomic, assign)BOOL isShop;
@property (nonatomic, strong) NothingView *nothingView;
@property (nonatomic, strong) UIButton *button;
@property(nonatomic, assign)BOOL isEnablePick;
@end

@implementation shopUserApplyViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isShop = NO;
    self.isEnablePick = NO;
    self.dataArr  = [NSMutableArray array];
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
    self.navigationItem.title = TransOutput(@"商家入驻");
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 109, WIDTH, HEIGHT - 160) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    

    [self.view addSubview:self.tableView];
   
 
    [self.button removeFromSuperview];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:TransOutput(@"新增入驻申请") forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    self.button.layer.cornerRadius = 22;
    self.button.clipsToBounds = YES;
    self.button.userInteractionEnabled = NO;
   
   
    @weakify(self)
    [self.button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        
            
       
        if (self.dataArr.count == 0) {
            addShopUserViewController *vc = [[addShopUserViewController alloc] init];
            vc.rejectId = @"0";
            [self pushController:vc];
        }
        else{
           
                ToastShow(TransOutput(@"只能申请一次"), errImg,RGB(0xFF830F));
          
            }
        
    }];

}
-(void)loadData{

    [NetwortTool getShopApplyListWithParm:@{} Success:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.isShop = YES;
            
            NSArray *arr =responseObject;
            if (arr.count > 0) {
                [self.dataArr addObject:arr.firstObject];
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                self.tableView.backgroundView = nil;
                [self.view addSubview:self.button];
                [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_offset(15);
                    make.bottom.mas_offset(-8);
                    make.height.mas_offset(44);
                    make.trailing.mas_offset(-15);
                }];
            }
            else{
                self.isShop = NO;
                [self getApplyList];
            }
            self.isEnablePick = YES;
        }
        else{
            self.isEnablePick = YES;
            [self.view addSubview:self.button];
            [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_offset(15);
                make.bottom.mas_offset(-8);
                make.height.mas_offset(44);
                make.trailing.mas_offset(-15);
            }];
        }
    } failure:^(NSError * _Nonnull error) {

        self.isShop = NO;
        [self getApplyList];
        self.isEnablePick = YES;
    }];
    
}
-(void)getApplyList{
    [NetwortTool getUserApplyListWithParm:@"" Success:^(id  _Nonnull responseObject) {
        
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic =responseObject[@"data"];
                
                [self.dataArr addObject:dic];
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                self.tableView.backgroundView = nil;
             
                self.isEnablePick = YES;
                [self.view addSubview:self.button];
                [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_offset(15);
                    make.bottom.mas_offset(-8);
                    make.height.mas_offset(44);
                    make.trailing.mas_offset(-15);
                }];
            });
        }
        else{
           
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArr = [NSMutableArray array];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
                self.tableView.backgroundView = self.nothingView;
                [self.view addSubview:self.button];
                [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_offset(15);
                    make.bottom.mas_offset(-8);
                    make.height.mas_offset(44);
                    make.trailing.mas_offset(-15);
                }];
            });
          
        }
      
//
    } failure:^(NSError * _Nonnull error) {
        
        if ([error.userInfo[@"code"] isEqual:@"A00001"]) {
            self.dataArr = [NSMutableArray array];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.view addSubview:self.button];
            [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_offset(15);
                make.bottom.mas_offset(-8);
                make.height.mas_offset(44);
                make.trailing.mas_offset(-15);
            }];
            
        }else{
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserApplyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UserApplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
   

    if (self.isShop ) {
        cell.name.text = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"shopName"]]];
        cell.des.text = [NSString isNullStr:dic[@"intro"]];
        cell.refLabel.hidden = YES;
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"shopLogo"]]] placeholderImage:[UIImage imageNamed:@"图层 2"]];
        NSString *str = @"";
        if ([dic[@"shopStatus"] isEqual:@1]) {
            str = TransOutput(@"营业中");
            
            
            
        }
        else if ([dic[@"shopStatus"] isEqual:@0]){
            str = TransOutput(@"停业中");
           
          
        }
        self.button.hidden = YES;
        cell.stauseLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"状态"),str];
        cell.des.hidden = YES;
        
        cell.modyButton.hidden = NO;
        cell.modyButton.tag = indexPath.row;
    
        [cell.modyButton setTitle:TransOutput(@"店铺介绍") forState:UIControlStateNormal];
        [cell.modyButton addTarget:self action:@selector(modyClik:) forControlEvents:UIControlEventTouchUpInside];
        
        self.button.hidden = YES;
    }
    else{
        cell.name.text = [NSString stringWithFormat:@"%@",[NSString isNullStr:dic[@"merchantName"]]];
        
        NSString *str = @"";
        if ([dic[@"approveStatus"] isEqual:@0]) {
            str = TransOutput(@"审核中");
            cell.avatar.image =[UIImage imageNamed:@"图层 2"];
            cell.des.hidden = YES;
            self.button.hidden = NO;
            cell.modyButton.hidden = YES;
            cell.refLabel.hidden = YES;
        }
        else if ([dic[@"approveStatus"] isEqual:@1]){
            str = TransOutput(@"审核已通过");
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:dic[@"shopLogo"]]] placeholderImage:[UIImage imageNamed:@"图层 2"]];
            cell.des.hidden = YES;
            cell.modyButton.hidden = NO;
            cell.modyButton.tag = indexPath.row;
            cell.refLabel.hidden = YES;
            [cell.modyButton setTitle:TransOutput(@"发布店铺") forState:UIControlStateNormal];
            @weakify(self)
            [cell.modyButton addTapAction:^(UIView * _Nonnull view) {
                @strongify(self);
                ModeyShopInfoViewController *vc = [[ModeyShopInfoViewController alloc] init];
                vc.isShopVC = @"0";
                [self pushController:vc];
            }];
            self.button.hidden = YES;
        }
        else if ([dic[@"approveStatus"] isEqual:@2]){
            cell.avatar.image =[UIImage imageNamed:@"图层 2"];
            str = TransOutput(@"已驳回");
            cell.des.hidden = YES;
            
            self.button.hidden = NO;
            cell.modyButton.hidden = NO;
            [cell.modyButton setTitle:TransOutput(@"再次申请") forState:UIControlStateNormal];
            
            [cell.modyButton addTapAction:^(UIView * _Nonnull view) {
                 addShopUserViewController *vc = [[addShopUserViewController alloc] init];
                vc.rejectId = dic[@"id"];
                vc.dataDic = dic;
                [self pushController:vc];
      
            }];
            cell.refLabel.hidden = NO;
            cell.refLabel.text = [NSString stringWithFormat:@"%@:\n%@",TransOutput(@"拒绝理由"),[NSString isNullStr:dic[@"approveComment"]]];

        }
        cell.stauseLabel.text = [NSString stringWithFormat:@"%@:%@",TransOutput(@"状态"),str];
    }

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    if (self.isShop ) {
        return 220;
    }
    else{
        if ([dic[@"approveStatus"] isEqual:@2]) {
            CGFloat h = [Tool getLabelHeightWithText: [NSString stringWithFormat:@"%@:\n%@",TransOutput(@"拒绝理由"),[NSString isNullStr:dic[@"approveComment"]]] width:WIDTH - 32 font:12];
            return 230 + h;
        }
        else{
            return 220;
        }
    }
}
-(void)modyClik:(UIButton *)sender{
    NSDictionary *dic = self.dataArr[sender.tag];
    [self pushDetail:dic];
}
-(void)pushDetail:(NSDictionary *)dic{
    
    if (self.isShop ) {
        shopUserApplyDetailViewController *vc = [[shopUserApplyDetailViewController alloc] init];
        vc.dataDic = dic;
        [self pushController:vc];
    }else{
        if ([dic[@"approveStatus"] isEqual:@1]) {

        }
        else if ([dic[@"approveStatus"] isEqual:@0]) {
            ToastShow(TransOutput(@"请等待审核人员审核"), @"chenggong",RGB(0x36D053));
            
        }
        else if ([dic[@"approveStatus"] isEqual:@2]) {
            
            addShopUserViewController *vc = [[addShopUserViewController alloc] init];
            vc.rejectId = dic[@"id"];
            vc.dataDic = dic;
            [self pushController:vc];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > 0 ) {
        
   
    NSDictionary *dic = self.dataArr[indexPath.row];
        [self pushDetail:dic];
    }
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
