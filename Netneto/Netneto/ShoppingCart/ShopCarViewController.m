//
//  ShopCarViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/26.
//

#import "ShopCarViewController.h"

@interface ShopCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UILabel *hLabel;
@property(nonatomic, strong)NSMutableArray *selArr;
@property(nonatomic, strong)NSMutableArray *numArr;
@property(nonatomic, strong)UIButton *choseBtn;
@property(nonatomic, strong)UIButton *delBtn;
@property(nonatomic, strong)UIButton *returnBtnR;
@property(nonatomic, strong)UIView *viFoot;
@property(nonatomic, assign)BOOL isAllChose;
@property(nonatomic, assign)BOOL isDelChose;
@property (nonatomic, strong) NothingView *nothingView;
@property (nonatomic, strong) NSString *keyShow;
@property(nonatomic, assign)BOOL isShowTip;
@end

@implementation ShopCarViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        self.page = 1;
    
       self.selArr = [NSMutableArray array];
        [self loadData];
        [self getCarNumber];
    self.isShowTip = NO;
    self.keyShow = @"0";

    
}

-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"组合 1"];
        _nothingView.titleLabel.text = TransOutput(@"您还没有添加任何商品哦");
    }
    return _nothingView;
}

- (void)initData{
    
}
#pragma mark - 购物车数量
-(void)getCarNumber{
    
    [NetwortTool getGoodsNumberWithParm:@{} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",responseObject];
            if ([str isEqual:@"0"] ) {
                [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
            }else{
                [self.tabBarController.tabBar showBadgeOnItemIndex:2 tex:[NSString stringWithFormat:@"%@",responseObject]];
            }
        });
    } failure:^(NSError * _Nonnull error) {
        [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
    }];
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
  
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"购物车");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(99);
        make.bottom.mas_offset(-116);
        
    }];
    self.viFoot = [[UIView alloc] init];
    self.viFoot.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viFoot];
    [self.viFoot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_offset(0);
        make.height.mas_offset(116);
    }];
    
    [self.viFoot addSubview:self.delBtn];
    self.delBtn.hidden = YES;
    CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"删除") height:30 font:16];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12);
        make.right.mas_offset(-16);
        make.width.mas_offset(w + 30);
        make.height.mas_offset(30);
        
    }];
    self.choseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [self.choseBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
    [self.choseBtn setTitle:TransOutput(@"全选") forState:UIControlStateNormal];
    [self.choseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.choseBtn setTitleColor:RGB(0x585757) forState:UIControlStateNormal];
    [self.viFoot addSubview:self.choseBtn];
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_offset(16);
        make.height.mas_offset(15);
    }];
    [self.choseBtn addTarget:self action:@selector(AllChoseClick:) forControlEvents:UIControlEventTouchUpInside];
   self.hLabel = [[UILabel alloc] init];
    self.hLabel.textColor =RGB(0x585757);
    self.hLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.viFoot addSubview:self.hLabel];
    [self.hLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.top.mas_offset(16);
        make.height.mas_offset(16);
    }];
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = RGB(0xF9F9F9);
    [self.viFoot addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_offset(0);
        make.top.mas_offset(48);
        make.height.mas_offset(1);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:TransOutput(@"确认提交") forState:UIControlStateNormal];
    button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    button.layer.cornerRadius = 22;
    button.clipsToBounds = YES;
    [self.viFoot addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(15);
        make.top.mas_equalTo(line.mas_bottom).offset(14);
        make.height.mas_offset(44);
        make.trailing.mas_offset(-15);
    }];
    @weakify(self)
    [button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);

        [self sureSubmit];
    }];
    
    NSString *str = [NSString stringWithFormat:@"%@¥0",TransOutput(@"合计:")];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(str.length - 2, 2)];
    self.hLabel.attributedText = att;
    CGFloat rw = [Tool getLabelWidthWithText:TransOutput(@"取消管理") height:30 font:14];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - rw - 25, 45, rw +10, 30)];
   self.returnBtnR = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rw +10, 30)];
      [rightButtonView addSubview:self.returnBtnR];
    [self.returnBtnR setTitle:TransOutput(@"管理") forState:UIControlStateNormal];
    [self.returnBtnR setTitle:TransOutput(@"取消管理") forState:UIControlStateSelected];
    self.returnBtnR.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.returnBtnR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.returnBtnR addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
   UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 注册键盘将要消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
