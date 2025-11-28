//
//  GoodsSureOrderViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/8.
//

#import "GoodsSureOrderViewController.h"
#import "PaymentView.h"
#import <SquareInAppPaymentsSDK/SQIPCardBrand.h>
#import <SquareInAppPaymentsSDK/SQIPCard.h>
@interface GoodsSureOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SQIPCardEntryViewControllerDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)OrderAddressView *addView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, strong)GoodsSureOrderView *footView;
@property(nonatomic, strong)PaymentView *paySureView;
@property(nonatomic, strong)NSString *orderNumber;
@property(nonatomic, assign)BOOL isPay;
@property(nonatomic, strong)NSMutableArray *quanIdArr;
@property(nonatomic, strong)NSString *userChangeCoupon;
@property(nonatomic, strong)NSString *actualTotal;
@property (nonatomic, strong) orderQuanView *quanView;
@end

@implementation GoodsSureOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isPay = NO;
    [self loadData];
}
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
    self.quanIdArr = [NSMutableArray array];
    self.userChangeCoupon = @"0";
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"确认订单");
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(14);
        make.trailing.mas_offset(-14);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(10);
        make.bottom.mas_offset(-70);
    }];
    [self.submitBtn setTitle:TransOutput(@"提交订单") forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    @weakify(self)
    [self.submitBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        if ([self.actualTotal intValue] >= 10000000) {
            ToastShow(TransOutput(@"订单金额超过￥10000000"),@"矢量 20",RGB(0xFF830F));
        }else{
                    [self.view addSubview: self.paySureView];
                    [self.paySureView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.trailing.top.bottom.mas_offset(0);
                    }];
            
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadAddOrder" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        NSString *value = [NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"addId"]];
        if ([[self.parm allKeys] containsObject:@"orderItem"]) {
            self.parm = @{@"basketIds":self.parm[@"basketIds"],@"addrId":value,@"orderItem":self.parm[@"orderItem"],@"orderType":@"2",@"couponIds":self.quanIdArr};
        }
        else{
            self.parm = @{@"basketIds":self.parm[@"basketIds"],@"addrId":value,@"orderType":@"2",@"couponIds":self.quanIdArr};
        
        }
       
        [self loadData];
        NSLog(@"%@", value);
    }];
     
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 提交订单
-(void)submitOrder{
    NSMutableArray *shopArr = [NSMutableArray array];
    NSArray *cells = [self.tableView visibleCells];
    for (int i = 0; i < cells.count; i++) {
        GoodsSureOrderTableViewCell *cell  =cells[i];
        NSDictionary *dic = @{@"shopId":self.dataArr[i][@"shopId"],@"remarks":[NSString isNullStr:cell.tx.text]};
        [shopArr addObject:dic];
    }
    
    [NetwortTool getOrderSubmitPayWithParm:@{@"orderShopParam":shopArr} Success:^(id  _Nonnull responseObject) {
        self.orderNumber = responseObject[@"orderNumbers"];
        [self.paySureView removeFromSuperview];
        [self pushPay];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
#pragma mark-结算 生成订单
-(void)loadData{
    if (self.quanIdArr.count > 0) {
        NSMutableArray *tem = [self.quanIdArr mutableCopy];
        
        for ( NSString *str in self.quanIdArr ) {
           
            if ([str isEqual:@"00"]) {
                [tem removeObject:str];
            }
            
        }
        self.quanIdArr = tem;
    }
    if ([[self.parm allKeys] containsObject:@"orderItem"]) {
        self.parm = @{@"basketIds":self.parm[@"basketIds"],@"addrId":self.parm[@"addrId"],@"orderItem":self.parm[@"orderItem"],@"orderType":@"2",@"couponIds":self.quanIdArr,@"userChangeCoupon":self.userChangeCoupon};
    }
    else{
        self.parm = @{@"basketIds":self.parm[@"basketIds"],@"addrId":self.parm[@"addrId"],@"orderType":@"2",@"couponIds":self.quanIdArr,@"userChangeCoupon":self.userChangeCoupon};
    
    }
    
    [NetwortTool getCreateOrderWithParm:self.parm Success:^(id  _Nonnull responseObject) {
        NSLog(@"订单信息：%@",responseObject);
        self.actualTotal = [NSString stringWithFormat:@"%@",responseObject[@"actualTotal"]];
        self.dataArr =responseObject[@"shopCartOrders"];
        [self.quanIdArr removeAllObjects];
        for (int i = 0; i < self.dataArr.count; i++) {
            NSDictionary *dataDic = self.dataArr[i];
            if ([dataDic[@"coupon"] isKindOfClass:[NSDictionary class]]) {
                [self.quanIdArr addObject:[NSString stringWithFormat:@"%@",dataDic[@"coupon"][@"couponId"]]];
            }
            else{
                [self.quanIdArr addObject:@"00"];
            }
        }
        CGFloat addH = 80;
        addressModel *addModel = [addressModel mj_objectWithKeyValues:responseObject[@"userAddr"]];
     
        if (addModel.province.length == 0) {
            self.addView.addAdsBtn.hidden =NO;
            [self.addView.addAdsBtn setTitle:TransOutput(@"请先添加地址！") forState:UIControlStateNormal];
            [self.addView.addAdsBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
            [self.addView.addAdsBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
            @weakify(self);
            [self.addView.addAdsBtn addTapAction:^(UIView * _Nonnull view) {
                @strongify(self);
                AddAddressViewController *vc = [[AddAddressViewController alloc] init];
                [self pushViewController:vc];
            }];
        }else{
            self.addView.addAdsBtn.hidden =YES;
            
            NSString *code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:addModel.postCode] substringToIndex:3],[[NSString isNullStr:addModel.postCode] substringFromIndex:3]];
       
            NSString *addStr = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:addModel.province],[NSString isNullStr:addModel.city],[NSString isNullStr:addModel.area],[NSString isNullStr:addModel.addr]];
            
            CGFloat h = [Tool getLabelHeightWithText:addStr width:WIDTH - 32-28 font:12];
            addH = h + 26 + 28 + 14;
    
            self.addView.addrmodel = addModel;
            @weakify(self);
            [self.addView addTapAction:^(UIView * _Nonnull view) {
                @strongify(self);
                MyAddressViewController *vc = [[MyAddressViewController alloc] init];
                vc.isOrder = YES;
                [self pushViewController:vc];
            }];
        }
       
        self.addView.frame = CGRectMake(14, 6, WIDTH - 28, addH);
        self.tableView.tableHeaderView = self.addView;
        CGFloat peiH = [Tool getLabelHeightWithText:TransOutput(@"配送策略和退货·取消时的退款策略，在本公司的服务利用规章中，以简单能理解的形式记载着。") width:WIDTH -48 font:12];
        self.footView.frame = CGRectMake(0, 0, WIDTH - 28, 324 + peiH);
       
        [self.footView updataWithDic:responseObject];
        self.tableView.tableFooterView = self.footView;
        
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsSureOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[GoodsSureOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.dataDic = self.dataArr[indexPath.row];
    @weakify(self);
    [cell setCouponClickBlock:^(NSArray * _Nonnull arr, NSDictionary * _Nonnull dataDic) {
    
        @strongify(self);
        [self showCouponView:arr dic:dataDic index:indexPath.row];
    }];
    return cell;
}
#pragma mark - 展示领券View
-(void)showCouponView:(NSArray *)arr dic:(NSDictionary *)daraDic index:(NSInteger)index{
    self.quanView.dataArray =[NSMutableArray arrayWithArray:arr] ;
    if([daraDic allKeys].count > 0){
        self.quanView.selCouponId = [NSString stringWithFormat:@"%@",daraDic[@"couponId"]];
    }
    else{
        self.quanView.selCouponId = @"";
    }
                [self.view addSubview:self.quanView];
                [self.quanView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.leading.top.trailing.bottom.mas_offset(0);
                              }];
    @weakify(self);
    [self.quanView setSureBlock:^(NSArray * _Nonnull couponIdArr) {
      @strongify(self);
        self.userChangeCoupon = @"1";
        [self.quanView removeFromSuperview];
        if (couponIdArr.count == 0) {
            [self.quanIdArr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"00"]];
        }
        else{
            [self.quanIdArr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@",couponIdArr[0]]];
        }
        [self loadData];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrs =self.dataArr[indexPath.row][@"shopCartItemDiscounts"];
    NSArray *item = arrs.firstObject[@"shopCartItems"];
    NSDictionary  *dataDic = self.dataArr[indexPath.row];
    if ([dataDic[@"coupons"] count] > 0) {
        return item.count * 98 +120 + 15 + 50;
    }
    return item.count * 98 +120 + 15;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}
-(OrderAddressView *)addView{
    if (!_addView) {
        _addView = [OrderAddressView initViewNIB];
        _addView.layer.cornerRadius = 5;
        _addView.clipsToBounds = YES;
    }
    return _addView;
}
-(GoodsSureOrderView *)footView{
    if (!_footView) {
        _footView = [GoodsSureOrderView initViewNIB];
        _footView.backgroundColor = [UIColor clearColor];
        _footView.layer.cornerRadius = 5;
        _footView.clipsToBounds = YES;
        @weakify(self);
        [_footView setPeiClickBlock:^{
            @strongify(self);
            MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
             vc.url = @"https://netneto.com/delivery_policy_more.html";
           
            [self pushController:vc];
        }];
        [_footView setTuiClickBlock:^{
            @strongify(self);
            MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
           
           
                vc.url = @"https://netneto.com/refund_policy_more.html";
     
            [self pushController:vc];
        }];
    }
    return _footView;
}
-(PaymentView *)paySureView{
    if (!_paySureView) {
        _paySureView = [PaymentView initViewNIB];
        _paySureView.backgroundColor = [UIColor clearColor];
        @weakify(self);
        [_paySureView setNextBlock:^{
            @strongify(self);
            [self submitOrder];
           
        }];

    }
    return _paySureView;
}
-(orderQuanView *)quanView{
        if (!_quanView) {
            _quanView = [orderQuanView initViewNIB];
            _quanView.backgroundColor = [UIColor clearColor];

        }
        return _quanView;
}
#pragma mark - 支付
-(void)pushPay{
    SQIPTheme *them = [[SQIPTheme alloc] init];
    them.errorColor = [UIColor redColor];
    them.tintColor = [UIColor cyl_linkColor];
    them.saveButtonTitle = TransOutput(@"保存");
    them.keyboardAppearance = UIKeyboardAppearanceLight;
    SQIPCardEntryViewController *vc = [[SQIPCardEntryViewController alloc] initWithTheme:them];
    vc.collectPostalCode = NO;
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status{
    NSLog(@"支付结果：%lu",(unsigned long)status);
    if (self.isPay ) {

    }else{
        ToastShow(TransOutput(@"支付取消"), errImg,RGB(0xFF830F));
        [self dismissViewController:YES];
         [self popViewControllerAnimate];
    }

    

}
-(void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didObtainCardDetails:(SQIPCardDetails *)cardDetails completionHandler:(void (^)(NSError * _Nullable))completionHandler
{
    
    SQIPCard *card = cardDetails.card;
    SQIPCardBrand brand =  card.brand;
    NSString *cardAbbreviation = @"";
    if (brand == SQIPCardBrandOtherBrand) {
        cardAbbreviation = @"OTHER_BRAND";
        
    }
    if (brand == SQIPCardBrandVisa) {
        cardAbbreviation = @"VISA";
        
    }
    
    if (brand == SQIPCardBrandMastercard) {
        cardAbbreviation = @"MASTERCARD";
        
    }
    if (brand == SQIPCardBrandAmericanExpress) {
        cardAbbreviation = @"AMERICAN_EXPRESS";
        
    }
    if (brand == SQIPCardBrandDiscover) {
        cardAbbreviation = @"DISCOVER";
        
    }
    
    if (brand == SQIPCardBrandDiscoverDiners) {
        cardAbbreviation = @"DISCOVER_DINERS";
        
    }
    if (brand == SQIPCardBrandJCB) {
        cardAbbreviation = @"JCB";
        
    }
    if (brand == SQIPCardBrandChinaUnionPay) {
        cardAbbreviation = @"CHINA_UNION_PAY";
        
    }
    if (brand == SQIPCardBrandSquareGiftCard) {
        cardAbbreviation = @"SQUARE_GIFT_CARD";
        
    }
    
    NSString *hFNumber = card.lastFourDigits;
    NSUInteger MonthNumber = card.expirationMonth;
    NSUInteger YearNumber = card.expirationYear;
    
    [NetwortTool getSquarePayWithParm:@{@"orderNumbers":self.orderNumber,@"token":[NSString stringWithFormat:@"%@",cardDetails.nonce],@"cardtypeValues":cardAbbreviation,@"cardNumber":hFNumber} Success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            self.isPay = YES;
            ToastShow(TransOutput(@"支付成功"), @"chenggong",RGB(0x36D053));
            [self dismissViewController:YES];
            [self popViewControllerAnimate];
 
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];

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
