//
//  PaySuccessViewController.m
//  Netneto
//
//  Created by apple on 2024/12/6.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()<UITextViewDelegate,UIPrintInteractionControllerDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)OrderAddressView *addView;
@property(nonatomic, strong)OrderDetailModel *orderdetailModel;


@end

@implementation PaySuccessViewController
-(void)returnClick{
//    [self popViewControllerAnimate];
    
    NSArray *vcArray = self.navigationController.viewControllers;


       for(UIViewController *vc in vcArray)
       {
           if ([vc isKindOfClass:[HomeGoodDetailViewController class]])
           {
               [self.navigationController popToViewController:vc animated:YES];
           }
           if ([vc isKindOfClass:[OrderDetailViewController class]])
           {
               [self popViewControllerAnimate];
           }
       }
}
- (void)initData{
    
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *rithtBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [rightButtonView addSubview:rithtBtn];
       [rithtBtn setImage:[UIImage imageNamed:@"downLoad"] forState:UIControlStateNormal];
       [rithtBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
      self.navigationItem.rightBarButtonItem = rightCunstomButtonView;

    
    
}
-(void)rightClick{
    NSString * pdfpath = [NSString stringWithFormat:@"Receipt_%@_%@_%@",self.orderNumber,[Tool getCurtenTimeStrWithStringYYYYMMDD],[Tool getCurtenSecondStrWithString]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths lastObject];

    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",pdfpath]]; //docPath为文件名

    if ([fileManager fileExistsAtPath:filePath]) {

    //文件已经存在,直接打开

        CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"PDFファイルを開いてもよろしいでしょうか？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
            [self openDocxWithPath:filePath];
        } cancelBlock:^{
            
        }];
        [alert show];
        
   
    }else {

    //文件不存在,要下载
        CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"PDFファイルを開いてもよろしいでしょうか？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
            [self downloadDocxWithDocPath:documentsDirectory fileName:self.orderNumber];
        } cancelBlock:^{
            
        }];
        [alert show];
      
    }



//       [self downloadDocxWithDocPath:path fileName:self.orderNumber];

}
-(void)downloadDocxWithDocPath:(NSString *)docPath fileName:(NSString *)fileName {
    NSString * pdfpath = [NSString stringWithFormat:@"Receipt_%@_%@_%@",self.orderNumber,[Tool getCurtenTimeStrWithStringYYYYMMDD],[Tool getCurtenSecondStrWithString]];;
    [HudView showHudForView:self.view];

    NSString *urlString = RequestURL(@"/p/myOrder/getReceiptPdf?orderNumber=");

urlString = [urlString stringByAppendingString:fileName];

NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.allHTTPHeaderFields = @{
        @"Authorization":account.accessToken
    };
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

NSLog(@"下载PDF进度%lld  %lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);

} destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",pdfpath]];

NSLog(@"PDF文件路径＝＝＝%@",path);

return [NSURL fileURLWithPath:path];//这里返回的是文件下载到哪里的路径 要注意的是必须是携带协议file://

} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

    [HudView hideHudForView:self.view];


NSString *name = [filePath path];

NSLog(@"下载完成文件路径＝＝＝%@",name);

[self openDocxWithPath:name];

//        }

}];

[task resume];//开始下载 要不然不会进行下载的

}
-(void)openDocxWithPath:(NSString *)filePath {
    NSURL *url = [NSURL fileURLWithPath:filePath];
   
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//  

//
  UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];

    // 设置文件URL
     
doc.delegate = self;
    [doc setURL:url];
[doc presentPreviewAnimated:YES];

}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{

return self;

}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {

return self.view;

}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {

    return CGRectMake(0, 30, WIDTH, HEIGHT);

}

