//
//  addShopUserViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/10.
//

#import "addShopUserViewController.h"

@interface addShopUserViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,SDPhotoBrowserDelegate,UIDocumentPickerDelegate>
{
    UIButton *subBtn;
    MBProgressHUD *hud;
    UILabel *label;
    UILabel *labelPdf;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *bgHeaderView;
///事业形态
@property(nonatomic, strong)addShopUserCustomView *shiTFView;
///商家自有品牌
@property(nonatomic, strong)addShopUserCustomView *shangjiaTFView;
///公司名称
@property(nonatomic, strong)addShopUserCustomView *gongNameTFView;
///管理者id
@property(nonatomic, strong)addShopUserCustomView *leaderIdTFView;
///姓名片假名
@property(nonatomic, strong)addShopUserCustomView *pianTFView;
///姓名汉字
@property(nonatomic, strong)addShopUserCustomView *hanTFView;
///手机号
@property(nonatomic, strong)addShopUserCustomView *phoneTFView;
///邮箱
@property(nonatomic, strong)addShopUserCustomView *emailTFView;
///邮政编码
@property(nonatomic, strong)addShopUserCustomView *emailCodeTFView;
///商家地址
@property(nonatomic, strong)addShopAddCustomLineView *shopAddTFView;
///商家详细地址
@property(nonatomic, strong)addShopUserCustomView *addTFView;
///证件类型
@property(nonatomic, strong)addShopUserCustomView *cardTypeTFView;
///银行名
@property(nonatomic, strong)addShopUserCustomView *bankNameTFView;
///支行名
@property(nonatomic, strong)addShopUserCustomView *zhiNameTFView;
///开户种类
@property(nonatomic, strong)addShopUserCustomView *kaiClassTFView;
///银行账号
@property(nonatomic, strong)addShopUserCustomView *bankAccountTFView;
///持卡人姓名
@property(nonatomic, strong)addShopUserCustomView *cardNameTFView;

@property(nonatomic, strong)addShopUserCustomView *wuhaoTFView;
@property(nonatomic, strong)AddressSelView *addSelectView;
@property(nonatomic, strong)bankNameSearchView *bankSearchView;
@property(nonatomic, strong)bankZhiNameView *bankZhiView;
@property(nonatomic, strong)NSDictionary *bankDic;
@property(nonatomic, strong)NSDictionary *bankZhiDic;
@property(nonatomic, strong)NSString *shiStr;
@property(nonatomic, strong)NSString *pinStr;
@property(nonatomic, strong)NSString *openAccountType;
@property(nonatomic, strong)NSString *dictType;
@property(nonatomic, strong)NSString *corporateName;
@property(nonatomic, strong)NSString *documentImgUrls;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic ,assign) NSInteger i;
@property (nonatomic ,strong) NSMutableArray *imageArray;

@property (strong, nonatomic) UICollectionView *collectionViewPDF;
@property (nonatomic ,assign) NSInteger iPdf;
@property (nonatomic ,strong) NSMutableArray *pdfArray;
@property (nonatomic ,strong) NSMutableArray *pdfDataArray;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic ,strong) NSMutableArray *picArray;
@property (nonatomic ,strong) UITextView *agreeTx;
@property (nonatomic ,strong) UIButton *Agree;
@property (nonatomic ,strong) NSString *isAgree;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger cityareaId;

@end

