//
//  OrderDetailViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "OrderDetailViewController.h"
#import <SquareInAppPaymentsSDK/SQIPCardBrand.h>
#import <SquareInAppPaymentsSDK/SQIPCard.h>
@interface OrderDetailViewController ()<SQIPCardEntryViewControllerDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)OrderAddressView *addView;
@property(nonatomic, strong)OrderDetailModel *orderdetailModel;
@property(nonatomic, strong)OrderDetailInfoFootView *footView;
@end

@implementation OrderDetailViewController
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
    self.navigationItem.title = TransOutput(@"订单详情");
    CGFloat bottomH = 60;
//    switch ([self.staus intValue]) {
//        case 1:
//            bottomH = 124;
//            break;
//        case 2:
//            bottomH = 60;
//            break;
//        case 3:
//            bottomH = 154;
//            break;
//        case 5:
//            bottomH = 60;
//            break;
//        default:
//            break;
//    }
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 109, WIDTH, HEIGHT - 109 - bottomH)];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addView];
    
    self.footView = [[OrderDetailInfoFootView alloc] init];
    
    [self.view addSubview:self.footView];
    @weakify(self);
    [self.footView setSurePayClickBlock:^{
     //确认支付
        @strongify(self);
        [self pushPay];
    }];
    [self.footView setCancelPayClickBlock:^{
       //取消订单
        @strongify(self);
        [self cancelOrder];
    }];
    
    [self.footView setSureRevClickBlock:^{
        @strongify(self);
       //确认收货
        [self sureRec];
    }];
    [self.footView setCheckWuClickBlock:^{
        @strongify(self);
        CheckWuLiuViewController *vc = [[CheckWuLiuViewController alloc] init];
        vc.orderNumber = self.orderNumber;
        [self pushController:vc];
       //查看物流
    }];
    