#pragma mark - 提交
-(void)sureSubmit{
            if (self.selArr.count >0) {
    
                
                if (!self.isShowTip) {
                    self.isShowTip = YES;
                    
                    NSDictionary *parm = @{@"basketIds":self.selArr,@"addrId":@"0",@"orderType":@"2"};
                    
                    [NetwortTool getIsCanCreateOrderWithParm:parm Success:^(id  _Nonnull responseObject) {
                        self.isShowTip = NO;
                        GoodsSureOrderViewController *vc = [[GoodsSureOrderViewController alloc] init];
                                vc.parm = parm;
                        
                          [self pushController:vc];
                    } failure:^(NSError * _Nonnull error) {
    
                        
                        CSQAlertView *alert = [[CSQAlertView alloc] initWithOtherTitle:TransOutput(@"提示") Message:error.userInfo[@"httpError"] btnTitle:TransOutput(@"确定") btnClick:^{
                            self.isShowTip = NO;
                            }];
                        @weakify(self);
                        [alert setHideBlock:^{
                            self.isShowTip = NO;
                        }];
                        [alert show];
                            
                        
                    }];
                }
               
    
            }else{
                ToastShow(TransOutput(@"请先选择产品"), errImg,RGB(0xFF830F));
            }
    
   
     
}
- (void)keyboardWillShow:(NSNotification *)notification {
    // 当键盘出现时，不要刷新tableView
//    self.tableView.refreshControl = nil;
    self.tableView.scrollEnabled = NO;
    self.keyShow = @"1";
}
 
- (void)keyboardWillHide:(NSNotification *)notification {
    // 当键盘隐藏时，可以根据需要恢复刷新tableView
    self.tableView.scrollEnabled = YES;
    self.keyShow = @"0";
 
}
 