-(void)loadData{
    [NetwortTool getReceiptWithParm:@{@"orderNumber":self.orderNumber} Success:^(id  _Nonnull responseObject) {
        NSLog(@"收据详情：%@",responseObject);
        

        self.orderdetailModel = [OrderDetailModel mj_objectWithKeyValues:responseObject];
        NSString *str = @"";
        if ([self.orderdetailModel.status isEqual:@"1"]) {
            str =  TransOutput(@"待支付");
        }
        if ([self.orderdetailModel.status isEqual:@"2"] ||[self.orderdetailModel.status isEqual:@"3"]||[self.orderdetailModel.status isEqual:@"4"]||[self.orderdetailModel.status isEqual:@"5"]) {
            str =  TransOutput(@"已支付");
        }
        
        if ([self.orderdetailModel.status isEqual:@"6"]) {
            str =  TransOutput(@"取消订单");
        }
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
        vi.backgroundColor = RGB(0x0F7CFD);
        [self.scrollView addSubview:vi];
      
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 15, WIDTH, 36);
        [button setImage:[UIImage imageNamed:@"组合 503"] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@:%@",TransOutput(@"注文状態"),str] forState:UIControlStateNormal];
        
        [button layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:11];
        [self.scrollView addSubview:button];
        
         
        
        self.addView.detailmodel = self.orderdetailModel;
        NSString *code;
        NSString *addStr;
        if ([[NSString isNullStr:self.orderdetailModel.postCode] length] ==0) {
            code = @"";
            addStr = [NSString stringWithFormat:@"%@%@%@%@",[NSString isNullStr:self.orderdetailModel.province],[NSString isNullStr:self.orderdetailModel.city],[NSString isNullStr:self.orderdetailModel.area],[NSString isNullStr:self.orderdetailModel.addr]];
      
        }else{
            code= [NSString stringWithFormat:@"%@-%@",[[NSString isNullStr:self.orderdetailModel.postCode] substringToIndex:3],[[NSString isNullStr:self.orderdetailModel.postCode] substringFromIndex:3]];
            addStr = [NSString stringWithFormat:@"〒%@\n%@%@%@%@",code,[NSString isNullStr:self.orderdetailModel.province],[NSString isNullStr:self.orderdetailModel.city],[NSString isNullStr:self.orderdetailModel.area],[NSString isNullStr:self.orderdetailModel.addr]];
      
        }
           //
//
        CGFloat h = [Tool getLabelHeightWithText:addStr width:WIDTH - 32-28 font:12];
        CGFloat scroH = 6;
        CGFloat addH = h + 26 + 28 + 14;
       
        CGFloat proItemH = self.orderdetailModel.orderItemList.count * 98;

        self.addView.frame = CGRectMake(14, 70, WIDTH - 28, addH);
        [self.scrollView addSubview:self.addView];
       
        UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(14, self.addView.bottom + 12, WIDTH - 28, 68)];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.layer.cornerRadius = 5;
        cardView.layer.borderColor = RGB(0xE1E1E1).CGColor;
        cardView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:cardView];

        UIImageView *cardImg = [[UIImageView alloc] init];
//        if ([self.orderdetailModel.cardAbbreviation isEqualToString:@"Visa"]) {
//            cardImg.image = [UIImage imageNamed:@"visa"];
//        }
//        if ([self.orderdetailModel.cardAbbreviation isEqualToString:@"JCB"]) {
//            cardImg.image = [UIImage imageNamed:@"jcb"];
//        }
//        if ([self.orderdetailModel.cardAbbreviation isEqualToString:@"Diners Club International"]) {
//            cardImg.image = [UIImage imageNamed:@"dinersClub"];
//        }
//        if ([self.orderdetailModel.cardAbbreviation isEqualToString:@"Mastercard"]) {
//            cardImg.image = [UIImage imageNamed:@"master"];
//        }
//        if ([self.orderdetailModel.cardAbbreviation isEqualToString:@"American Express"]) {
//            cardImg.image = [UIImage imageNamed:@"amer"];
//        }
//        if ([self.orderdetailModel.cardAbbreviation isEqualToString:@"Discover"]) {
//            cardImg.image = [UIImage imageNamed:@"discover"];
//        }
        
        [cardImg sd_setImageWithURL:[NSURL URLWithString:self.orderdetailModel.cardUrl]];
        
        [cardView addSubview:cardImg];
        [cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(23);
            make.top.mas_offset(13);
            make.height.mas_equalTo(44);
            make.width.mas_offset(74);
      
        }];
        UILabel *cardLabel = [[UILabel alloc] init];
        cardLabel.text = [NSString stringWithFormat:@"%@ ...%@",[NSString isNullStr:self.orderdetailModel.cardAbbreviation],[NSString isNullStr:self.orderdetailModel.cardNumber]];
        cardLabel.font = [UIFont systemFontOfSize:14];
        [cardView addSubview:cardLabel];
        [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(cardImg.mas_trailing).offset(12);
            make.top.mas_offset(13);
            make.height.mas_equalTo(16);
        }];
        
        UILabel *payLabel = [[UILabel alloc] init];
        payLabel.text = [NSString stringWithFormat:@"%@  %@",TransOutput(@"付款时间"),[NSString isNullStr:self.orderdetailModel.payTime]];
        payLabel.font = [UIFont systemFontOfSize:14];
        [cardView addSubview:payLabel];
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(cardImg.mas_trailing).offset(12);
        
            make.bottom.mas_offset(-12);
            make.height.mas_equalTo(16);
        }];
        UIView *orderNumView = [[UIView alloc] initWithFrame:CGRectMake(14, cardView.bottom + 12, WIDTH - 28, 80)];
        orderNumView.backgroundColor = [UIColor whiteColor];
        orderNumView.layer.cornerRadius = 5;
        orderNumView.layer.borderColor = RGB(0x0F7CFD).CGColor;
        orderNumView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:orderNumView];

        UILabel *orderNumTpLabel = [[UILabel alloc] init];
        orderNumTpLabel.text = [NSString stringWithFormat:@"%@",TransOutput(@"订单编号")];
        orderNumTpLabel.font = [UIFont systemFontOfSize:12];
        [orderNumView addSubview:orderNumTpLabel];
        [orderNumTpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.top.mas_offset(12);
            make.height.mas_offset(16);
        }];
        UILabel *orderNumLabel = [[UILabel alloc] init];
        orderNumLabel.text = [NSString stringWithFormat:@"%@",self.orderdetailModel.orderNumber];
        orderNumLabel.font = [UIFont systemFontOfSize:12];
        orderNumLabel.textColor = RGB(0x868585);
        [orderNumView addSubview:orderNumLabel];
        [orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-16);
            make.top.mas_offset(12);
            make.height.mas_offset(16);
        }];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = RGB(0xCACACA);
        [orderNumView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-17);
            make.leading.mas_offset(17);
            make.top.mas_equalTo(orderNumLabel.mas_bottom).offset(12);
            make.height.mas_offset(1);
        }];
        
        UILabel *orderTimeTpLabel = [[UILabel alloc] init];
        orderTimeTpLabel.text = [NSString stringWithFormat:@"%@",TransOutput(@"下单时间")];
        orderTimeTpLabel.font = [UIFont systemFontOfSize:12];
        [orderNumView addSubview:orderTimeTpLabel];
        [orderTimeTpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.top.mas_equalTo(lineLabel.mas_bottom).offset(12);
          
            make.height.mas_offset(16);
        }];
        UILabel *orderTimeLabel = [[UILabel alloc] init];
        orderTimeLabel.text = [NSString stringWithFormat:@"%@",self.orderdetailModel.createTime];
        orderTimeLabel.font = [UIFont systemFontOfSize:12];
        orderTimeLabel.textColor = RGB(0x868585);
        [orderNumView addSubview:orderTimeLabel];
        [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-16);
            make.top.mas_equalTo(lineLabel.mas_bottom).offset(12);
          
            make.height.mas_offset(16);
        }];
        
        UIView *orderToalView = [[UIView alloc] initWithFrame:CGRectMake(14, orderNumView.bottom + 12, WIDTH - 28, 152)];
        orderToalView.backgroundColor = [UIColor whiteColor];
        orderToalView.layer.cornerRadius = 5;
        orderToalView.layer.borderColor = RGB(0x0F7CFD).CGColor;
        orderToalView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:orderToalView];
        
        NSArray *arr;
        NSString *refundAmount = [NSString stringWithFormat:@"%@",[NSString isNullStr:self.orderdetailModel.refundAmount]];
        if ([refundAmount intValue] > 0) {
            orderToalView.frame = CGRectMake(14, orderNumView.bottom + 12, WIDTH - 28, 152 + 40);
            arr = @[
                @{@"title":TransOutput(@"小计"),@"price":self.orderdetailModel.total},
              @{@"title":TransOutput(@"运费"),@"price":self.orderdetailModel.freightAmount},
              @{@"title":TransOutput(@"割引金額"),@"price":self.orderdetailModel.reduceAmount},
              @{@"title":TransOutput(@"订单总额"),@"price":self.orderdetailModel.actualTotal},
                @{@"title":TransOutput(@"退款金额"),@"price":self.orderdetailModel.refundAmount}
                ];
            
        }else{
            orderToalView.frame = CGRectMake(14, orderNumView.bottom + 12, WIDTH - 28, 152);
         
            arr = @[
                @{@"title":TransOutput(@"小计"),@"price":self.orderdetailModel.total},
                @{@"title":TransOutput(@"运费"),@"price":self.orderdetailModel.freightAmount},
                @{@"title":TransOutput(@"割引金額"),@"price":self.orderdetailModel.reduceAmount},
                @{@"title":TransOutput(@"订单总额"),@"price":self.orderdetailModel.actualTotal}];
        }
        for (int i = 0; i <arr.count; i ++) {
            UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(15, 39*i, orderToalView.width - 30, 38)];
            vi.backgroundColor = [UIColor clearColor];
            [orderToalView addSubview:vi];
            
            UILabel *orderTimeTpLabel = [[UILabel alloc] init];
            orderTimeTpLabel.text = [NSString stringWithFormat:@"%@",arr[i][@"title"]];
            orderTimeTpLabel.font = [UIFont systemFontOfSize:12];
            [vi addSubview:orderTimeTpLabel];
            [orderTimeTpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_offset(0);
                make.top.mas_equalTo(12);
              
                make.height.mas_offset(16);
            }];
            UILabel *Label = [[UILabel alloc] init];
            Label.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:arr[i][@"price"]]];
            Label.font = [UIFont systemFontOfSize:12];
            if (i == 1 || i == 2) {
                
                Label.textColor = RGB(0x868585);
            }
            else{
                Label.textColor = RGB(0xF80402);
            }
            [vi addSubview:Label];
            [Label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_offset(0);
                make.top.mas_equalTo(12);
              
                make.height.mas_offset(16);
            }];
            
            if (i != arr.count - 1) {
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(14, vi.bottom, orderToalView.width - 28, 1)];
                line.backgroundColor = RGB(0xCACACA);
                [orderToalView addSubview:line];
               
            }
            
        }
        UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(14, orderToalView.bottom + 12, WIDTH - 28, 33)];
        priceView.backgroundColor = RGB(0xFDF2E6);
        priceView.layer.cornerRadius = 5;
        priceView.layer.borderColor = RGB(0xFD8141).CGColor;
        priceView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:priceView];
        UILabel *TpLabel = [[UILabel alloc] init];
        TpLabel.text = [NSString stringWithFormat:@"%@",TransOutput(@"ご請求額")];
        TpLabel.font = [UIFont systemFontOfSize:12];
        [priceView addSubview:TpLabel];
        [TpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.top.mas_equalTo(9);
            make.height.mas_offset(16);
        }];
        UILabel *Label = [[UILabel alloc] init];
        Label.text = [NSString stringWithFormat:@"¥%@",[NSString ChangePriceStr:self.orderdetailModel.actualPayAmount]];
        Label.font = [UIFont systemFontOfSize:12];
            Label.textColor = RGB(0xF80402);
        
        [priceView addSubview:Label];
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-16);
            make.top.mas_equalTo(9);
          
            make.height.mas_offset(16);
        }];
        UIView *itemBgView = [[UIView alloc] initWithFrame:CGRectMake(14, priceView.bottom + 12, WIDTH - 28, proItemH)];
        itemBgView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:itemBgView];
        
        for (int i = 0 ; i <self.orderdetailModel.orderItemList.count; i++) {
            OrderModel *itemModel = [OrderModel mj_objectWithKeyValues:self.orderdetailModel.orderItemList[i]];
            MineOrderItemView *vi = [MineOrderItemView initViewNIB];
            //        vi.frame = CGRectMake(0, 98 * i, WIDTH - 32, 98);
            vi.isRe = YES;
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
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(14, itemBgView.bottom + 12, WIDTH - 28, 77)];
        footView.backgroundColor = [UIColor whiteColor];
        footView.layer.cornerRadius = 5;
        footView.layer.borderColor = RGB(0xE1E1E1).CGColor;
        footView.layer.borderWidth = 0.5;
        [self.scrollView addSubview:footView];
        NSString *string = @"お客様の個人情報は、当社のプライバシーポリシーに基づき厳重に管理します。詳細はプライバシーポリシーをご覧ください。";
            NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:string];
       
        NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
         
        [attstring addAttribute:NSLinkAttributeName value:valueString range:NSMakeRange(39, 10)];
