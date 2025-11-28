//
//  OrderDetailInfoRefunViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "OrderDetailInfoRefunViewController.h"

@interface OrderDetailInfoRefunViewController ()
{
    UIView *hejiView;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)mecharnAddressView *addView;
@property(nonatomic, strong)OrderDetailInfoRefunModel *orderdetailModel;
@property(nonatomic, strong)OrderDetailInfoFootView *footView;
@property(nonatomic, strong)UIView *itemBgView;
@property(nonatomic, strong)printWuView *prView;
@end

@implementation OrderDetailInfoRefunViewController
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
   
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 109, WIDTH, HEIGHT - 169)];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addView];
    self.footView = [[OrderDetailInfoFootView alloc] initWithFrame:CGRectMake(0, HEIGHT - 60, WIDTH, 60)];

    [self.view addSubview:self.footView];
    @weakify(self)
    [self.footView setBtnClickBlock:^{
        @strongify(self);
        [self showPrView];
    }];
    [self.footView setCancelApplyClickBlock:^{

        @strongify(self);
        [self cancelApply];
    }];
//
}
-(void)cancelApply{
    [NetwortTool getCancelRefundWithParm:@{@"refundId":self.refundId} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ToastShow(TransOutput(@"退款取消成功"), @"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)showPrView{
    self.prView.frame = self.view.bounds;
    [[UIApplication sharedApplication].delegate.window addSubview:self.prView];
    @weakify(self)
    [self.prView setSubClickBlock:^(NSString * _Nonnull name, NSString * _Nonnull number) {
        @strongify(self)
        
        [NetwortTool getCreateLogisticsWithParm:@{@"refundId":self.refundId,@"expressName":name,@"expressNo":number} Success:^(id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ToastShow(TransOutput(@"物流信息填写成功"), @"chenggong",RGB(0x36D053) );
                [self.prView removeFromSuperview];
                [self popViewControllerAnimate];
            });
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        } ];
    }];
}
- (printWuView *)prView{
    if (!_prView) {
        _prView = [printWuView initViewNIB];
    }
    return _prView;
}
-(void)GetData{
    [NetwortTool getOrderDetailRefunWithParm:@{@"refundId":self.refundId} Success:^(id  _Nonnull responseObject) {
        self.orderdetailModel = [OrderDetailInfoRefunModel mj_objectWithKeyValues:responseObject];
        self.addView.remodel = self.orderdetailModel;
        self.footView.remodel = self.orderdetailModel;
        if ([self.orderdetailModel.applyType isEqual:@"2"] && [self.orderdetailModel.refundSts isEqual:@"2"] ) {
            if (self.orderdetailModel.expressNo.length == 0) {
                self.scrollView.frame = CGRectMake(0, 109, WIDTH, HEIGHT - 169 - 60);
                self.footView.frame = CGRectMake(0, HEIGHT - 120, WIDTH, 120);
            }
            
            else{
                self.scrollView.frame = CGRectMake(0, 109, WIDTH, HEIGHT - 169 );
                self.footView.frame = CGRectMake(0, HEIGHT - 60, WIDTH, 60);
            }
        }
        
        if ([self.orderdetailModel.returnMoneySts isEqual:@"1"] && [self.orderdetailModel.refundSts isEqual:@"1"] ){
            self.scrollView.frame = CGRectMake(0, 109, WIDTH, HEIGHT - 169 - 60);
            self.footView.frame = CGRectMake(0, HEIGHT - 120, WIDTH, 120);
         
        }
       
        NSString *code;
        NSString *addStr;
        if ([[NSString isNullStr:self.orderdetailModel.postCode] length] == 0) {
            code = @"";
            addStr = [NSString stringWithFormat:@"%@\n%@\n%@%@%@%@",[NSString isNullStr:self.orderdetailModel.receiver], [NSString isNullStr:self.orderdetailModel.mobile],[NSString isNullStr:self.orderdetailModel.province],[NSString isNullStr:self.orderdetailModel.city],[NSString isNullStr:self.orderdetailModel.area],[NSString isNullStr:self.orderdetailModel.addr]];
      
        }else{
            code= [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:self.orderdetailModel.postCode] substringToIndex:3],[[NSString isNullStr:self.orderdetailModel.postCode] substringFromIndex:3]];
        
        addStr = [NSString stringWithFormat:@"%@\n%@\n〒%@\n%@%@%@%@",[NSString isNullStr:self.orderdetailModel.receiver], [NSString isNullStr:self.orderdetailModel.mobile],code,[NSString isNullStr:self.orderdetailModel.province],[NSString isNullStr:self.orderdetailModel.city],[NSString isNullStr:self.orderdetailModel.area],[NSString isNullStr:self.orderdetailModel.addr]];
        }
        
        CGFloat h = [Tool getLabelHeightWithText:addStr width:WIDTH - 12-105-12 font:12];
        
        CGFloat scroH = 6;
        CGFloat addH = h + 26+5+10;
        CGFloat proItemH =  98 * self.orderdetailModel.orderItems.count;
       
        self.addView.frame = CGRectMake(14, 6, WIDTH - 28, addH);
        [self.itemBgView removeFromSuperview];
        self.itemBgView= [[UIView alloc] initWithFrame:CGRectMake(14, self.addView.bottom + 12, WIDTH - 28, proItemH + 35)];
        self.itemBgView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.itemBgView];
        for (int i = 0; i < self.orderdetailModel.orderItems.count; i++) {
            MineOrderItemView *vi = [MineOrderItemView initViewNIB];
            vi.OrderRefModel = [OrderDetailInfoRefunModel mj_objectWithKeyValues:self.orderdetailModel.orderItems[i]];
            vi.isDetail = YES;
            vi.layer.cornerRadius = 5;
            vi.clipsToBounds = YES;
            vi.layer.borderColor = RGB(0xE1E1E1).CGColor;
            vi.layer.borderWidth = 0.5;
            [self.itemBgView addSubview:vi];
            [vi mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_offset(0);
                make.height.mas_offset(98);
                make.top.mas_offset(98 * i);
            }];
   
        }
        UIView* stausView = [[UIView alloc] initWithFrame:CGRectMake(0, self.itemBgView.height - 35, self.itemBgView.width, 35)];
        stausView.backgroundColor = [UIColor whiteColor];
        [stausView addBottomCornerPath:5];

        stausView.clipsToBounds = YES;
        [self.itemBgView addSubview:stausView];
        UILabel *labelStaus = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.itemBgView.width - 28, 35)];
        labelStaus.textAlignment = NSTextAlignmentRight;
        labelStaus.font = [UIFont systemFontOfSize:12];
        if ([self.orderdetailModel.returnMoneySts isEqual:@"3"]) {
            labelStaus.text = TransOutput(@"退款失败");
            labelStaus.textColor = RGB(0xDE1135);
        }
       else if ([self.orderdetailModel.returnMoneySts isEqual:@"2"]) {
           labelStaus.text = TransOutput(@"退款成功");
           labelStaus.textColor =RGB(0x197CF5);
        }
       else  {
           if ([self.orderdetailModel.applyType isEqual:@"2"] && [self.orderdetailModel.refundSts isEqual:@"2"] && [NSString isNullStr:self.orderdetailModel.expressName].length == 0) {
               
               labelStaus.text = TransOutput(@"等待退货退回处理");
               labelStaus.textColor  = RGB(0xF80402);
               
                
            }
            else{
                labelStaus.text = TransOutput(@"退款处理中");
                labelStaus.textColor =RGB(0xF80402);
            }
        }
        [stausView addSubview:labelStaus];
        
        [self->hejiView removeFromSuperview];
        self->hejiView = [[UIView alloc] initWithFrame:CGRectMake(14, self.itemBgView.bottom + 12, WIDTH - 28, 33)];
        self->hejiView.backgroundColor = RGB(0xFDF2E6);
        self->hejiView.layer.cornerRadius = 5;
        self->hejiView.clipsToBounds = YES;
        self->hejiView.layer.borderColor = RGB(0xF9B151).CGColor;
        self->hejiView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:self->hejiView];
       
        NSString *applyStr;
        if ([self.orderdetailModel.applyType isEqual:@"1"]) {
            applyStr = TransOutput(@"仅退款");
        }
        else{
            applyStr = TransOutput(@"退货退款");
        }
        NSString *heStr2 = [NSString stringWithFormat:@"%@：%@",TransOutput(@"申请类型"),applyStr];
        
        CGFloat heW2 = [Tool getLabelWidthWithText:heStr2 height:33 font:16];
        

        UILabel *label2 = [[UILabel alloc] init];
        label2.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:heStr2];
        [att addAttributes:@{NSForegroundColorAttributeName:RGB(0xF80402)} range:NSMakeRange(heStr2.length - applyStr.length, applyStr.length)];
        label2.attributedText = att;
        [self->hejiView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-14);
            make.top.bottom.mas_offset(0);
        }];
        
        OrderDetailInfoView *priceView = [OrderDetailInfoView initViewNIB];
        
        NSString *str = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.orderdetailModel.buyerMsg]];
       
        CGFloat hs = [Tool getLabelHeightWithText:str width:WIDTH - 28 - 91 - 25 - 15  font:12] + 16;
        if (hs < 33) {
            hs = 33;
        }