-(UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.backgroundColor =[UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
        [_delBtn setTitle:TransOutput(@"删除") forState:UIControlStateNormal];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _delBtn.layer.cornerRadius = 15;
        _delBtn.clipsToBounds = YES;
        @weakify(self)
        [_delBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self)
        
            [self DelGoodsWithBasketId: [self.selArr componentsJoinedByString:@","]];
            self.selArr = [NSMutableArray array];
        }];
    }
    return _delBtn;
}
#pragma mark - 全选
-(void)AllChoseClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [self.choseBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
      
        self.isAllChose = YES;
        [self loadData];
     
    }
    else{
        sender.selected = NO;
        [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
      
        self.isAllChose = NO;
        [self loadData];

    }
}
#pragma mark - 编辑
-(void)editClick:(UIButton *)sender{
    if (self.numArr.count != 0) {
        if (!sender.selected) {
            sender.selected = YES;
            self.isDelChose = YES;
            [self.viFoot mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.isDetail.length > 0) {
                    make.height.mas_offset(76);
                }else{
                    make.height.mas_offset(56);
                }
            }];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.isDetail.length > 0) {
                    make.bottom.mas_offset(-76);
                }else{
                    make.bottom.mas_offset(-56);
                }
               
                
            }];
            
            self.hLabel.hidden = YES;
            self.delBtn.hidden = NO;
        }
        else{
            sender.selected = NO;
            self.isDelChose = NO;
            [self.viFoot mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_offset(116);
            }];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
              
                make.bottom.mas_offset(-116);
                
            }];
           
            self.hLabel.hidden = NO;
            self.delBtn.hidden = YES;
        }
        
        [self loadData];
    }
    
}
#pragma mark - 购物车数据
-(void)loadData{
    [NetwortTool getShopCartParm:@{} success:^(id  _Nonnull responseObject) {
      
        self.selArr = [NSMutableArray array];
        self.numArr = [NSMutableArray array];
        [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
        
        self.dataArr =responseObject;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        for (int i = 0; i < self.dataArr.count; i++) {
            NSArray *arr = self.dataArr[i][@"shopCartItemDiscounts"];
            NSArray *darr= arr.firstObject[@"shopCartItems"];
            for (int j = 0; j < darr.count; j++) {
                ShopCarModel *model = [[ShopCarModel alloc]initWithDic:darr[j]];
                [self.numArr addObject:model.basketId];
                
            }
        }
          if (self.isAllChose) {
              
              
              for (int i = 0; i < self.dataArr.count; i++) {
                  NSArray *arr = self.dataArr[i][@"shopCartItemDiscounts"];
                  NSArray *darr= arr.firstObject[@"shopCartItems"];
                  for (int j = 0; j < darr.count; j++) {
                      ShopCarModel *model = [[ShopCarModel alloc]initWithDic:darr[j]];
                      [self.selArr addObject:model.basketId];
                      
                  }
              }
              [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
              
             
           
          }else{
              [self.selArr removeAllObjects];
              [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
            
          }
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.tableView.backgroundView = self.nothingView;
          [self resetBtn];
         
      }
      else{
         
          self.tableView.backgroundView = nil;
      }
       
        
    } failure:^(NSError * _Nonnull error) {
        
        if ([error.userInfo[@"code"] isEqual:@"A00004"]) {
            self.dataArr = @[];
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            
          if (self.dataArr.count == 0) {
              self.tableView.backgroundView = self.nothingView;
             
          }
          else{
             
              self.tableView.backgroundView = nil;
          }
        }

        else{
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    
    
    }];
}
#pragma mark - 更新数据
-(void)updateData{
    [NetwortTool getShopCartParm:@{} success:^(id  _Nonnull responseObject) {
      
      
        self.dataArr =responseObject;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
       
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.tableView.backgroundView = self.nothingView;
          [self resetBtn];
         
      }
      else{
         
          self.tableView.backgroundView = nil;
      }
       
        
    } failure:^(NSError * _Nonnull error) {
        
        if ([error.userInfo[@"code"] isEqual:@"A00004"]) {
            self.dataArr = @[];
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
            
          if (self.dataArr.count == 0) {
              self.tableView.backgroundView = self.nothingView;
             
          }
          else{
             
              self.tableView.backgroundView = nil;
          }
        }

        else{
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    
    
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.dataArr[section][@"shopCartItemDiscounts"];
    NSArray *darr= arr.firstObject[@"shopCartItems"];
    return darr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    vi.backgroundColor = RGB(0xF9F9F9);
    UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 20, 20)];
    ima.image = [UIImage imageNamed:@"矢量 4"];
    [vi addSubview:ima];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, WIDTH - 56, 20)];
    label.text = [NSString isNullStr:self.dataArr[section][@"shopName"]];
    label.font = [UIFont boldSystemFontOfSize:12];
    [vi addSubview:label];
    
    
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell =[[ShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.dataArr[indexPath.section][@"shopCartItemDiscounts"];
    NSArray *darr= arr.firstObject[@"shopCartItems"];
    
    ShopCarModel *modelG = [[ShopCarModel alloc]initWithDic:darr[indexPath.row]];
    if (self.isAllChose) {
        modelG.selectedState = @(1);
    }
    if (self.isDelChose) {
        cell.delBtn.hidden = NO;
    }
    else{
        cell.delBtn.hidden = YES;
    }
    if ([self.selArr containsObject:modelG.basketId]) {
        modelG.selectedState = @(1);
    }
    modelG.prodCountSel = modelG.prodCount.integerValue;
    cell.goods = modelG;
    
    @weakify(self)
    cell.selectGoodsBlock = ^(BOOL isSelected, ShopCarModel * _Nonnull model) {
    
        NSLog(@"勾选状态: %d", isSelected);
        @strongify(self)
        if (isSelected) {
            if (![self.selArr containsObject:model.basketId]) {
                [self.selArr addObject:model.basketId];
            }
            
            NSLog(@"数量 %@，%@",self.selArr,self.numArr);
            
            if (self.selArr.count >= self.numArr.count) {
                
                NSLog(@"全选 %lu，%lu",(unsigned long)self.selArr.count,(unsigned long)self.numArr.count);
                self.isAllChose = YES;
                self.choseBtn.selected = YES;
                [self.choseBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
            }
            else{
                NSLog(@"未全选 %lu，%lu",(unsigned long)self.selArr.count,(unsigned long)self.numArr.count);
            }
        }else{
            self.isAllChose = NO;
            self.choseBtn.selected = NO;
            [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
            [self.selArr removeObject:model.basketId];
        }
        if (self.selArr.count == 0) {
            NSString *str = [NSString stringWithFormat:@"%@¥0",TransOutput(@"合计:")];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
            [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(str.length - 2, 2)];
            self.hLabel.attributedText = att;
        }else{
            [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
        }
    };
    cell.delBlock = ^(NSString * _Nonnull basketIds) {
        @strongify(self);
        [self DelGoodsWithBasketId:basketIds];
    };
    [cell setCustomNumberClickBlock:^(ShopCarModel * _Nonnull model, NSInteger quantity) {
        
        [self changeCusShopCounts:model num:quantity index:indexPath];
            
//        model.prodCountSel = quantity;
    }];
    [cell setUpdateNumberClickBlock:^(ShopCarModel * _Nonnull model, NSInteger quantity, NSInteger currentNumber) {
        

        NSLog(@"数量：%ld,%ld",quantity,currentNumber);
        [self changeShopCounts:model num:quantity - currentNumber index:indexPath];

    }];

      return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete; // 指定侧滑出现的按钮类型为删除
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 执行删除操作
        // 例如：[yourDataArray removeObjectAtIndex:indexPath.row];
        // 然后刷新tableView
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSArray *arr = self.dataArr[indexPath.section][@"shopCartItemDiscounts"];
        NSArray *darr= arr.firstObject[@"shopCartItems"];
        
        ShopCarModel *model = [[ShopCarModel alloc]initWithDic:darr[indexPath.row]];
     
        [self DelGoodsWithBasketId:model.basketId];
    }
}
 
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.keyShow isEqual:@"0"]) {
        return YES; // 允许所有行侧滑删除
    }
    else{
        return NO; // 不允许所有行侧滑删除
    }
}
#pragma mark - 改变数量
-(void)changeShopCounts:(ShopCarModel *)model num:(NSInteger)number index:(NSIndexPath *)indexPath{
    [HudView showHudForView:self.view];
    NSDictionary *parm = @{@"prodId":model.prodId,@"skuId":model.skuId,@"shopId":model.shopId,@"count":@(number),@"basketId":model.basketId};
    [NetwortTool getJoinShopCarWithParm:parm Success:^(id  _Nonnull responseObject) {
//        model.prodCount = responseObject[@"totalCount"];
        [HudView hideHudForView:self.view];
        if ([responseObject[@"totalCount"] intValue] > model.stocks.intValue) {
            ToastShow(TransOutput(@"已超过最大库存"),@"矢量 20",RGB(0xFF830F));
        }
        else{
            
 
            [self updateData];

        }
        NSLog(@"是否勾选：%@",model.selectedState);
        if ([model.selectedState isEqual: @(1) ]) {
            [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
   
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        
    }];
}
#pragma mark - 自定义商品数量
-(void)changeCusShopCounts:(ShopCarModel *)model num:(NSInteger)number index:(NSIndexPath *)indexPath{
    [HudView showHudForView:self.view];
    NSDictionary *parm = @{@"prodId":model.prodId,@"skuId":model.skuId,@"shopId":model.shopId,@"totalCount":@(number),@"count":@(0),@"basketId":model.basketId};
    [NetwortTool getJoinShopCarWithParm:parm Success:^(id  _Nonnull responseObject) {

        [HudView hideHudForView:self.view];
        
        if ([responseObject[@"totalCount"] intValue] > model.stocks.intValue) {
            ToastShow(TransOutput(@"已超过最大库存"),@"矢量 20",RGB(0xFF830F));
        }
        else{

            [self updateData];
        }
        NSLog(@"是否勾选：%@",model.selectedState);
        if ([model.selectedState isEqual: @(1) ]) {
            [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
   
        }
       
        
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));

        [self updateData];
    }];
}

#pragma mark - 删除
-(void)DelGoodsWithBasketId:(NSString *)str{
   
    [NetwortTool getDelGoodsWithParm:@{@"basketIds":str} Success:^(id  _Nonnull responseObject) {
        if (self.isAllChose) {
            [self resetBtn];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
        [self loadData];
        [self getCarNumber];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - 重置
-(void)resetBtn{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAllChose = NO;
        self.choseBtn.selected = NO;
        [self.choseBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
        self.returnBtnR.selected =NO;
        self.isDelChose = NO;
        [self.viFoot mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_offset(116);
        }];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
          
            make.bottom.mas_offset(-116);
            
        }];
        [self.tableView reloadData];
        self.hLabel.hidden = NO;
        self.delBtn.hidden = YES;
        [self calculationTotalPrice: [self.selArr componentsJoinedByString:@","]];
    });
}
#pragma mark - 合计
-(void)calculationTotalPrice:(NSString *)str{
    [HudView showHudForView:self.view];
    if (self.selArr.count == 0 ) {
        [HudView hideHudForView:self.view];
        NSString *strM = [NSString stringWithFormat:@"%@¥0",TransOutput(@"合计:")];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:strM];
        [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(strM.length - 2,2)];
        self.hLabel.attributedText = att;
    }else{
        [NetwortTool getShopTotalPriceWithParm:@{@"basketIds":str} Success:^(id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HudView hideHudForView:self.view];
                NSString *finalMoney = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"finalMoney"]];
                NSString *strM = [NSString stringWithFormat:@"%@¥%@",TransOutput(@"合计:"),[NSString ChangePriceStr:finalMoney]];
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:strM];
                [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(strM.length - [NSString ChangePriceStr:finalMoney].length - 1, [NSString ChangePriceStr:finalMoney].length + 1)];
                self.hLabel.attributedText = att;
            });
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *arr = self.dataArr[indexPath.section][@"shopCartItemDiscounts"];
    NSArray *darr= arr.firstObject[@"shopCartItems"];
    
    ShopCarModel *modelG = [[ShopCarModel alloc]initWithDic:darr[indexPath.row]];
 
    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
    vc.prodId = modelG.prodId;
    [self pushController:vc];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        

        @weakify(self)
        _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
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