@implementation addShopUserViewController

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
    self.shiStr = @"";
    self.pinStr = @"";
    self.dictType = @"";
    self.openAccountType = @"";
    self.documentImgUrls = @"";
    self.corporateName = @"";
    self.isAgree = @"";
    self.picArray = [NSMutableArray array];
    self.pdfDataArray = [NSMutableArray array];
    self.areaId = 0;
}
-(void)CreateView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"商家入驻");
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 99, WIDTH, HEIGHT - 99)];
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    self.shiTFView.frame = CGRectMake(16, 20, WIDTH - 32, 40);
    [self.scrollView addSubview:self.shiTFView];
    
    self.shiTFView.frame = CGRectMake(16, 20, WIDTH - 32, 40);
    self.shiTFView.customTF.delegate = self;
    [self.scrollView addSubview:self.shiTFView];
    
    self.shangjiaTFView.frame = CGRectMake(16, self.shiTFView.bottom + 14, WIDTH - 32, 40);
    self.shangjiaTFView.customTF.delegate = self;
    if ([self.dataDic allKeys].count > 0) {
        
        self.leaderIdTFView.customTF.text =[NSString isNullStr:self.dataDic[@"merchantName"]];
        self.pianTFView.customTF.text = [NSString isNullStr:self.dataDic[@"realName"]];
        self.hanTFView.customTF.text = [NSString isNullStr:self.dataDic[@"realNameH"]];
        if ([self.dataDic[@"merchantType"] isEqual:@0]) {
            self.shiTFView.customTF.text = TransOutput(@"個人事業主");
            
            _hanTFView.titleLabel.text =TransOutput(@"姓名(汉字):");
            
            _pianTFView.titleLabel.text =TransOutput(@"姓名(片假名):");
            
        }
        else if ([self.dataDic[@"merchantType"] isEqual:@1]) {
            
            self.shiTFView.customTF.text = TransOutput(@"法人");
            _hanTFView.titleLabel.text =TransOutput(@"法姓名(汉字):");
            
            _pianTFView.titleLabel.text =TransOutput(@"法姓名(片假名):");
            
        }
        else{
            self.shiTFView.customTF.text = TransOutput(@"個人");
            _hanTFView.titleLabel.text =TransOutput(@"姓名(汉字):");
            
            _pianTFView.titleLabel.text =TransOutput(@"姓名(片假名):");
            
        }
        
        self.shiStr = [NSString isNullStr:[NSString stringWithFormat:@"%@",self.dataDic[@"merchantType"]]];
        self.pinStr = [NSString isNullStr:[NSString stringWithFormat:@"%@",self.dataDic[@"privateBrand"]]];
        if ([self.pinStr isEqual:@"0"]) {
            self.shangjiaTFView.customTF.text = TransOutput(@"否");
        }else{
            self.shangjiaTFView.customTF.text = TransOutput(@"是");
        }
        self.gongNameTFView.customTF.text = [NSString isNullStr:self.dataDic[@"corporateName"]];
        self.emailTFView.customTF.text = [NSString isNullStr:self.dataDic[@"userMail"]];
        self.phoneTFView.customTF.text = [NSString isNullStr:self.dataDic[@"userMobile"]];
        self.bankAccountTFView.customTF.text = [NSString isNullStr:self.dataDic[@"bankCardNo"]];
        self.openAccountType = [NSString isNullStr:self.dataDic[@"openAccountType"]];
        self.wuhaoTFView.customTF.text = [NSString isNullStr:self.dataDic[@"corporateName"]];
        if ([self.openAccountType isEqual:@"1"]) {
            self.kaiClassTFView.customTF.text = TransOutput(@"普通");
        }
        else{
            self.kaiClassTFView.customTF.text = TransOutput(@"当座");
        }
        self.cardNameTFView.customTF.text = [NSString isNullStr:self.dataDic[@"bankCardOwnerName"]];
        self.emailCodeTFView.customTF.text = [NSString isNullStr:self.dataDic[@"areaPostalCode"]];
        
        self.shopAddTFView.customTF.text = [NSString stringWithFormat:@"%@-%@-%@",[NSString isNullStr:self.dataDic[@"province"]],[NSString isNullStr:self.dataDic[@"city"]],[NSString isNullStr:self.dataDic[@"area"]]];
        
        self.shopAddTFView.customTF.textColor = [UIColor blackColor];
        self.addTFView.customTF.text = [NSString isNullStr:self.dataDic[@"addr"]];
        self.bankDic = self.dataDic[@"bankInfo"];
        self.bankNameTFView.customTF.text = [NSString isNullStr:self.dataDic[@"bankInfo"][@"fullName"]];
        self.bankZhiDic = self.dataDic[@"branchInfo"];
        
        self.zhiNameTFView.customTF.text = [NSString isNullStr:self.dataDic[@"branchInfo"][@"fullName"]];
        self.cardTypeTFView.customTF.text = [NSString isNullStr:self.dataDic[@"documentTypeName"]];
        self.dictType = [NSString isNullStr:self.dataDic[@"documentType"]];
        self.documentImgUrls = [NSString isNullStr:self.dataDic[@"documentImgUrls"]];
        if ([[NSString isNullStr:self.dataDic[@"documentImgUrls"]] length] == 0) {
            self.picArray = [NSMutableArray array];
            self.imageArray =[NSMutableArray array];
        }else{
            NSArray *arr = [[NSString isNullStr:self.dataDic[@"documentImgUrls"]] componentsSeparatedByString:@","];
            self.picArray = [NSMutableArray arrayWithArray:arr];
            self.imageArray =[NSMutableArray arrayWithArray:arr];
        }
        if ([[NSString isNullStr:self.dataDic[@"pdfUrls"]] length] == 0) {
            self.pdfDataArray = [NSMutableArray array];
        }else{
            NSArray *arrPdf = [[NSString isNullStr:self.dataDic[@"pdfUrls"]] componentsSeparatedByString:@","];
            
            
            
            self.pdfDataArray = [NSMutableArray arrayWithArray:arrPdf];
        }
        
        
        //        self.imageDataArray =[NSMutableArray arrayWithArray:arr];
        if ([self.dataDic[@"merchantType"] isEqual:@"1"]) {
            [self updataFrame:40 type:[NSString stringWithFormat:@"%@",self.dataDic[@"merchantType"]]];
        }else{
            [self updataFrame:0 type:[NSString stringWithFormat:@"%@",self.dataDic[@"merchantType"]]];
        }
    }else{
        _hanTFView.titleLabel.text =TransOutput(@"姓名(汉字):");
        
        _pianTFView.titleLabel.text =TransOutput(@"姓名(片假名):");
        
        [self updataFrame:0 type:@""];
    }
    
    [self.scrollView addSubview:self.shangjiaTFView];
    [self.scrollView addSubview:self.gongNameTFView];
    [self.scrollView addSubview:self.wuhaoTFView];
    [self.scrollView addSubview:self.leaderIdTFView];
    [self.scrollView addSubview:self.pianTFView];
    [self.scrollView addSubview:self.hanTFView];
    [self.scrollView addSubview:self.phoneTFView];
    [self.scrollView addSubview:self.emailTFView];
    [self.scrollView addSubview:self.emailCodeTFView];

    [self.scrollView addSubview:self.shopAddTFView];
    [self.scrollView addSubview:self.addTFView];
    self.cardTypeTFView.customTF.delegate = self;
    [self.scrollView addSubview:self.cardTypeTFView];
    self.bankNameTFView.customTF.delegate = self;
    [self.scrollView addSubview:self.bankNameTFView];
    self.zhiNameTFView.customTF.delegate = self;
    [self.scrollView addSubview:self.zhiNameTFView];
    self.kaiClassTFView.customTF.delegate = self;
    [self.scrollView addSubview:self.kaiClassTFView];
    [self.scrollView addSubview:self.bankAccountTFView];
    [self.scrollView addSubview:self.cardNameTFView];
    
    
    self.addSelectView = [AddressSelView initViewNIB];
    
    self.addSelectView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.bankSearchView  = [bankNameSearchView initViewNIB];
    self.bankSearchView.backgroundColor = [UIColor clearColor];
    self.bankSearchView.frame =CGRectMake(0, 0, WIDTH, HEIGHT);
    @weakify(self);
    [self.bankSearchView setSureBlock:^(NSDictionary * _Nonnull dic) {
        @strongify(self);
        self.bankDic = dic;
        
        self.bankNameTFView.customTF.text = [NSString isNullStr:dic[@"fullName"]];
        self.zhiNameTFView.customTF.text = @"";
    }];
    self.bankZhiView = [bankZhiNameView initViewNIB];
    self.bankZhiView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.bankZhiView setSureBlock:^(NSDictionary * _Nonnull dic) {
        @strongify(self);
        self.bankZhiDic = dic;
        self.zhiNameTFView.customTF.text = [NSString isNullStr:dic[@"fullName"]];
    }];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(16, self.cardNameTFView.bottom + 14, WIDTH - 32, 130)];
    [self.textView setPlaceholderWithText:TransOutput(@"请输入给管理者备注消息(最多200字)") Color:RGB(0x585757)];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.scrollView addSubview:self.textView];
    self.i = 0;
    self.textView.text = [NSString isNullStr:self.dataDic[@"leaveMessage"]];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    self.collectionView.frame = CGRectMake(16, self.textView.bottom + 5, WIDTH - 16, 92);
    [self.scrollView addSubview:self.collectionView];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(26, self.collectionView.bottom , WIDTH - 32, 18)];
    label.text = TransOutput(@"图片最多上传9张");
    label.font = [UIFont systemFontOfSize:10];
    label.textColor =RGB(0xF80402);
    [self.scrollView addSubview:label];
    
    [self.collectionViewPDF registerClass:[PdfCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionViewPDF registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    self.collectionViewPDF.frame = CGRectMake(16, label.bottom + 5, WIDTH - 16, 92);
    [self.scrollView addSubview:self.collectionViewPDF];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.collectionViewPDF.panGestureRecognizer];
    
    labelPdf = [[UILabel alloc] initWithFrame:CGRectMake(26, self.collectionViewPDF.bottom , WIDTH - 32, 18)];
    labelPdf.text = TransOutput(@"PDF最多上传9张");
    labelPdf.font = [UIFont systemFontOfSize:10];
    labelPdf.textColor =RGB(0xF80402);
    [self.scrollView addSubview:labelPdf];
    
    
    self.Agree = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Agree.frame = CGRectMake(16, labelPdf.bottom + 20, 20, 20);
    [self.Agree setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [self.Agree addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.Agree];
    
    
    NSString *str = [NSString stringWithFormat:@"%@",TransOutput(@"加盟店利用規約と出品者ポリシーを確認し、同意します")];
    CGFloat w = [Tool getLabelWidthWithText:str height:35 font:14] + 40;
    if (w > WIDTH - 60) {
        w = WIDTH - 60;
    }
    
    
    CGFloat h = [Tool getLabelHeightWithText:str width:w font:14];
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    [attstring addAttribute:NSLinkAttributeName value:valueString range:NSMakeRange(0, 7)];
    
    NSString *valueString2 = [[NSString stringWithFormat:@"secondPerson://2"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    [attstring addAttribute:NSLinkAttributeName value:valueString2 range:NSMakeRange(8, 7)];
    
    
    
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 7)];
    
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:NSMakeRange(0, 7)];
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 7)];
    
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:NSMakeRange(8, 7)];
    self.agreeTx = [[UITextView alloc] initWithFrame:CGRectMake(36, labelPdf.bottom + 20, w, h)];
    self.agreeTx.delegate = self;
    self.agreeTx.attributedText =attstring;
    self.agreeTx.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0); // 上 左 下 右
    self.agreeTx.textAlignment = NSTextAlignmentLeft;
    self.agreeTx.editable = NO; // 如果你不希望用户编辑文本，设置为NO
    [self.scrollView addSubview:self.agreeTx];
    
    subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subBtn.frame = CGRectMake(16, self.agreeTx.bottom + 16, WIDTH - 32, 44);
    subBtn.layer.cornerRadius = 22;
    subBtn.clipsToBounds = YES;
    subBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [subBtn setTitle:TransOutput(@"提交申请") forState:UIControlStateNormal];
    [self.scrollView addSubview:subBtn];
    
    [subBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self subClick];
    }];
    self.scrollView.contentSize = CGSizeMake(WIDTH,  subBtn.bottom + 20);
    [self.shopAddTFView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self.view addSubview:self.addSelectView];
        if (![self.shopAddTFView.customTF.text isEqual:TransOutput(@"请选择商家地址")] ) {
            [self.addSelectView upshow:self.shopAddTFView.customTF.text areId:self.areaId cityAreId:self.cityareaId];
        }
        @weakify(self);
        [self.addSelectView setSureBlock:^(NSString * _Nonnull addressStr, NSString * _Nonnull postalCode, NSInteger cityAreaId, NSInteger areaId) {
            
            
            
            @strongify(self);
            self.areaId = areaId;
            self.cityareaId = cityAreaId;
            self.shopAddTFView.customTF.text = addressStr;
            self.shopAddTFView.customTF.textColor = [UIColor blackColor];
            self.emailCodeTFView.customTF.text = postalCode;
        }];
        
    }];
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
        //        vc.title = TransOutput(@"加盟店利用規約");
        vc.url = @"https://netneto.com/merchant_registration_agreement.html";
        [self pushController:vc];
        return NO;
    }
    if ([[URL scheme] isEqualToString:@"secondPerson"]) {
        MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
        //        vc.title = TransOutput(@"出品者ポリシー");
        vc.url = @"https://netneto.com/seller_policy.html";
        [self pushController:vc];
        return NO;
    }
    return YES;
    
}
-(void)agreeClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [self.Agree setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
        self.isAgree = @"1";
    }else{
        sender.selected = NO;
        [self.Agree setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
        self.isAgree = @"";
    }
}
-(void)subClick{
    
    if (self.shiTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择业务形态"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.shangjiaTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择是否有自有的品牌"), errImg,RGB(0xFF830F));
        return;
    }
    if ([self.shiStr isEqual:@"1"]) {
        if (self.gongNameTFView.customTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入公司名称"), errImg,RGB(0xFF830F));
            return;
        }
    }
    if ([self.shiStr isEqual:@"0"]) {
        if (self.wuhaoTFView.customTF.text.length == 0) {
            
            ToastShow(TransOutput(@"屋号を入力してください。"), errImg,RGB(0xFF830F));
            return;
        }
    }
    if (self.leaderIdTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入管理员用户ID"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.pianTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入假名姓名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.hanTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入汉字姓名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.phoneTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入手机号码"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.emailTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入邮箱地址"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.emailCodeTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入邮政编码"), errImg,RGB(0xFF830F));
        return;
    }
    if ([self.shopAddTFView.customTF.text isEqual:TransOutput(@"请选择商家地址")] ) {
        ToastShow(TransOutput(@"请选择商家地址"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.addTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入商家详细地址"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.cardTypeTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择证件类型"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.bankNameTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择银行名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.zhiNameTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择支行名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.kaiClassTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请选择开户种类"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.bankAccountTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入银行账号"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.bankAccountTFView.customTF.text.length != 7) {
        ToastShow(TransOutput(@"银行卡号必须是7位"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.cardNameTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入持卡人姓名"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.picArray.count == 0 && self.pdfDataArray.count == 0) {
        ToastShow(TransOutput(@"请上传相关证件图片"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.isAgree.length == 0) {
        ToastShow(TransOutput(@"请勾选协议"), errImg,RGB(0xFF830F));
        return;
    }
    NSString *corporateNameStr = @"";
    if ([_shiStr isEqual:@"0"]) {
        corporateNameStr = self.wuhaoTFView.customTF.text;
    }
    else if ([_shiStr isEqual:@"1"]){
        corporateNameStr = self.gongNameTFView.customTF.text;
    }
    NSDictionary *parm = @{@"rejectId":self.rejectId,@"merchantType":self.shiStr,@"privateBrand":self.pinStr,@"corporateName":corporateNameStr,@"merchantName":self.leaderIdTFView.customTF.text,@"realName":self.pianTFView.customTF.text,@"realNameH":self.hanTFView.customTF.text,@"userMobile":self.phoneTFView.customTF.text,@"userMail":self.emailTFView.customTF.text,@"areaPostalCode":self.emailCodeTFView.customTF.text,@"addr":self.addTFView.customTF.text,@"documentType":self.dictType,@"bankCode":self.bankDic[@"code"],@"branchCode":self.bankZhiDic[@"code"],@"openAccountType":self.openAccountType,@"bankCardNo":self.bankAccountTFView.customTF.text,@"bankCardOwnerName":self.cardNameTFView.customTF.text,@"documentImgUrls":[self.picArray componentsJoinedByString:@","],@"pdfUrls":[self.pdfDataArray componentsJoinedByString:@","],@"province":self.shopAddTFView.customTF.text,@"leaveMessage":self.textView.text};
    
    
    CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:TransOutput(@"提交申请") Message:TransOutput(@"是否提交申请？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
        [self submitData:parm];
        
    } cancelBlock:^{
        
    }];
    [alert show];
    
    
    
    
}
-(void)submitData:(NSDictionary *)parm{
    if ([self.dataDic allKeys].count > 0) {
        [NetwortTool getReApplyShopUserWithParm:parm Success:^(id  _Nonnull responseObject) {
            
            
            ToastShow(TransOutput(@"提交成功"),@"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
    else{
        [NetwortTool getApplyShopUserWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSString *str = responseObject;
            ToastShow(TransOutput(@"提交成功"),@"chenggong",RGB(0x36D053));
            [self popViewControllerAnimate];
            
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
}
-(void)searchEmailCode{
    
    if (self.emailCodeTFView.customTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入邮政编码"), errImg,RGB(0xFF830F));
        return;
    }
    [HudView showHudForView:self.view];
    [NetwortTool getListByPostCodeWithParm:@{@"postCode":self.emailCodeTFView.customTF.text} Success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
        NSLog(@"根据code获取地址：%@",responseObject);
        NSString *str = [NSString stringWithFormat:@"%@",responseObject];
        if ([str isEqual:@"<null>"]) {
            ToastShow(TransOutput(@"未匹配到相应地址"), errImg,RGB(0xFF830F));
            self.shopAddTFView.customTF.text = TransOutput(@"请选择商家地址");
            self.shopAddTFView.customTF.textColor = [UIColor lightGrayColor];
        }else{
            if (str.length > 0) {
                self.shopAddTFView.customTF.text = str;
                self.shopAddTFView.customTF.textColor = [UIColor blackColor];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual: self.shiTFView.customTF]) {
        [self choseShi];
        return NO;
    }
    else if ([textField isEqual: self.shangjiaTFView.customTF]) {
        [self choseShang];
        return NO;
    }
    
    else if ([textField isEqual:self.cardTypeTFView.customTF]){
        [self getTypeData];
        return NO;
    }
    
    else if ([textField isEqual:self.bankNameTFView.customTF]){
        [self.bankSearchView getBankCustomList];
        [self.view addSubview:self.bankSearchView];
        return NO;
    }
    else if ([textField isEqual:self.zhiNameTFView.customTF]){
        if (self.bankNameTFView.customTF.text.length == 0) {
            ToastShow(TransOutput(@"请选择银行名"), errImg,RGB(0xFF830F));
            
        }else{
            [self.bankZhiView updateWithDatadic:self.bankDic];
            
            [self.view addSubview:self.bankZhiView];
        }
        return NO;
    }
    else if ([textField isEqual:self.kaiClassTFView.customTF]){
        [self choseKai];
        
        return NO;
    }
    
    return YES;
}
-(void)updataFrame:(CGFloat)h type:(NSString *)tp{
    if ([tp isEqual:@"1"]) {
        self.gongNameTFView.frame =  CGRectMake(16, self.shangjiaTFView.bottom + 14, WIDTH - 32, 40);
        self.wuhaoTFView.frame = CGRectMake(16, self.gongNameTFView.bottom + 14, WIDTH - 32, 0);
        self.leaderIdTFView.frame = CGRectMake(16, self.wuhaoTFView.bottom, WIDTH - 32, 40);
    }
    else if ([tp isEqual:@"0"]){
        self.gongNameTFView.frame =  CGRectMake(16, self.shangjiaTFView.bottom + 14, WIDTH - 32, 0);
        self.wuhaoTFView.frame = CGRectMake(16, self.gongNameTFView.bottom, WIDTH - 32, 40);
        self.leaderIdTFView.frame = CGRectMake(16, self.wuhaoTFView.bottom + 14, WIDTH - 32, 40);
    }
    else if ([tp isEqual:@"2"]){
        self.gongNameTFView.frame =  CGRectMake(16, self.shangjiaTFView.bottom + 14, WIDTH - 32, 0);
        self.wuhaoTFView.frame = CGRectMake(16, self.gongNameTFView.bottom, WIDTH - 32, 0);
        self.leaderIdTFView.frame = CGRectMake(16, self.wuhaoTFView.bottom , WIDTH - 32, 40);
    }else{
        self.gongNameTFView.frame =  CGRectMake(16, self.shangjiaTFView.bottom + 14, WIDTH - 32, 0);
        self.wuhaoTFView.frame = CGRectMake(16, self.gongNameTFView.bottom, WIDTH - 32, 0);
        self.leaderIdTFView.frame = CGRectMake(16, self.wuhaoTFView.bottom , WIDTH - 32, 40);
    }
    self.pianTFView.frame = CGRectMake(16, self.leaderIdTFView.bottom + 14, WIDTH - 32, 40);
    self.hanTFView.frame = CGRectMake(16, self.pianTFView.bottom + 14, WIDTH - 32, 40);
    self.phoneTFView.frame = CGRectMake(16, self.hanTFView.bottom + 14, WIDTH - 32, 40);
    self.emailTFView.frame = CGRectMake(16, self.phoneTFView.bottom + 14, WIDTH - 32, 40);
    self.emailCodeTFView.frame = CGRectMake(16, self.emailTFView.bottom + 14, WIDTH - 32, 40);
    self.shopAddTFView.frame = CGRectMake(16, self.emailCodeTFView.bottom + 14, WIDTH - 32, 40);
    self.addTFView.frame = CGRectMake(16, self.shopAddTFView.bottom + 14, WIDTH - 32, 40);
    self.cardTypeTFView.frame = CGRectMake(16, self.addTFView.bottom + 14, WIDTH - 32, 40);
    self.bankNameTFView.frame = CGRectMake(16, self.cardTypeTFView.bottom + 14, WIDTH - 32, 40);
    self.zhiNameTFView.frame = CGRectMake(16, self.bankNameTFView.bottom + 14, WIDTH - 32, 40);
    self.kaiClassTFView.frame = CGRectMake(16, self.zhiNameTFView.bottom + 14, WIDTH - 32, 40);
    self.bankAccountTFView.frame = CGRectMake(16, self.kaiClassTFView.bottom + 14, WIDTH - 32, 40);
    self.cardNameTFView.frame = CGRectMake(16, self.bankAccountTFView.bottom + 14, WIDTH - 32, 40);
    self.textView.frame = CGRectMake(16, self.cardNameTFView.bottom + 14, WIDTH - 32, 130);
    self.collectionView.frame = CGRectMake(16, self.textView.bottom + 5, WIDTH - 16, 92);
    label.frame = CGRectMake(26, self.collectionView.bottom , WIDTH - 32, 18);
    self.collectionViewPDF.frame = CGRectMake(16, label.bottom + 5, WIDTH - 16, 92);
    labelPdf.frame = CGRectMake(26, self.collectionViewPDF.bottom , WIDTH - 32, 18);
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",TransOutput(@"您已阅读并同意"),TransOutput(@"入驻协议"),TransOutput(@"协议")];
    
    CGFloat w = [Tool getLabelWidthWithText:str height:35 font:14] + 40;
    if (w > WIDTH - 60) {
        w = WIDTH - 60;
    }
    CGFloat hs = [Tool getLabelHeightWithText:str width:w font:14];
    
    self.Agree.frame = CGRectMake(16, labelPdf.bottom + 20, 20, 20);
    
    self.agreeTx.frame = CGRectMake(36, labelPdf.bottom + 20, w , hs);
    subBtn.frame = CGRectMake(16, self.agreeTx.bottom + 16, WIDTH - 32, 44);
    self.scrollView.contentSize = CGSizeMake(WIDTH,  subBtn.bottom + 20);
}
-(void)getTypeData{
    if (self.shiStr.length == 0) {
        ToastShow(TransOutput(@"请选择业务形态"), errImg,RGB(0xFF830F));
        return;
    }
    [HudView showHudForView:self.view];
    [NetwortTool getCardTypeWithParm:@{@"merchantType":self.shiStr} Success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
        NSArray *arr = responseObject[@"data"];
        
        [self choseCardType:arr];
        
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
-(void)choseKai{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TransOutput(@"请选择开户种类") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAlert = [UIAlertAction actionWithTitle:TransOutput(@"普通") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.kaiClassTFView.customTF.text =TransOutput(@"普通");
        
        self.openAccountType = @"1";
    }];
    [maleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *femaleAlert = [UIAlertAction actionWithTitle:TransOutput(@"当座") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.kaiClassTFView.customTF.text =TransOutput(@"当座");
        
        self.openAccountType = @"2";
    }];
    [femaleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancle setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    [alert addAction:maleAlert];
    [alert addAction:femaleAlert];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)choseCardType:(NSArray *)arr{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TransOutput(@"请选择证件类型") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < arr.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:arr[i][@"dictLabel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击后的操作
            NSLog(@"点击了%@", action.title);
            self.cardTypeTFView.customTF.text = [NSString isNullStr:arr[i][@"dictLabel"]];
            self.dictType = [NSString isNullStr:arr[i][@"dictCode"]];
        }];
        [alertController addAction:action];
        
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}
-(void)choseShi{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TransOutput(@"请选择业务形态") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAlert = [UIAlertAction actionWithTitle:TransOutput(@"法人") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![self.shiTFView.customTF.text isEqual:TransOutput(@"法人")]){
            self.cardTypeTFView.customTF.text = @"";
        }
        
        self.shiTFView.customTF.text =TransOutput(@"法人");
        [self updataFrame:40 type:@"1"];
        self.shiStr = @"1";
        self.hanTFView.titleLabel.text =TransOutput(@"法姓名(汉字):");
        self.pianTFView.titleLabel.text =TransOutput(@"法姓名(片假名):");
        
        
        self.wuhaoTFView.customTF.text = @"";
        
    }];
    [maleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *femaleAlert = [UIAlertAction actionWithTitle:TransOutput(@"个人") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![self.shiTFView.customTF.text isEqual:TransOutput(@"个人")]){
            self.cardTypeTFView.customTF.text = @"";
        }
        self.shiTFView.customTF.text =TransOutput(@"个人");
        [self updataFrame:0 type:@"2"];
        self.shiStr = @"2";
        self.hanTFView.titleLabel.text =TransOutput(@"姓名(汉字):");
        
        self.pianTFView.titleLabel.text =TransOutput(@"姓名(片假名):");
        
        //        self.cardTypeTFView.customTF.text = @"";
        self.gongNameTFView.customTF.text = @"";
        self.wuhaoTFView.customTF.text = @"";
        
    }];
    [femaleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *threeAlert = [UIAlertAction actionWithTitle:TransOutput(@"個人事業主") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![self.shiTFView.customTF.text isEqual:TransOutput(@"個人事業主")]){
            self.cardTypeTFView.customTF.text = @"";
        }
        self.shiTFView.customTF.text =TransOutput(@"個人事業主");
        
        [self updataFrame:0 type:@"0"];
        self.shiStr = @"0";
        self.hanTFView.titleLabel.text =TransOutput(@"姓名(汉字):");
        
        self.pianTFView.titleLabel.text =TransOutput(@"姓名(片假名):");
        
        self.gongNameTFView.customTF.text = @"";
        
    }];
    [threeAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancle setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    [alert addAction:femaleAlert];
    [alert addAction:threeAlert];
    [alert addAction:maleAlert];
    
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)choseShang{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TransOutput(@"请选择是否有自有的品牌") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAlert = [UIAlertAction actionWithTitle:TransOutput(@"是") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.shangjiaTFView.customTF.text =TransOutput(@"是");
        self.pinStr = @"1";
    }];
    [maleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *femaleAlert = [UIAlertAction actionWithTitle:TransOutput(@"否") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.shangjiaTFView.customTF.text =TransOutput(@"否");
        self.pinStr = @"0";
    }];
    [femaleAlert setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancle setValue:RGB(0x333333) forKey:@"_titleTextColor"];
    
    [alert addAction:maleAlert];
    [alert addAction:femaleAlert];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.collectionView) {
        return self.imageArray.count + 1 ;
        
    }
    else{
        return self.pdfDataArray.count +1;
    }
    
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        
        
        if (self.imageArray.count == 0) {
            AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
            
            [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
            [cell1.addImageV setTitle:TransOutput(@"证件照") forState:UIControlStateNormal];
            [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            return cell1;
            
        }else{
            
            
            if (indexPath.item == 0 ) {
                AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
                
                [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
                [cell1.addImageV setTitle:TransOutput(@"证件照") forState:UIControlStateNormal];
                [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
                
                return cell1;
                
                
            }else{
                CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                if ([self.imageArray[indexPath.item - 1] isKindOfClass:[UIImage class]]) {
                    
                    cell.imageV.image = self.imageArray[indexPath.item- 1];
                }else{
                    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.item - 1]]];
                }
                [cell.imageV addSubview:cell.deleteButotn];
                cell.deleteButotn.tag = indexPath.item - 1 + 100;
                [cell.deleteButotn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
            
        }
        
    }
    else{
        if (self.pdfDataArray.count == 0) {
            AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
            
            [cell1.addImageV setImage:[UIImage imageNamed:@"组合 640"] forState:UIControlStateNormal];
            [cell1.addImageV setTitle:TransOutput(@"选择文件") forState:UIControlStateNormal];
            [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            return cell1;
            
        }else{
            
            
            if (indexPath.item == 0 ) {
                AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
                
                [cell1.addImageV setImage:[UIImage imageNamed:@"组合 640"] forState:UIControlStateNormal];
                [cell1.addImageV setTitle:TransOutput(@"选择文件") forState:UIControlStateNormal];
                [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
                
                return cell1;
                
                
            }else{
                PdfCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                NSArray *arr = [self.pdfDataArray[indexPath.row - 1] componentsSeparatedByString:@"/"];
                cell.titleLabel.text = arr.lastObject;

                cell.deleteButotn.tag = indexPath.item - 1 + 100;
                [cell.deleteButotn addTarget:self action:@selector(deletePdf:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
            
        }
    }
    
}

- (void)deletePdf:(UIButton *)sender{
    
    NSInteger index = sender.tag - 100;
    if(self.pdfDataArray.count > index){
        [self.pdfDataArray removeObjectAtIndex:index];
        [self.collectionViewPDF reloadData];
    }
}
- (void)deleteImage:(UIButton *)sender{
   
    NSInteger index = sender.tag - 100;
  
    //移除沙盒数组中imageDataArray的数据
//if (self.imageDataArray.count == self.imageArray.count) {
//    [self.imageDataArray removeObjectAtIndex:index];
//}
    
    //移除显示图片数组imageArray中的数据
    if (self.picArray.count == self.imageArray.count) {
        [self.picArray removeObjectAtIndex:index];
    }
    if (self.imageArray.count > index) {
        [self.imageArray removeObjectAtIndex:index];
    }
   
   
    
    
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取Document文件的路径
    NSString *collectPath = filePath.lastObject;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    //移除所有文件
    [fileManager removeItemAtPath:collectPath error:nil];
   
    
    [self.collectionView reloadData];
    
}
- (void)WriteToBox:(NSData *)imageData{
    
    _i ++;
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取Document文件的路径
    NSString *collectPath = filePath.lastObject;
   
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:collectPath]) {
        
        [fileManager createDirectoryAtPath:collectPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    //    //拼接新路径
    NSString *newPath = [collectPath stringByAppendingPathComponent:[NSString stringWithFormat:@"PictureUser_%ld.png",_i]];
    NSLog(@"++%@",newPath);
    [imageData writeToFile:newPath atomically:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
        
    
       if (indexPath.item == 0 ) {
            NSLog(@"上传");
            [self submitPictureToServer:1];
        }else{

            SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
            broser.currentImageIndex = indexPath.row-1;
            broser.tag = 2;
            broser.sourceImagesContainerView = self.collectionView;
            broser.imageCount =self.imageArray.count  ;
            broser.delegate = self;
            [broser show];
        }
    }
    else{
        
       
//        http://yueran.vip/
        if (indexPath.item == 0) {
            if (self.pdfDataArray.count ==9) {
                ToastShow(TransOutput(@"PDF最多上传9张"), errImg,RGB(0xFF830F));
                return;
            }
            NSArray *types = @[@"com.adobe.pdf"]; // 可以选择的文件类型,下面有关于type的解释

            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];

            documentPicker.delegate = self;//(UIDocumentPickerDelegate)

            documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:documentPicker animated:YES completion:nil];
        }
        else{
            MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
            if ([self.pdfDataArray[indexPath.row-1] hasPrefix:@"http"]) {
                vc.url = self.pdfDataArray[indexPath.row-1];
            }
            else{
                vc.url = [NSString stringWithFormat:@"http://yueran.vip/%@",self.pdfDataArray[indexPath.row-1]];
            }
            [self pushController:vc];

        }
    }
   
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray *)urls {

//获取授权

    dispatch_async(dispatch_get_main_queue(), ^{
        self->hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        self->hud.label.text = @"";
    });
BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];

if (fileUrlAuthozied) {

//通过文件协调工具来得到新的文件地址，以此得到文件保护功能

NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];

NSError *error;

[fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {

//读取文件

NSString *fileName = [newURL lastPathComponent];

NSError *error = nil;

NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];

    NSString *dataLength = [Tool getBytesFromDataLength:fileData.length];
    NSLog(@"输出pdf大小:%@",dataLength);
    if ([dataLength containsString:@"M"]) {
        if ([[dataLength substringToIndex:dataLength.length -1] intValue] > 8) {

            ToastShow(TransOutput(@"pdf超过8M"), errImg,RGB(0xFF830F));
//
            
            [HudView hideHudForView:self.view];
            return;
        }
    }
if (error) {

//读取出错

    [HudView hideHudForView:self.view];

} else {

//上传

NSLog(@"fileData --- %@  fileName：%@",fileData,fileName);
//    [UploadElement UploadElementWithPdf:fileData name:fileName progress:^(CGFloat percent) {
//        
//    } success:^(id  _Nonnull responseObject) {
//        NSLog(@"上传成功：%@",responseObject);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [HudView hideHudForView:self.view];
//            ToastShow(TransOutput(@"pdf上传成功"), @"chenggong", RGB(0x36D053));
//            [self.pdfArray addObject:fileName];
//            [self.pdfDataArray addObject:responseObject[@"data"]];
//            [self.collectionViewPDF reloadData];
//            
//        });
//    }];
    
    [UploadElement UploadElementWithPdf:fileData name:fileName progress:^(NSString * _Nonnull percent) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self->hud.label.text = percent;
//            [MBProgressHUD updateMess:percent hud:self->hud ];
        });
        
    } success:^(id  _Nonnull responseObject) {
        
      
        NSString *code = responseObject[@"code"];
        if ([code isEqual:@"A00005"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                ToastShow(TransOutput(@"PDF上传成功"), @"chenggong", RGB(0x36D053));
               
                [self.pdfArray addObject:fileName];
                           [self.pdfDataArray addObject:responseObject[@"data"]];
                           [self.collectionViewPDF reloadData];
            });
        
     
        }
    }];
    

// [self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];

}

[self dismissViewControllerAnimated:YES completion:NULL];

}];

[urls.firstObject stopAccessingSecurityScopedResource];

} else {

//授权失败
    [HudView hideHudForView:self.view];
//[self showError:@"授权失败"];

}

}
////网址 的iamge
-(NSURL*)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//网络图片（如果崩溃，可能是此图片地址不存在了）
NSMutableArray *array;
if (browser.tag == 2) {
    
    array = self.imageArray;
}

//
if (browser.tag == 1) {
    [array removeObjectAtIndex:0];
}
NSString *imageName = array[index];
NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageName]];

return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    NSMutableArray *array;
    if (browser.tag == 2) {

    array = self.imageArray;
    }

    //
    if (browser.tag == 1) {
    [array removeObjectAtIndex:0];
    }
    if ([array[index] isKindOfClass:[UIImage class]]) {
        UIImage *imageName = array[index];
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageName]];

        return imageName;
    }
    else{
        return [UIImage new];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.emailCodeTFView.customTF) {
        self.shopAddTFView.customTF.text = TransOutput(@"请选择商家地址");
        self.shopAddTFView.customTF.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
-(void)submitPictureToServer:(NSInteger)row{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }];
    [photoAlbumAction setValue:RGB(0x333333) forKey:@"_titleTextColor"];
  
    UIAlertAction *takeAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choseImgType:UIImagePickerControllerSourceTypeCamera row:row];
    }];
    [takeAlbumAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancle setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alert addAction:takeAlbumAction];
    [alert addAction:photoAlbumAction];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)pushTZImagePickerController {
    if (self.imageArray.count == 9) {
        ToastShow(TransOutput(@"图片最多上传9张"), errImg,RGB(0xFF830F));
        return;
    }
    // 设置languageBundle以使用其它语言，必须在TZImagePickerController初始化前设置 / Set languageBundle to use other language
//     [TZImagePickerConfig sharedInstance].languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ja" ofType:@"lproj"]];

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - self.imageArray.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
     imagePickerVc.showSelectBtn = NO;
    imagePickerVc.preferredLanguage = @"ja";
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
//    imagePickerVc.isSelectOriginalPhoto = YES;
  
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)choseImgType:(UIImagePickerControllerSourceType)sourceType row:(NSInteger)row{
  
    self.imagePickerVc.sourceType = sourceType;
   
    [self presentViewController:_imagePickerVc animated:YES completion:nil];

  
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark ------相册回调方法----------
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:nil completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
               
                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
//    [_selectedAssets addObject:asset];
    [self.imageArray addObject:image];
//    [self.tuiView updateColloc:self.imageArray];
    NSData *imageData=UIImageJPEGRepresentation(image, 0.8);

       
        
    [self uploadImage:image index:0];
    [self.collectionView reloadData];

}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {

    NSMutableArray<NSData *> *imageDatas = [NSMutableArray array];

    dispatch_async(dispatch_get_main_queue(), ^{
        self->hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        self->hud.label.text = @"";
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           for (int i=0; i<photos.count; i++) {
               UIImage *result = photos[i];
               
                   dispatch_async(dispatch_get_main_queue(), ^{
                      
                       if (isSelectOriginalPhoto) {
                           [[TZImageManager manager] getOriginalPhotoWithAsset:assets[i] completion:^(UIImage *photo, NSDictionary *info) {

                               NSData *imageData = info[@"PHImageFileDataKey"];
                               NSString *dataLength = [Tool getBytesFromDataLength:imageData.length];
                               NSLog(@"输出图片大小:%@",dataLength);
                               if ([dataLength containsString:@"M"]) {
                                   if ([[dataLength substringToIndex:dataLength.length -1] intValue] > 8) {

                                       ToastShow(TransOutput(@"图片超过8M"), errImg,RGB(0xFF830F));
//
                                       [self.collectionView reloadData];
                                       return;
                                   }
                               }

                               [self.imageArray addObject:photo];
                               [imageDatas addObject:imageData];

                           [self.collectionView reloadData];
                           }];
                       }
                       else{
                           NSData *imageData=UIImageJPEGRepresentation(result, 1);
                           NSString *dataLength = [Tool getBytesFromDataLength:imageData.length];
                           NSLog(@"输出图片大小:%@",dataLength);
                           if ([dataLength containsString:@"M"]) {
                               if ([[dataLength substringToIndex:dataLength.length -1] intValue] > 8) {

                                   ToastShow(TransOutput(@"图片超过8M"), errImg,RGB(0xFF830F));
                                   [self.collectionView reloadData];
                                   return;
                               }
                           }
                         
                           [self.imageArray addObject:result];
                           [imageDatas addObject:imageData];

                       [self.collectionView reloadData];
                       }
                   });
   
               
           }
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 设置延时，单位秒
        double delay = 3;
         
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), queue, ^{
            // 3秒后需要执行的任务
 
                [self uploadImageArray:imageDatas];
//            }
            
        });
       });
   
   
       [self dismissViewControllerAnimated:YES completion:^{
   
               [self.collectionView reloadData];
   
   
       }];

  
}