//
}
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
    [self dismissViewController:YES];
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
            ToastShow(TransOutput(@"支付成功"), @"chenggong",RGB(0x36D053));
            [self dismissViewController:YES];
            [self popViewControllerAnimate];
        }
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
//    cardDetails.nonce
}
-(void)cancelOrder{
    [NetwortTool getCancelOrderWithParm:self.orderNumber Success:^(id  _Nonnull responseObject) {
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadData" object:nil userInfo:@{@"orderNumber":self.orderNumber}];
        
        ToastShow(TransOutput(@"取消成功"), @"chenggong",  RGB(0x36D053));
        [self popViewControllerAnimate];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)sureRec{
    [NetwortTool getSureRecWithParm:self.orderNumber Success:^(id  _Nonnull responseObject) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadData" object:nil userInfo:@{@"orderNumber":self.orderNumber}];
        ToastShow(TransOutput(@"确认收货成功"), @"chenggong", RGB(0x36D053));
        [self popViewControllerAnimate];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)GetData{
    [HudView showHudForView:self.view];
    
    [NetwortTool getOrderDetailWithParm:@{@"orderNumber":self.orderNumber} Success:^(id  _Nonnull responseObject) {
        self.orderdetailModel = [OrderDetailModel mj_objectWithKeyValues:responseObject];
        self.addView.detailmodel = self.orderdetailModel;
        self.footView.status =[NSString stringWithFormat:@"%@",self.orderdetailModel.status] ;
        self.footView.model = self.orderdetailModel;
        CGFloat bottomH = 60;
        switch ([self.orderdetailModel.status intValue]) {
            case 1:
                bottomH = 124;
                break;
            case 2:
                bottomH = 60;
                break;
            case 3:
                bottomH = 154;
                break;
            case 5:
                bottomH = 60;
                break;
            default:
                break;
        }
        self.scrollView.frame = CGRectMake(0, 109, WIDTH, HEIGHT - 109 - bottomH);
        self.footView.frame = CGRectMake(0, HEIGHT - bottomH, WIDTH, bottomH);
        NSString *code;
        NSString *addStr;
        if ([[NSString isNullStr:self.orderdetailModel.userAddrDto[@"postCode"]] length] == 0) {
            code = @"";
            addStr = [NSString stringWithFormat:@"%@%@%@%@",[NSString isNullStr:self.orderdetailModel.userAddrDto[@"province"]],[NSString isNullStr:self.orderdetailModel.userAddrDto[@"city"]],[NSString isNullStr:self.orderdetailModel.userAddrDto[@"area"]],[NSString isNullStr:self.orderdetailModel.userAddrDto[@"addr"]]];
           
        }else{
            code = [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:self.orderdetailModel.userAddrDto[@"postCode"]] substringToIndex:3],[[NSString isNullStr:self.orderdetailModel.userAddrDto[@"postCode"]] substringFromIndex:3]];
            addStr = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:self.orderdetailModel.userAddrDto[@"province"]],[NSString isNullStr:self.orderdetailModel.userAddrDto[@"city"]],[NSString isNullStr:self.orderdetailModel.userAddrDto[@"area"]],[NSString isNullStr:self.orderdetailModel.userAddrDto[@"addr"]]];
            
        }
        
        
        CGFloat h = [Tool getLabelHeightWithText:addStr width:WIDTH - 32-28 font:12];
        CGFloat scroH = 6;
        CGFloat addH = h + 26 + 28 + 14;
        CGFloat proItemH = self.orderdetailModel.orderItemDtos.count * 98;
        if ([self.orderdetailModel.status intValue] == 5 || [self.orderdetailModel.status intValue] == 3 || [self.orderdetailModel.status intValue] == 2) {
            if (![self.orderdetailModel.refundSts isEqual:@"1"]) {
           
            UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(14, 15, WIDTH - 28, 68)];
            cardView.backgroundColor = [UIColor whiteColor];
            cardView.layer.cornerRadius = 5;
            cardView.layer.borderColor = RGB(0xE1E1E1).CGColor;
            cardView.layer.borderWidth = 0.5;
            [self.scrollView addSubview:cardView];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 16, WIDTH - 28, 36);
            [button setImage:[UIImage imageNamed:@"组合 485"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%@",TransOutput(@"レシート確認")] forState:UIControlStateNormal];
            [button setTitleColor:RGB(0x000000) forState:UIControlStateNormal];
            [button layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:11];
            [cardView addSubview:button];
            @weakify(self)
            [cardView addTapAction:^(UIView * _Nonnull view) {
                @strongify(self)
                PaySuccessViewController *vc = [[PaySuccessViewController alloc] init];
                vc.orderNumber = self.orderNumber;
                [self pushViewController:vc];
              
            }];
            [button addTapAction:^(UIView * _Nonnull view) {
                @strongify(self)
                PaySuccessViewController *vc = [[PaySuccessViewController alloc] init];
                vc.orderNumber = self.orderNumber;
                [self pushViewController:vc];
            
            }];
                
                self.addView.frame = CGRectMake(14, cardView.bottom + 13, WIDTH - 28, addH);
      
            }else{
                self.addView.frame = CGRectMake(14, 6, WIDTH - 28, addH);
                     }
        }
        else{
            self.addView.frame = CGRectMake(14, 6, WIDTH - 28, addH);
           
        }
        UIView *itemBgView = [[UIView alloc] initWithFrame:CGRectMake(14, self.addView.bottom + 12, WIDTH - 28, proItemH)];
        itemBgView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:itemBgView];
        
        for (int i = 0 ; i <self.orderdetailModel.orderItemDtos.count; i++) {
            OrderModel *itemModel = [OrderModel mj_objectWithKeyValues:self.orderdetailModel.orderItemDtos[i]];
            MineOrderItemView *vi = [MineOrderItemView initViewNIB];
            //        vi.frame = CGRectMake(0, 98 * i, WIDTH - 32, 98);
            vi.isDetail = YES;
            vi.status = self.orderdetailModel.status;
            
            vi.model = itemModel;
            
            vi.layer.cornerRadius = 5;
            vi.clipsToBounds = YES;
            vi.layer.borderColor = RGB(0xE1E1E1).CGColor;
            vi.layer.borderWidth = 0.5;
            [itemBgView addSubview:vi];
            [vi mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_offset(0);
                make.height.mas_offset(98);
                make.top.mas_offset(98 * i);
            }];
        }
        
        
        UIView *hejiView = [[UIView alloc] initWithFrame:CGRectMake(14, itemBgView.bottom + 12, WIDTH - 24, 33)];
        hejiView.backgroundColor = RGB(0xFDF2E6);
        hejiView.layer.cornerRadius = 5;
        hejiView.clipsToBounds = YES;
        hejiView.layer.borderColor = RGB(0xF9B151).CGColor;
        hejiView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:hejiView];
        NSString *heStr = [NSString stringWithFormat:@"%@%@%@",TransOutput(@"共计"),self.orderdetailModel.totalNum,TransOutput(@"件商品")];
        CGFloat heW = [Tool getLabelWidthWithText:heStr height:33 font:12];
        NSString *price2 =[NSString ChangePriceStr:self.orderdetailModel.total];
        NSString *heStr2 = [NSString stringWithFormat:@"%@：¥%@",TransOutput(@"合计"),price2];
        
        CGFloat heW2 = [Tool getLabelWidthWithText:heStr2 height:33 font:16];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, heW, 33)];
        label.text = heStr;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGB(0x4C4C4C);
        [hejiView addSubview:label];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(hejiView.x + hejiView.width - heW2 - 14 , 0, heW2, 33)];
        label2.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:heStr2];
        [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402),NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} range:NSMakeRange(heStr2.length - price2.length - 1, price2.length + 1)];
        label2.attributedText = att;
        [hejiView addSubview:label2];
        
        OrderDetailInfoView *priceView = [OrderDetailInfoView initViewNIB];
        
        priceView.frame = CGRectMake(14, hejiView.bottom + 12, WIDTH - 28, 120 + 33);
        priceView.titleStr = TransOutput(@"订单价格");
        priceView.model = self.orderdetailModel;
        priceView.orderNumber = self.orderNumber;
        [self.scrollView addSubview:priceView];
        
        OrderDetailInfoView *infoView = [OrderDetailInfoView initViewNIB];
        if ([self.orderdetailModel.status isEqual:@"2"]) {
            infoView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 160 + 33);
            
        }
        else if ([self.orderdetailModel.status isEqual:@"1"]) {
            infoView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 120 + 33);
            
        }
        else if ([self.orderdetailModel.status isEqual:@"6"]) {
            NSString *cancelTime = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.orderdetailModel.cancelTime]];
            
            if (cancelTime.length > 0) {
                infoView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 160 + 33);
                
            }
            else{
                infoView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 200 + 33);
            }
        }
        else if ([self.orderdetailModel.status isEqual:@"5"]) {
            infoView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 240 + 33);
            
        }
        else{
            infoView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 200 + 33);
        }
        infoView.titleStr = TransOutput(@"订单信息");
        infoView.orderNumber = self.orderNumber;
        infoView.model = self.orderdetailModel;
    
        [self.scrollView addSubview:infoView];
        CGFloat fh = 0;
        if ([self.orderdetailModel.refundSts isEqual:@"1"]) {
            fh = [Tool getLabelHeightWithText:TransOutput(@"关于退款退货的处理情况，请确认退款/退货栏的明细。") width:WIDTH - 28 font:12];
            
            UILabel *labels = [[UILabel alloc] initWithFrame: CGRectMake(14, infoView.bottom + 12, WIDTH - 28, fh)];
            labels.text =TransOutput(@"关于退款退货的处理情况，请确认退款/退货栏的明细。");
            labels.font = [UIFont systemFontOfSize:12];
            labels.textColor = RGB(0xF80402);
            labels.numberOfLines = 0;
            [self.scrollView addSubview:labels];
        }
        
        
        scroH += infoView.bottom + 12  + fh + 12;
        self.scrollView.contentSize = CGSizeMake(WIDTH, scroH);
        [HudView hideHudForView:self.view];
        
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(OrderAddressView *)addView{
    if (!_addView) {
        _addView = [OrderAddressView initViewNIB];
        _addView.layer.cornerRadius = 5;
        _addView.clipsToBounds = YES;
    }
    return _addView;
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
