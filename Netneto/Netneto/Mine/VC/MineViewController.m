//
//  MineViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "MineViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)MineHeaderView *headerView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArr;
@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [account loadResource];
    
}
-(void)initData{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetUserInfo) name:@"uploadUserInfo" object:nil];
    
}

-(void)resetUserInfo{
    if (account.isLogin) {
       
       
//        [self updateMineMsgNum];
        [self.headerView.avatarBtn sd_setImageWithURL:[NSURL URLWithString:account.userInfo.pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"椭圆 6"]];
        
        [self.headerView.nameLabel setTitle:account.userInfo.nickName forState:UIControlStateNormal];
        self.headerView.idLabel.text = @"";
        
        if ([account.userInfo.merchant isEqual:@"1"]) {
            self.headerView.typeImageView.hidden = NO;
        }
        else{
            self.headerView.typeImageView.hidden = YES;
        }
        @weakify(self);
        [self.headerView setPushOrderBlock:^(NSInteger tag) {
            @strongify(self);
            if (!account.isLogin) {
                LoginViewController *vc = [[LoginViewController alloc] init];
                [self pushController:vc];
                
            }else{
                MineOrderViewController *vc = [[MineOrderViewController alloc] init];
                switch (tag) {
                    case 1000:
                        vc.index = 0;
                        break;
                    case 0:
                        vc.index = 1;
                        break;
                    case 1:
                        vc.index = 2;
                        break;
                    case 2:
                        vc.index = 3;
                        break;
                    case 3:
                        vc.index = 4;
                        break;
                    default:
                        break;
                }
                [self pushController:vc];
            }
        }];
        [self.headerView setLoginBlock:^{
            @strongify(self);
            EditInfoViewController *vc = [[EditInfoViewController alloc] init];
            [self pushController:vc];
        }];
        [self.headerView setButtonBlock:^(NSInteger tag) {
            @strongify(self);
            if (tag == 0) {
                MyCollectViewController *vc = [[MyCollectViewController alloc] init];
                [self pushController:vc];
            }
            else if (tag == 1){
//                MineMessageViewController *vc = [[MineMessageViewController alloc] init];
//                [self pushController:vc];
              
                MineMsgViewController *vc = [[MineMsgViewController alloc] init];
                [self pushController:vc];
            }
            else if (tag == 2){
                //                ToastShow(TransOutput(@"该功能暂未开放"), errImg,RGB(0xFF830F));
                MyFootprintViewController *vc = [[MyFootprintViewController alloc] init];
                [self pushController:vc];
            }
        }];
       
    }
    else{

        [self.headerView.avatarBtn setImage:[UIImage imageNamed:@"椭圆 6"] forState:UIControlStateNormal];
      [self.headerView.nameLabel setTitle:TransOutput(@"注册/登录") forState:UIControlStateNormal];
      self.headerView.idLabel.text = @"";
      self.headerView.typeImageView.hidden = YES;
        
            @weakify(self);
            
            [self.headerView setLoginBlock:^{
                @strongify(self);
                LoginViewController *vc = [[LoginViewController alloc] init];
                [self pushController:vc];
            }];
            [self.headerView setPushOrderBlock:^(NSInteger tag) {
                @strongify(self);
                LoginViewController *vc = [[LoginViewController alloc] init];
                [self pushController:vc];
            }];
        [self.headerView setButtonBlock:^(NSInteger tag) {
            @strongify(self);
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self pushController:vc];
        }];
        
    }
    
    [self.headerView updateCollect];
    [self.headerView updateMsg];
    [self.headerView updateFoot];
    [self updateMineMsgNum];
}
-(void)CreateView{
    if (@available(iOS 11.0, *)) {

          self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

      }
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.mas_offset(0);
    }];

    self.tableView.tableHeaderView = self.headerView;
    [self resetUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadCollec" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.headerView updateCollect];
           
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadFoot" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.headerView updateFoot];
           
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadMsg" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.headerView updateMsg];
            [self updateMineMsgNum];
        });
    }];
}
-(void)updateMineMsgNum{
    if ([[NSString isNullStr:account.userInfo.userId] length]> 0) {
        [NetwortTool getfindImCountsWithParm:@{@"userId":account.userInfo.userId} Success:^(id  _Nonnull responseObject) {
            
            if ([responseObject integerValue] == 0 ) {
                [self.tabBarController.tabBar removeBadgeOnItemIndex:4];
            }else{
                if ([responseObject integerValue] > 99) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:4 tex:[NSString stringWithFormat:@"99+"]];
                }
                else{
                    [self.tabBarController.tabBar showBadgeOnItemIndex:4 tex:[NSString stringWithFormat:@"%ld",(long)[responseObject integerValue]]];
                }
            }
        } failure:^(NSError * _Nonnull error) {
            [self.tabBarController.tabBar removeBadgeOnItemIndex:4];
        }];
    }
    else{
        [self.tabBarController.tabBar removeBadgeOnItemIndex:4];
    }
}
- (void)GetData{
    self.dataArr = @[             @{@"img":@"mine_shop",@"name":TransOutput(@"商家入驻/我的店铺")},
                     @{@"img":@"mine_lq",@"name":TransOutput(@"领券中心")},
                     @{@"img":@"mine_coupon",@"name":TransOutput(@"我的优惠券")},
                     @{@"img":@"mine_address",@"name":TransOutput(@"收货地址")},
                     @{@"img":@"组合 664",@"name":TransOutput(@"常见问题")},
                     @{@"img":@"组合 509",@"name":TransOutput(@"联系我们")},
                     @{@"img":@"mine_seeting",@"name":TransOutput(@"设置")},
                     @{@"img":@"mine_fx",@"name":TransOutput(@"相关协议")},
                     
                     @{@"img":@"mine_exit",@"name":TransOutput(@"退出登录")}
    ];
    
    [self.tableView reloadData];
   
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [NSString isNullStr:self.dataArr[indexPath.row][@"name"]];
    cell.ima.image = [UIImage imageNamed:self.dataArr[indexPath.row][@"img"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString isNullStr:self.dataArr[indexPath.row][@"name"]];
    if ([str isEqual:TransOutput(@"设置")]) {
        if (account.isLogin) {
            setViewController *vc = [[setViewController alloc] init];
            [self pushController:vc];
    }else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self pushController:vc];
    }
        
    }
    if ( [str isEqual:TransOutput(@"领券中心")]){
        
//        if (account.isLogin) {
            GouponCenterViewController *vc = [[GouponCenterViewController alloc] init];
            vc.titleArr = @[TransOutput(@"全部"),TransOutput(@"固定金额"),TransOutput(@"百分比"),TransOutput(@"满减")];
        vc.title = TransOutput(@"领券中心");
            [self pushController:vc];
//    }else{
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [self pushController:vc];
//    }
    }
    if ( [str isEqual:TransOutput(@"我的优惠券")]){
        
        if (account.isLogin) {
            GouponCenterViewController *vc = [[GouponCenterViewController alloc] init];
            vc.titleArr = @[TransOutput(@"未使用"),TransOutput(@"已使用"),TransOutput(@"已失效")];
            vc.title = TransOutput(@"我的优惠券");
            [self pushController:vc];
    }else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self pushController:vc];
    }
    }

    if ([str isEqual:TransOutput(@"常见问题")]) {
       
        askAndQuestionViewController *vc = [[askAndQuestionViewController alloc] init];
            [self pushController:vc];
        
    }
    if ([str isEqual:TransOutput(@"联系我们")]) {
        if (account.isLogin) {
            ContectUsViewController *vc = [[ContectUsViewController alloc] init];
            [self pushController:vc];
    }else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self pushController:vc];
    }
    
    }
    if ([str isEqual:TransOutput(@"商家入驻/我的店铺")]) {
        if (account.isLogin) {
            shopUserApplyViewController *vc = [[shopUserApplyViewController alloc] init];
            [self pushController:vc ];
        }else{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self pushController:vc];
        }
       
    }
    if ([str isEqual:TransOutput(@"相关协议")]) {
       
        xieyiViewController *vc = [[xieyiViewController alloc] init];
        [self pushController:vc];
    }
    if ([str isEqual:TransOutput(@"收货地址")]) {
        if (account.isLogin) {
        MyAddressViewController *vc = [[MyAddressViewController alloc] init];
        [self pushController:vc];
        }else{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self pushController:vc];
        }
    }
    @weakify(self)
    if ([str isEqual:TransOutput(@"退出登录")]) {
        if (account.isLogin) {
            
        
        CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"是否确定退出？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
            [Socket sharedSocketTool].isLogin = NO;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCollec" object:nil userInfo:nil];
            
            [account logout];
        } cancelBlock:^{
            
        }];
        [alert show];
        }else{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self pushController:vc];
        }
    }
    
    if ([str isEqual:TransOutput(@"注销账户")]) {
       
    }
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 442)];
        
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