-(void)uploadImageArray:(NSArray *)array{
//    if (index == 0) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [HudView showHudForView:self.view];
//    });
//    }
    
    
    if (array.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
   
    
    [UploadElement UploadElementWithImageArr:array name:@"imagedefault" progress:^(NSString * _Nonnull percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self->hud.label.text = percent;
//            [MBProgressHUD updateMess:percent hud:self->hud ];
        });
        
    } success:^(id  _Nonnull responseObject) {
        
      
        NSString *code = responseObject[@"code"];
        if ([code isEqual:@"A00005"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
                //            if (index == self.imageArray.count - 1) {
//                [HudView hideHudForView:self.view];
                //            }
            });
            //            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
            NSArray *arr = [responseObject[@"data"] componentsSeparatedByString:@","];
            for (NSString *str  in arr) {
                [self.picArray addObject: str];
            }
            
        }
    }];
}
-(void)uploadImage:(UIImage *)image index:(NSInteger) index{
//    if (index == 0) {
        [HudView showHudForView:self.view];
//    }
    
    
    [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
        
    } success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
//            if (index == self.imageArray.count - 1) {
                [HudView hideHudForView:self.view];
//            }
        });
//            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
        [self.picArray addObject: responseObject[@"data"]];
        
    }];
}

//选择图片上限提示
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"到达9张图片上限") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
      } cancelBlock:^{
    }];
    [alert show];
   
}