//        if ([self.orderdetailModel.refundSts isEqual:@"3"]) {
//            priceView.frame = CGRectMake(14, self->hejiView.bottom + 12, WIDTH - 28, 160 + hs + 33 *2);
//        }else{
            priceView.frame = CGRectMake(14, self->hejiView.bottom + 12, WIDTH - 28,  hs + 33*5);
//        }
        priceView.titleStr = TransOutput(@"订单价格");
        priceView.remodel = self.orderdetailModel;
        priceView.orderNumber = self.orderNumber;
        [self.scrollView addSubview:priceView];
      
        
        
        
        OrderDetailInfoView *wulView = [OrderDetailInfoView initViewNIB];
        if (self.orderdetailModel.expressNo.length != 0) {
            wulView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 33*3 );
            wulView.titleStr = TransOutput(@"寄件详情");
            wulView.remodel = self.orderdetailModel;
            wulView.orderNumber = self.orderNumber;
            [self.scrollView addSubview:wulView];
          
        }
        else{
            wulView.frame = CGRectMake(14, priceView.bottom + 12, WIDTH - 28, 0 );
            [self.scrollView addSubview:wulView];
        }
        
        OrderDetailInfoView *infoView = [OrderDetailInfoView initViewNIB];
        if (self.orderdetailModel.expressNo.length != 0) {
            infoView.frame = CGRectMake(14, wulView.bottom + 12, WIDTH - 28, 33*5);
        }else{
            if([self.orderdetailModel.refundSts isEqual:@"1"]){
                infoView.frame = CGRectMake(14, wulView.bottom + 12, WIDTH - 28,  33 * 3);
            }else{
                infoView.frame = CGRectMake(14, wulView.bottom + 12, WIDTH - 28,  33 * 4);
            }
        }
        infoView.titleStr = TransOutput(@"订单信息");
        infoView.orderNumber = self.orderNumber;
        infoView.remodel = self.orderdetailModel;
    
        [self.scrollView addSubview:infoView];
        CGFloat tH = 0;
        if ([self.orderdetailModel.refundSts isEqual:@"3"]) {
            tH = [Tool getAttHtmHeight:[NSString isNullStr:self.orderdetailModel.rejectMessage] width:WIDTH - 30 - 28 font:12] + 15;
            if (tH < 33) {
                tH = 33;
            }
            OrderDetailInfoView *reinfoView = [OrderDetailInfoView initViewNIB];
            reinfoView.titleStr = TransOutput(@"拒绝退款原因");
            reinfoView.orderNumber = self.orderNumber;
            reinfoView.remodel = self.orderdetailModel;
            reinfoView.frame = CGRectMake(14, infoView.bottom + 12, WIDTH - 28, tH +33);
            [self.scrollView addSubview:reinfoView];
           
            scroH += reinfoView.bottom + 12 ;
            self.scrollView.contentSize = CGSizeMake(WIDTH, scroH);
            
        }else{
            scroH +=infoView.bottom + 12 ;
            self.scrollView.contentSize = CGSizeMake(WIDTH, scroH);
            
        }
    } failure:^(NSError * _Nonnull error) {
        
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
-(mecharnAddressView *)addView{
    if (!_addView) {
        _addView = [mecharnAddressView initViewNIB];
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