//        [attstring addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(39, 10)];
//      
        // 设置下划线
        [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(39, 10)];
         
        // 设置颜色
        [attstring addAttribute:NSForegroundColorAttributeName value:RGB(0x0F7CFD) range:NSMakeRange(39, 10)];
       
        UITextView *agreeTx = [[UITextView alloc] init];
        agreeTx.font = [UIFont systemFontOfSize:12];
        agreeTx.delegate = self;
        agreeTx.attributedText =attstring;
        agreeTx.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0); // 上 左 下 右
        agreeTx.textAlignment = NSTextAlignmentLeft; // 设置文本居中
        agreeTx.editable = NO; // 如果你不希望用户编辑文本，设置为NO
        [footView addSubview:agreeTx];
        [agreeTx mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_offset(16);
            make.trailing.mas_offset(-16);
            make.top.mas_offset(12);
            make.bottom.mas_offset(-16);
        }];
        
//        CGFloat fh = 0;
//        if ([self.orderdetailModel.refundSts isEqual:@"1"]) {
//            fh = [Tool getLabelHeightWithText:TransOutput(@"关于退款退货的处理情况，请确认退款/退货栏的明细。") width:WIDTH - 28 font:12];
//            
//            UILabel *labels = [[UILabel alloc] initWithFrame: CGRectMake(14, infoView.bottom + 12, WIDTH - 28, fh)];
//            labels.text =TransOutput(@"关于退款退货的处理情况，请确认退款/退货栏的明细。");
//            labels.font = [UIFont systemFontOfSize:12];
//            labels.textColor = RGB(0xF29359);
//            labels.numberOfLines = 0;
//            [self.scrollView addSubview:labels];
//        }
//        
        
        scroH +=footView.bottom + 12;
        self.scrollView.contentSize = CGSizeMake(WIDTH, scroH);
        
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        [self handleTapY];
        return NO;
    }
 
    return YES;
 
}
-(void)handleTapY{
  
    
    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
   
  
//    vc.title = TransOutput(@"隐私政策");
  
        vc.url = @"https://netneto.com/privacy_policy.html";
       
   
    
    [self  pushController:vc];
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"收据");
    
   
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 99, WIDTH, HEIGHT - 99 )];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
     

    [self loadData];
   
    
//
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