-(addShopUserCustomView *)cardNameTFView{
    if (!_cardNameTFView) {
        _cardNameTFView = [addShopUserCustomView initViewNIB];
        _cardNameTFView.titleLabel.text =TransOutput(@"持卡人姓名:");
        _cardNameTFView.customTF.placeholder =TransOutput(@"请输入持卡人姓名");
        _cardNameTFView.searchWidth.constant = 0;
    }
    return _cardNameTFView;
}
-(addShopUserCustomView *)bankAccountTFView{
    if (!_bankAccountTFView) {
        _bankAccountTFView = [addShopUserCustomView initViewNIB];
        _bankAccountTFView.titleLabel.text =TransOutput(@"银行账号:");
        _bankAccountTFView.customTF.placeholder =TransOutput(@"请输入银行账号");
        _bankAccountTFView.searchWidth.constant = 0;
    }
    return _bankAccountTFView;
}
-(addShopUserCustomView *)kaiClassTFView{
    if (!_kaiClassTFView) {
        _kaiClassTFView = [addShopUserCustomView initViewNIB];
        _kaiClassTFView.titleLabel.text =TransOutput(@"开户种类:");
        _kaiClassTFView.customTF.placeholder =TransOutput(@"请选择开户种类");
        _kaiClassTFView.searchWidth.constant = 0;
    }
    return _kaiClassTFView;
}
-(addShopUserCustomView *)zhiNameTFView{
    if (!_zhiNameTFView) {
        _zhiNameTFView = [addShopUserCustomView initViewNIB];
        _zhiNameTFView.titleLabel.text =TransOutput(@"支行名:");
        _zhiNameTFView.customTF.placeholder =TransOutput(@"请选择支行名");
        _zhiNameTFView.searchWidth.constant = 0;
    }
    return _zhiNameTFView;
}
-(addShopUserCustomView *)bankNameTFView{
    if (!_bankNameTFView) {
        _bankNameTFView = [addShopUserCustomView initViewNIB];
        _bankNameTFView.titleLabel.text =TransOutput(@"银行名:");
        _bankNameTFView.customTF.placeholder =TransOutput(@"请选择银行名");
        _bankNameTFView.searchWidth.constant = 0;
    }
    return _bankNameTFView;
}
-(addShopUserCustomView *)cardTypeTFView{
    if (!_cardTypeTFView) {
        _cardTypeTFView = [addShopUserCustomView initViewNIB];
        _cardTypeTFView.titleLabel.text =TransOutput(@"证件类型:");
        _cardTypeTFView.customTF.placeholder =TransOutput(@"请选择证件类型");
        _cardTypeTFView.searchWidth.constant = 0;
    }
    return _cardTypeTFView;
}
-(addShopUserCustomView *)addTFView{
    if (!_addTFView) {
        _addTFView = [addShopUserCustomView initViewNIB];
        _addTFView.titleLabel.text =TransOutput(@"商家详细地址:");
        _addTFView.customTF.placeholder =TransOutput(@"请输入商家详细地址");
        _addTFView.searchWidth.constant = 0;
    }
    return _addTFView;
}
-(addShopAddCustomLineView *)shopAddTFView{
    if (!_shopAddTFView) {
        _shopAddTFView = [addShopAddCustomLineView initViewNIB];
        _shopAddTFView.titleLabel.text =TransOutput(@"商家地址:");
        _shopAddTFView.customTF.text =TransOutput(@"请选择商家地址");
        _shopAddTFView.customTF.textColor = [UIColor lightGrayColor];
        _shopAddTFView.searchWidth.constant = 0;
    }
    return _shopAddTFView;
}
-(addShopUserCustomView *)emailCodeTFView{
    if (!_emailCodeTFView) {
        _emailCodeTFView = [addShopUserCustomView initViewNIB];
        _emailCodeTFView.titleLabel.text =TransOutput(@"邮政编码:");
        _emailCodeTFView.customTF.placeholder =TransOutput(@"请输入邮政编码");
        _emailCodeTFView.searchWidth.constant = 20;
        _emailCodeTFView.customTF.delegate = self;
        @weakify(self);
        [_emailCodeTFView.search addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [self  searchEmailCode];
        }];
    }
    return _emailCodeTFView;
}
-(addShopUserCustomView *)emailTFView{
    if (!_emailTFView) {
        _emailTFView = [addShopUserCustomView initViewNIB];
        _emailTFView.titleLabel.text =TransOutput(@"邮箱:");
        _emailTFView.customTF.placeholder =TransOutput(@"请输入邮箱地址");
        _emailTFView.searchWidth.constant = 0;
    }
    return _emailTFView;
}
-(addShopUserCustomView *)phoneTFView{
    if (!_phoneTFView) {
        _phoneTFView = [addShopUserCustomView initViewNIB];
        _phoneTFView.titleLabel.text =TransOutput(@"手机号码:");
        _phoneTFView.customTF.placeholder =TransOutput(@"请输入手机号(示例:090-1234-5678)");
        _phoneTFView.searchWidth.constant = 0;
    }
    return _phoneTFView;
}
-(addShopUserCustomView *)hanTFView{
    if (!_hanTFView) {
        _hanTFView = [addShopUserCustomView initViewNIB];
        
        _hanTFView.customTF.placeholder =TransOutput(@"请输入汉字姓名");
        _hanTFView.searchWidth.constant = 0;
    }
    return _hanTFView;
}
-(addShopUserCustomView *)pianTFView{
    if (!_pianTFView) {
        _pianTFView = [addShopUserCustomView initViewNIB];
      
        
        _pianTFView.customTF.placeholder =TransOutput(@"请输入假名姓名");
        _pianTFView.searchWidth.constant = 0;
    }
    return _pianTFView;
}
-(addShopUserCustomView *)gongNameTFView{
    if (!_gongNameTFView) {
        _gongNameTFView = [addShopUserCustomView initViewNIB];
        _gongNameTFView.titleLabel.text =TransOutput(@"公司名称:");
        _gongNameTFView.customTF.placeholder =TransOutput(@"请输入公司名称");
        _gongNameTFView.searchWidth.constant = 0;
        
    }
    return _gongNameTFView;
}

