//
//  GouponCenterChildViewController.m
//  Netneto
//
//  Created by apple on 2025/1/16.
//

#import "GouponCenterChildViewController.h"

@interface GouponCenterChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *indexPathArr;
@property(nonatomic, strong)NSMutableArray *indexPathArrRea;
@property(nonatomic, assign)NSInteger page;
@property (nonatomic, strong) NothingView *nothingView;

@end

@implementation GouponCenterChildViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    self.indexPathArr = [NSMutableArray array];
    self.indexPathArrRea = [NSMutableArray array];
    [self loadData];
}
-(void)CreateView{
    
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updataCoupon" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{

            self.page = 1;
            
            [self loadData];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadCouponChild" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        NSString *value = [notification.userInfo objectForKey:@"searchText"];
        self.page = 1;
        self.searchStr = value;
        [self loadData];
        NSLog(@"%@", value);
    }];
    
}

-(void)loadData{
    if ([self.type isEqual:@"1"]) {
        NSString *couponType = @"-1";
        if ([self.titleStr isEqual:TransOutput(@"固定金额")]) {
            couponType = @"0";
        }
        if ([self.titleStr isEqual:TransOutput(@"百分比")]) {
            couponType = @"1";
        }
        if ([self.titleStr isEqual:TransOutput(@"满减")]) {
            couponType = @"2";
        }
        NSString *userId = @"";
        if (account.isLogin) {
            userId =account.userInfo.userId;
        }
        NSDictionary *parm = @{@"userId":userId,@"couponType":couponType,@"size":@10,@"current":@(self.page),@"queryParam":self.searchStr};
        [NetwortTool getCouponListWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSLog(@"输出优惠券数据:%@",responseObject);
           
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            for (int i = 0; i <arr.count; i++) {
                GouponModel *model = [GouponModel mj_objectWithKeyValues:arr[i]];
                model.SelType = 0;
                
                [self.dataArray addObject:model];
            }

            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.nothingView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - 460 -150);
            self.nothingView.topCustom.constant = 80;
            if (self.dataArray.count == 0) {
                self.tableView.backgroundView = self.nothingView;
            }
            else{
                self.tableView.backgroundView = nil;
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    else{
        NSString *couponType;
        if ([self.titleStr isEqual:TransOutput(@"未使用")]) {
            couponType = @"0";
        }
        if ([self.titleStr isEqual:TransOutput(@"已使用")]) {
            couponType = @"1";
        }
        if ([self.titleStr isEqual:TransOutput(@"已失效")]) {
            couponType = @"2";
        }
        
        NSDictionary *parm = @{@"couponType":couponType,@"size":@10,@"current":@(self.page),@"queryParam":self.searchStr};
        [NetwortTool getMyCouponListWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSLog(@"输出我的优惠券数据:%@",responseObject);
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                GouponModel *model = [GouponModel mj_objectWithKeyValues:arr[i]];
                model.SelType = 0;
                [self.dataArray addObject:model];
            }
//            [self.dataArray addObjectsFromArray:arr];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            self.nothingView.topCustom.constant = 80;
            if (self.dataArray.count == 0) {
                self.tableView.backgroundView = self.nothingView;
            }
            else{
                self.tableView.backgroundView = nil;
            }
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }
    
    
    
    
   
    
//    [self.tableView reloadData];
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        if ([self.rootTitleStr isEqual:TransOutput(@"我的优惠券")]) {
          
            if ([self.titleStr isEqual:TransOutput(@"未使用")]) {
                _nothingView.titleLabel.text = TransOutput(@"我的优惠券暂无数据未使用");
            }
            if ([self.titleStr isEqual:TransOutput(@"已使用")]) {
                _nothingView.titleLabel.text = TransOutput(@"我的优惠券暂无数据已使用");
                _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
            }
            if ([self.titleStr isEqual:TransOutput(@"已失效")]) {
                _nothingView.titleLabel.text = TransOutput(@"我的优惠券暂无数据已失效");
                _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
            }
        
        }else{
            _nothingView.titleLabel.text = TransOutput(@"领券中心暂无数据");
            _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        
    }
    return _nothingView;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GouponChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GouponChildTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"GouponChildTableViewCell" owner:self options:nil].lastObject;
    }

    GouponModel *model =self.dataArray[indexPath.row];
    if ([self.titleStr isEqual:TransOutput(@"已使用")] || [self.titleStr isEqual:TransOutput(@"已失效")]) {
        cell.img1.image = [UIImage imageNamed:@"矩形 5127-3"];
        cell.img2.image = [UIImage imageNamed:@"矩形 5147"];
        cell.nameLabel.textColor = RGB(0xACABAB);
        cell.title.textColor = RGB(0xACABAB);
        cell.timeLabel.textColor = RGB(0xACABAB);
        cell.lingBtn.backgroundColor = [UIColor whiteColor];
        cell.lingBtn.layer.borderColor = RGB(0xACABAB).CGColor;
        cell.lingBtn.layer.borderWidth = 1;
        [cell.lingBtn setTitleColor:RGB(0xACABAB) forState:UIControlStateNormal];
        if ([self.titleStr isEqual:TransOutput(@"已失效")] ) {
            if (model.disableStatus == 0) {
                [cell.lingBtn setTitle:self.titleStr forState:UIControlStateNormal];
            }else{
                [cell.lingBtn setTitle:TransOutput(@"早期终了") forState:UIControlStateNormal];
            }
        }
        else{
            [cell.lingBtn setTitle:self.titleStr forState:UIControlStateNormal];
  
        }
    }
    else{
        cell.img1.image = [UIImage imageNamed:@"矩形 5127-2"];
        cell.img2.image = [UIImage imageNamed:@"矩形 5128-2"];
        cell.nameLabel.textColor = RGB(0xFF3344);
        cell.title.textColor = RGB(0x333333);
        cell.timeLabel.textColor = RGB(0xFF3344);
        
        if ([self.titleStr isEqual:TransOutput(@"未使用")]){
            cell.lingBtn.backgroundColor = [UIColor whiteColor];
            cell.lingBtn.layer.borderColor = RGB(0xFF3344).CGColor;
            cell.lingBtn.layer.borderWidth = 1;
            [cell.lingBtn setTitleColor:RGB(0xFF3344) forState:UIControlStateNormal];
            [cell.lingBtn setTitle:TransOutput(@"去使用") forState:UIControlStateNormal];
            cell.lingBtn.tag = indexPath.row;
            [cell.lingBtn addTarget:self action:@selector(CouponUseClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            if (model.isReceive == 0) {
                cell.lingBtn.backgroundColor = RGB(0xFF3344);
                cell.lingBtn.layer.borderColor = [UIColor clearColor].CGColor;
                cell.lingBtn.layer.borderWidth = 0;
                [cell.lingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.lingBtn setTitle:TransOutput(@"立即领取") forState:UIControlStateNormal];
                cell.lingBtn.tag = indexPath.row;
                [cell.lingBtn addTarget:self action:@selector(lingCouponClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.lingBtn.backgroundColor = [UIColor whiteColor];
                cell.lingBtn.layer.borderColor = RGB(0xFF3344).CGColor;
                cell.lingBtn.layer.borderWidth = 1;
                [cell.lingBtn setTitleColor:RGB(0xFF3344) forState:UIControlStateNormal];
                
                [cell.lingBtn setTitle:TransOutput(@"已领取") forState:UIControlStateNormal];
            }
            
        }
    }
    if ([self.titleStr isEqual:TransOutput(@"已失效")]) {
        
        if (model.disableStatus == 0) {
            cell.resonBtn.hidden = YES;
        }
        else{
            cell.resonBtn.hidden = NO;
        }
    }else{
        cell.resonBtn.hidden = YES;
    }
    NSString *price = [NSString ChangePriceStr:[NSString stringWithFormat:@"%ld",(long)model.value]];
    if (model.type == 2) {

        NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,TransOutput(@"元")];
        cell.nameLabel.text = str;
    }
  else  if (model.type == 0) {
      NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,TransOutput(@"元")];
        cell.nameLabel.text =str;
      
    }
    
  else{
      NSString *str = [NSString stringWithFormat:@"%@%@\n引き",price,@"%"];
      cell.nameLabel.text =str;

  }
    
    
    
    
    
    
    cell.title.text = model.name;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@%@",model.endTime,TransOutput(@"到期")];
    if(model.couponStatus == 0){
        cell.shopNameLabel.text =[NSString stringWithFormat:@"%@(%@)",model.shopName,TransOutput(@"所有商品")];
    }else{
        cell.shopNameLabel.text =[NSString stringWithFormat:@"%@(%@)",model.shopName,TransOutput(@"部分商品")];
    }
    
    
    if (model.SelType == 1) {
        cell.desLabel.text =model.des;
        [cell.resonBtn setTitle:TransOutput(@"早期终了理由") forState:UIControlStateNormal];
        [cell.resonBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
        [cell.resonBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
        if ([_indexPathArr containsObject:indexPath]) {
            cell.induceView.hidden = YES;
            [cell openCell:YES];
            [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
            [cell.indureBtn setImage:[UIImage imageNamed:@"path-29"] forState:UIControlStateNormal];
            [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
        }else {
            cell.induceView.hidden = YES;
            [cell openCell:NO];
            [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
            [cell.indureBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
            [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
        }
    }
   else if (model.SelType == 2) {
       cell.desLabel.text =model.disableMsg;
       [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
       [cell.indureBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
       [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
        if ([_indexPathArrRea containsObject:indexPath]) {
            cell.induceView.hidden = YES;
            [cell openCellReson:YES];
            [cell.resonBtn setTitle:TransOutput(@"早期终了理由") forState:UIControlStateNormal];
            [cell.resonBtn setImage:[UIImage imageNamed:@"path-29"] forState:UIControlStateNormal];
            [cell.resonBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
        }else {
            cell.induceView.hidden = YES;
            [cell openCellReson:NO];
            [cell.resonBtn setTitle:TransOutput(@"早期终了理由") forState:UIControlStateNormal];
            [cell.resonBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
            [cell.resonBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
        }
    }
   else{
       cell.induceView.hidden = YES;
       
       [cell.resonBtn setTitle:TransOutput(@"早期终了理由") forState:UIControlStateNormal];
       [cell.resonBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
       [cell.resonBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
       
       [cell.indureBtn setTitle:TransOutput(@"使用说明") forState:UIControlStateNormal];
       [cell.indureBtn setImage:[UIImage imageNamed:@"path-28"] forState:UIControlStateNormal];
       [cell.indureBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:5];
   }
    
    __block UITableView *tempTable = _tableView;
       __block NSIndexPath *tempIndexPath = indexPath;
    @weakify(self);
       cell.moreInfo = ^(BOOL open){
           @strongify(self);
           model.SelType = 1;
          
           if ([self.indexPathArrRea containsObject:tempIndexPath]) {
               [self.indexPathArrRea removeObject:tempIndexPath];
           }
           if (open) {
               [self.indexPathArr addObject:tempIndexPath];
           }else
           {
               [self.indexPathArr removeObject:tempIndexPath];
           }
           [tempTable reloadData];
       };
      cell.moreInfoReson = ^(BOOL open){
          @strongify(self);
          model.SelType = 2;
         
          if ([self.indexPathArr containsObject:tempIndexPath]) {
              [self.indexPathArr removeObject:tempIndexPath];
          }
          if (open) {
              [self.indexPathArrRea addObject:tempIndexPath];
          }else
          {
              [self.indexPathArrRea removeObject:tempIndexPath];
          }
          [tempTable reloadData];
      };
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
#pragma mark - 立即使用跳转
-(void)CouponUseClick:(UIButton *)sender{

    GouponModel *model =self.dataArray[sender.tag];
    HomeShopViewControll *vc = [[HomeShopViewControll alloc] init];
    vc.shopId = model.shopId;
    [self pushController:vc];
}
#pragma mark - 立即领取优惠券
-(void)lingCouponClick:(UIButton *)sender{
    if (!account.isLogin) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self pushController:vc];
        
    }else{
        GouponModel *model =self.dataArray[sender.tag];
        
        [NetwortTool getCouponsWithParm:@{@"couponId":@(model.couponId)} Success:^(id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ToastShow(TransOutput(@"领取成功"), @"chenggong", RGB(0x36D053));
              
                [self.dataArray removeObjectAtIndex:sender.tag];
                [self.tableView reloadData];
                if (self.dataArray.count == 0) {
                    self.tableView.backgroundView = self.nothingView;
                }
                else{
                    self.tableView.backgroundView = nil;
                }
            });
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    GouponModel *model =self.dataArray[indexPath.row];
    NSString *des = @"";
    if (model.SelType == 1) {
        des = model.des;
    }
    else if (model.SelType == 2){
        des = model.disableMsg;
    }
    
    if ([_indexPathArr containsObject:indexPath]) {
        
        CGFloat h = [Tool getLabelHeightWithText:des width:WIDTH - 58 font:8];
        
        return 120 + h;
    }else if ([_indexPathArrRea containsObject:indexPath]) {
        
        
        CGFloat h = [Tool getLabelHeightWithText:des width:WIDTH - 58 font:8];
        
        return 120 + h;
    } else{
        return 93;
    }
    
    
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