-(addShopUserCustomView *)wuhaoTFView{
    if (!_wuhaoTFView) {
        _wuhaoTFView = [addShopUserCustomView initViewNIB];
        _wuhaoTFView.titleLabel.text =TransOutput(@"屋号:");
        _wuhaoTFView.customTF.placeholder =TransOutput(@"屋号を入力してください。");
        _wuhaoTFView.searchWidth.constant = 0;
        
    }
    return _wuhaoTFView;
}
-(addShopUserCustomView *)leaderIdTFView{
    if (!_leaderIdTFView) {
        _leaderIdTFView = [addShopUserCustomView initViewNIB];
        _leaderIdTFView.titleLabel.text =TransOutput(@"店铺管理者ID:");
        _leaderIdTFView.customTF.placeholder =TransOutput(@"请输入管理员用户ID");
        _leaderIdTFView.searchWidth.constant = 0;
    }
    return _leaderIdTFView;
}
-(addShopUserCustomView *)shangjiaTFView{
    if (!_shangjiaTFView) {
        _shangjiaTFView = [addShopUserCustomView initViewNIB];
        _shangjiaTFView.titleLabel.text =TransOutput(@"注册商家自有的品牌:");
        _shangjiaTFView.customTF.placeholder =TransOutput(@"请选择是否有自有的品牌");
        _shangjiaTFView.searchWidth.constant = 0;
    }
    return _shangjiaTFView;
}
-(addShopUserCustomView *)shiTFView{
    if (!_shiTFView) {
        _shiTFView = [addShopUserCustomView initViewNIB];
        _shiTFView.titleLabel.text =TransOutput(@"事业形态:");
        _shiTFView.customTF.placeholder =TransOutput(@"请选择业务形态");
        _shiTFView.searchWidth.constant = 0;
        
    }
    return _shiTFView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
      
        flowLayOut.itemSize = CGSizeMake(70, 70);
        flowLayOut.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

    }
    return _collectionView;
}

-(UICollectionView *)collectionViewPDF{
    if (!_collectionViewPDF) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
      
        flowLayOut.itemSize = CGSizeMake(70, 70);
        flowLayOut.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionViewPDF = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        
        _collectionViewPDF.showsHorizontalScrollIndicator = NO;
        _collectionViewPDF.backgroundColor = [UIColor clearColor];
        
        
        self.collectionViewPDF.delegate = self;
        self.collectionViewPDF.dataSource = self;

    }
    return _collectionViewPDF;
}
- (NSMutableArray *)imageArray{
       if (!_imageArray) {
           self.imageArray = [NSMutableArray array];
          
       }
       return _imageArray;
}

- (NSMutableArray *)pdfArray{
       if (!_pdfArray) {
           self.pdfArray = [NSMutableArray array];
          
       }
       return _pdfArray;
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
 
    }
    return _imagePickerVc;
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
