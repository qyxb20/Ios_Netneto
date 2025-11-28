//
//  HomeGoodDetailViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/19.
//

#import "HomeGoodDetailViewController.h"
#import "TSVideoPlayback.h"
#import "SDPhotoBrowser.h"
static NSString * const cellID = @"cellID";
@interface HomeGoodDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TSVideoPlaybackDelegate,SDPhotoBrowserDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSMutableArray *imgHeigtArr;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIView * customView;
// 导航栏以及标题
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIButton  *backsButton;
@property (nonatomic, strong) UIView * sharesView;
@property (nonatomic, strong) UIButton  *sharesButton;
@property (nonatomic, strong) UIView * threeView;
@property (nonatomic, strong) UIButton *goodsButton;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *pingjiaButton;

@property (nonatomic,strong) TSVideoPlayback *video;

@property (nonatomic, strong) NSDictionary *selecSkuDic;
@property (nonatomic, strong) GoodCommentModel *commentModel;
@property (nonatomic, strong) NSArray *commentArr;
@property (nonatomic, strong) NSString *positiveRating;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSMutableArray *commentShowArr;
@property (nonatomic, strong) HomeGoodDetailBottomView*bottomView;
@property (nonatomic, strong) HomeGoodDetailWKBottomView*bottomViewWK;
@property (nonatomic, strong) NSArray *secArr;
@property (nonatomic, assign) NSInteger isCollec;
@property (nonatomic, strong) JoinShopCartView *joinCarView;
@property(nonatomic, assign)BOOL isShowTip;
@property (nonatomic, strong) HomeQuanView *quanView;
@property (nonatomic, strong) NSArray *couponsListArr;
//@property (nonatomic, strong) orderQuanView *quanView;
@end

@implementation HomeGoodDetailViewController
-(void)returnClick{
    [self popViewControllerAnimate];
}
#pragma mark-好评率
-(void)getCommData{
    [NetwortTool getGoodCommentWithParam:@{@"prodId":self.prodId} Success:^(id  _Nonnull responseObject) {
        self.positiveRating =[NSString stringWithFormat:@"%@",[NSString isNullStr:responseObject[@"positiveRating"]]];
        self.number = [NSString stringWithFormat:@"%@",[NSString isNullStr:responseObject[@"number"]]];
        [self getCommLoadData];
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
   
    
}
#pragma mark-评论数据
-(void)getCommLoadData{
    [NetwortTool getCommentContentWithParam:@{@"prodId":self.prodId,@"evaluate":@"-1"} Success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
        self.commentArr =responseObject[@"records"];
        if ([responseObject[@"records"] count] == 0) {

            [self.tableView reloadData];
        }else{
            self.commentModel = [[GoodCommentModel alloc] initWithDic:responseObject[@"records"][0]];
          
            [self.tableView reloadData];
        }
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    
}

#pragma mark - 是否收藏
-(void)getIsColl{
    if (!account.isLogin) {
        UIImage *rightImage = [UIImage imageNamed:@"like"] ;
        [self.sharesButton setImage:rightImage forState:UIControlStateNormal];
        return;
    }
    [NetwortTool getIsCollectionWithParm:@{@"prodId":self.prodId} Success:^(id  _Nonnull responseObject) {
        
        UIImage *rightImage = [UIImage imageNamed:@"like"] ;
        UIImage *rightImageS = [UIImage imageNamed:@"yishoucang"] ;
        
        self.isCollec = [responseObject intValue];
        if ([responseObject intValue] == 1) {

            [self.sharesButton setImage:rightImageS forState:UIControlStateNormal];

        }else{

            [self.sharesButton setImage:rightImage forState:UIControlStateNormal];

        }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    
}

-(void)CreateView{
    [self settableView];
    [self setHeadNavigationView];
    [self getIsColl];
   
    // 让tableview加载完直接滚到最顶部
    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    if (account.isLogin) {
        [self setJilu];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updataShopNumber" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{

                [self.bottomView updateNumber];
            [self.bottomViewWK updateNumber];
            
            
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updataCoupon" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"loadData" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self GetData];
            [self getIsColl];
        });
    }];
}
#pragma mark - 更新数据（优惠券）
-(void)loadData{
    NSString *userID = @"";
    if (account.isLogin) {
        userID = account.userInfo.userId;
    }
    [NetwortTool getHomeProdInfo:self.prodId userId:userID success:^(id  _Nonnull responseObject) {

        self.dataDic = responseObject;
        if ([self.dataDic[@"couponsList"] isKindOfClass:[NSArray class]]) {
            self.couponsListArr =self.dataDic[@"couponsList"];
            
        }
        self.quanView.dataArray = [NSMutableArray arrayWithArray:self.couponsListArr];
      
        [self.tableView reloadData];
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
}
#pragma mark-商品详情数据
-(void)GetData{
    self.imgHeigtArr = [NSMutableArray array];
    [HudView showHudForView:self.view];
    NSString *userID = @"";
    if (account.isLogin) {
        userID = account.userInfo.userId;
    }
    [NetwortTool getHomeProdInfo:self.prodId userId:userID success:^(id  _Nonnull responseObject) {

        self.dataDic = responseObject;
        if ([self.dataDic[@"couponsList"] isKindOfClass:[NSArray class]]) {
            self.couponsListArr =self.dataDic[@"couponsList"];
            
        }
        if (account.isLogin) {
            if ([self.dataDic[@"shopUserId"] isEqual:account.userInfo.userId]) {
                [self.bottomView removeFromSuperview];
                [self.view addSubview:self.bottomViewWK];
                [self.bottomViewWK mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.bottom.mas_offset(0);
                    make.height.mas_offset(88);
                }];
            }
            else{
                [self.bottomViewWK removeFromSuperview];
                [self.view addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.trailing.bottom.mas_offset(0);
                    make.height.mas_offset(88);
                }];
            }
        }
        else{
            [self.bottomViewWK removeFromSuperview];
            [self.view addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.bottom.mas_offset(0);
                make.height.mas_offset(88);
            }];
        }
       
        self.selecSkuDic = self.dataDic[@"skuList"][0];


        NSMutableArray *arrBanner  = [NSMutableArray array];
        arrBanner = [[responseObject[@"imgs"] componentsSeparatedByString:@","] mutableCopy];
        [arrBanner insertObject:[NSString isNullStr:responseObject[@"prodVideo"]] atIndex:0];

        if ([[NSString isNullStr:responseObject[@"prodVideo"]] length] == 0) {
            [self addSource:[responseObject[@"imgs"] componentsSeparatedByString:@","] isVideo:TSDETAILTYPEIMAGE];
        }else{
            [self addSource:arrBanner isVideo:TSDETAILTYPEVIDEO];
        }
        
        
        NSArray *arr = [[NSString isNullStr:self.dataDic[@"content"]] componentsSeparatedByString:@","];
        
        for (int i = 0; i <arr.count; i++) {
            ImageModel *model = [[ImageModel alloc] initWithDic:arr[i]];
            [self.imgHeigtArr addObject:model];
            
        }
        [self getCommData];

        
        
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
}
#pragma mark - banner数据
-(void)addSource:(NSArray *)imgUrlArr isVideo:(NSUInteger)videoType{
    self.bannerArray = imgUrlArr;
    self.imageArray = [NSMutableArray array];
    self.imageArray = [self.bannerArray mutableCopy];
    [self.video setWithIsVideo:videoType andDataArray:imgUrlArr];
   
    self.tableView.tableHeaderView = self.video;
}
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    
    SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
    broser.currentImageIndex = index-1;
    broser.tag = 1;
    broser.sourceImagesContainerView = self.video.scrolView;
    broser.imageCount =self.bannerArray.count - 1 ;
    broser.delegate = self;
    [broser show];
    
}
- (void)imgView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index{
    SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
    broser.currentImageIndex = index-1;
    broser.tag = 2;
    broser.sourceImagesContainerView = self.video.scrolView;
    broser.imageCount =self.bannerArray.count  ;
    broser.delegate = self;
    [broser show];
}
////网址 的iamge
-(NSURL*)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    //网络图片（如果崩溃，可能是此图片地址不存在了）
    NSMutableArray *array;
    if (browser.tag == 2) {
        
    array = [NSMutableArray arrayWithArray:self.bannerArray];
    }
    if (browser.tag == 3) {
        NSArray *imgArr = [self.commentModel.pics componentsSeparatedByString:@","];
        array = [NSMutableArray arrayWithArray:imgArr];
    }
//
    if (browser.tag == 1) {
        [array removeObjectAtIndex:0];
    }
    NSString *imageName = array[index];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageName]];

    return url;
}

//大图占位图/或者本地图片展示
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
   
    UIImage *img = [UIImage imageNamed:@"zhanweitu"];
   
    return img;
}
-(void)settableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 88) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 44;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 头部轮播图
   
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
#pragma mark - 导航View
-(void)setHeadNavigationView{
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 110)];
    _customView.backgroundColor = RGB(0x0F7CFD);
    [self.view addSubview:_customView];
    //左上角返回按钮
    self.backView = [[UIImageView alloc] init];
    _backView.userInteractionEnabled = YES;
    
    _backView.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.7];
    _backView.layer.cornerRadius = 35/2;
    _backView.clipsToBounds = YES;
    [self.customView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        if (iPhoneX) {
            make.top.mas_equalTo(73);
        }else{
            make.top.mas_equalTo(49);
        }
        make.width.height.offset(35);
    }];
    self.backsButton = [[UIButton alloc] init];
    
    [_backsButton setTintColor:[UIColor colorWithWhite:1 alpha:0.7]];
    UIImage *reftImage = [[UIImage imageNamed:@"return"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_backsButton setImage:reftImage forState:UIControlStateNormal];
    [_backsButton setImage:reftImage forState:UIControlStateHighlighted];
    [_backsButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:_backsButton];
    [_backsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.offset(5);
        make.right.bottom.offset(-5);
    }];
    // 右上角收藏
    self.sharesView = [[UIImageView alloc] init];
    _sharesView.userInteractionEnabled = YES;
    
    _sharesView.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.7];
    _sharesView.layer.cornerRadius = 35/2;
    _sharesView.clipsToBounds = YES;
    [self.customView addSubview:_sharesView];
    [_sharesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
       
        if (iPhoneX) {
            make.top.mas_equalTo(73);
        }else{
            make.top.mas_equalTo(49);
        }
        make.width.height.offset(35);
    }];
    self.sharesButton = [[UIButton alloc] init];
    [_sharesButton setTintColor:[UIColor colorWithWhite:1 alpha:0.7]];
    
    [_sharesButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_sharesView addSubview:_sharesButton];
    [_sharesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(6);
        make.right.bottom.offset(-6);
    }];
  
    self.threeView = [[UIView alloc] init];
    _threeView.backgroundColor = [UIColor clearColor];
    [self.customView addSubview:_threeView];
    [_threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        if (iPhoneX) {
            make.top.mas_equalTo(73);
        }else{
            make.top.mas_equalTo(49);
        }
        make.height.mas_equalTo(40);
    }];
    [self setButtonsWithIndex:0 title:TransOutput(@"宝贝") superView:_threeView];
    [self setButtonsWithIndex:1 title:TransOutput(@"评价") superView:_threeView];
    [self setButtonsWithIndex:2 title:TransOutput(@"详情") superView:_threeView];

}
#pragma mark ---- 宝贝、详情、评价按钮
- (void)setButtonsWithIndex:(NSInteger)index title:(NSString *)title superView:(UIView *)superView{
    UIButton *btn = [[UIButton alloc]init];
    //默认样式
    NSMutableAttributedString *normalAttr = [[NSMutableAttributedString alloc] initWithString:title];
    NSDictionary *normalAttrDict = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName :RGB(0xA1A0A0)
                                     };
    [normalAttr addAttributes:normalAttrDict range:NSMakeRange(0, title.length)];
    [btn setAttributedTitle:normalAttr forState:UIControlStateNormal];
    
    //选中样式
    NSMutableAttributedString *selectAttr = [[NSMutableAttributedString alloc] initWithString:title];
    NSDictionary *selectAttrDict = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
    [selectAttr addAttributes:selectAttrDict range:NSMakeRange(0, title.length)];
    [btn setAttributedTitle:selectAttr forState:UIControlStateSelected];
    
    btn.tag = index;
    
    [btn addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    [superView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(index * ((WIDTH - 100) / 3.0));
        make.top.bottom.equalTo(superView);
        make.width.mas_equalTo(@((WIDTH - 100)/ 3.0));
    }];
    if (btn.tag == 0) {
        // 宝贝、详情、评价的按钮点击事件
        [self clickTitle:btn];
    }
    switch (btn.tag) {
        case 0:
            _goodsButton = btn;
            break;
        case 1:
            _pingjiaButton = btn;
            break;
        case 2:
            _detailButton = btn;
            break;
        default:
            break;
    }
}
// 宝贝、评价、详情点击事件
- (void)clickTitle:(UIButton *)sender{
    
  
    if (sender.tag == 0) {
        [self.tableView setContentOffset:CGPointMake(0, 139) animated:YES];
    }
    if (sender.tag == 1) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];

        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
 
        [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - 110) animated:YES];
    }
    if (sender.tag == 2) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];

        CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
 
        [self.tableView setContentOffset:CGPointMake(0, rect.origin.y - 150) animated:YES];

    }

}
#pragma mark - 收藏及取消收藏
-(void)shareButtonClick{
    if (account.isLogin) {
        [NetwortTool getAddOrCancelWithParm:@{@"prodId":self.prodId} Success:^(id  _Nonnull responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.isCollec == 1) {
                    ToastShow(TransOutput(@"取消收藏成功"), @"chenggong",RGB(0x36D053));

                }
                else{
                    ToastShow(TransOutput(@"收藏成功"), @"chenggong",RGB(0x36D053));
 
                }
            });
            [self getIsColl];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCollec" object:nil userInfo:nil];
            } failure:^(NSError * _Nonnull error) {
                ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
            }];
    }
    else{
        LoginViewController *vc = [[LoginViewController alloc] init];
        
        [self pushController:vc];
    }
}

#pragma mark --- UITableViewDelegate，UITableViewDataSource
// 区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if (section == 2) {
            return 52;
        }else{
            return 12;
        }
    }
}
// 区尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
// 分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
// 每个分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 1;
    }else{
        return self.imgHeigtArr.count;
    }
    
}
// 设置区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    if (section == 0) {
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
        else if (section == 2) {
            headerView.backgroundColor = [UIColor whiteColor];
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 12)];
            line.backgroundColor = RGB(0xF9F9F9);
            [headerView addSubview:line];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, WIDTH - 40, 30)];
            nameLabel.text = TransOutput(@"商品详情");
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.textColor = [UIColor darkGrayColor];
            [headerView addSubview:nameLabel];
            return headerView;
        }else{
            headerView.backgroundColor = RGB(0xF9F9F9);
         
        return headerView;
    }
}
// 设置cell上显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        GoodDetailImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailImagesTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"GoodDetailImagesTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        ImageModel *model = self.imgHeigtArr[indexPath.row];
        [cell.ima sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:model.url]] ];
    
        
    return cell;
    }
    else if (indexPath.section == 0){
        GoodDetailTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailTopTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"GoodDetailTopTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GoodDetailModel *model = [GoodDetailModel mj_objectWithKeyValues:self.dataDic];
        cell.model = model;
        if (self.couponsListArr.count > 0) {
            cell.updataHeight.constant = 63;
        }
        else{
            cell.updataHeight.constant = 13;
        }
        @weakify(self)
        [cell setShowCounponViewClickBlock:^{
            @strongify(self);

                [self showCounponView];

        }];
        
        [cell setSkuItemClickBlock:^(NSDictionary * _Nonnull skuDic) {
            @strongify(self);
            self.selecSkuDic = skuDic;
        }];
        [cell setShopClickBlock:^(NSString * _Nonnull shopId) {
            @strongify(self);
            HomeShopViewControll *vc = [[HomeShopViewControll alloc] init];
            vc.shopId = shopId;
            [self pushController:vc];
        }];
        return cell;
    }
    else{
        GoodDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailCommentTableViewCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"GoodDetailCommentTableViewCell" owner:self options:nil].lastObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.commentModel;
        cell.number = self.number;
        cell.positiveRating = self.positiveRating;
        cell.topHeight = 0;
        @weakify(self)
        [cell.topView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            if (account.isLogin) {
                GoodsCommonViewController *vc = [[GoodsCommonViewController alloc] init];
                vc.prodId = self.prodId;
                [self pushController:vc];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
                [self pushController:vc];
            }
        }];
        [cell setImgClickBlock:^(NSInteger index, UIView * _Nonnull tapView) {
            @strongify(self);

        }];
    return cell;
}
}
-(void)showCounponView{
    self.quanView.dataArray =[NSMutableArray arrayWithArray:self.couponsListArr] ;
                [self.view addSubview:self.quanView];
                [self.quanView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.leading.top.trailing.bottom.mas_offset(0);
                              }];
    @weakify(self);
    [self.quanView setLoginClickBlock:^{
        @strongify(self);
        [self.quanView removeFromSuperview];
        LoginViewController *vc =[[LoginViewController alloc] init];
        [self pushController:vc];
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 2) {
        ImageModel *model = self.imgHeigtArr[indexPath.row];
        if (isnan(model.imageH) ) {
            return 50;
        }else{
            return model.imageH;
        }
    }
    else if (indexPath.section == 0){
        GoodDetailModel *model = [GoodDetailModel mj_objectWithKeyValues:self.dataDic];
        CGFloat nameH = 11 + [Tool getLabelHeightWithText:model.prodName width:WIDTH - 32 font:14] + 11 +12 + 10 + 1 + 1;
        CGFloat priceH = 11 + 31 + 13 + 12;
        CGFloat shopH = 51+50 + 12;
        CGFloat skuH = 51+71 + 12;
        if (self.couponsListArr.count > 0) {
            return nameH + priceH + shopH + skuH + 50;
        }
        else{
            return nameH + priceH + shopH + skuH;
        }
        
    }
    else{
        if (self.commentArr.count == 0) {
            return 50;
        }else{
            return self.commentModel.rowH + 30;
        }
    }
}
#pragma mark NavigationBar
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([object isEqual:self.tableView] && [keyPath isEqualToString:@"contentOffset"]) {
        [self refreshNavigationBar];
    }
}
- (void)refreshNavigationBar {
    CGPoint offset = self.tableView.contentOffset;
    NSLog(@"%@",NSStringFromCGPoint(offset));
    CGFloat offsetY = offset.y;
    if (offset.y < 0) {
        
    } else if (offset.y == 0) {
        self.sharesView.hidden = NO;
        [self xialaChangeNavi:offsetY];
        // 导航栏左右按钮变换颜色
        self.backView.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.7];
        [self.backsButton setTintColor:[UIColor colorWithWhite:1 alpha:0.7]];
        self.sharesView.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.7];
        [self.sharesButton setTintColor:[UIColor colorWithWhite:1 alpha:0.7]];
    } else {
        self.sharesView.hidden = YES;
        [self xialaChangeNavi:offsetY];
        // 导航栏左右按钮变换颜色
        self.backView.backgroundColor = [UIColor clearColor];
        [self.backsButton setTintColor:[UIColor whiteColor]];
        self.sharesView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self.sharesButton setTintColor:[UIColor darkGrayColor]];
    }
}
- (void)xialaChangeNavi:(CGFloat)offY
{
    //通过offset.y与 图片高度 减去自定义头部高度再减去图片下标的偏移量 比例来决定透明度
    CGFloat alpha = MIN(1, fabs(offY/(AlphaOffSet - offY)));
    self.customView.backgroundColor = [RGB(0x0F7CFD) colorWithAlphaComponent:alpha];

    
    self.threeView.alpha = alpha;
    CGFloat comH = 0;
    if (self.commentArr.count == 0) {
        comH = 50;
    }
    else{
        comH = self.commentModel.rowH;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];

    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:0 inSection:2];

    CGRect rect2 = [self.tableView rectForRowAtIndexPath:indexPath2];
    if (offY < rect.origin.y - 120) {
        _goodsButton.selected = YES;
        _detailButton.selected = NO;
       _pingjiaButton.selected = NO;
    }
    if (offY > rect.origin.y - 120 && offY < rect2.origin.y - 160) {
        _goodsButton.selected = NO;
        _pingjiaButton.selected = YES;
       _detailButton.selected = NO;
    }
   
    if (offY > rect2.origin.y - 160 ) {
        _goodsButton.selected = NO;
        _pingjiaButton.selected = NO;
        _detailButton.selected = YES;
    }

}
// 试图将要出现的时候刷新导航内容
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshNavigationBar]; // 刷新高度以判断导航是透明还是不透明的
    [self.tableView addObserver:self forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                        context:nil];
    self.hbd_barHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.isShowTip = NO;
}
#pragma mark - 添加浏览记录
-(void)setJilu{
    NSDictionary *parm =@{@"userId":account.userInfo.userId,@"ProductId":self.prodId};
    NSLog(@"参数：%@",parm);
    [NetwortTool  getProdBrowseWithParm:parm Success:^(id  _Nonnull responseObject) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadFoot" object:nil userInfo:nil];
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
       
        }];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView removeObserver:self
                        forKeyPath:@"contentOffset"];
    self.hbd_barHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self.video pausePlayVideo];
}
#pragma mark - lazy
- (TSVideoPlayback *)video{
    if (!_video) {
        _video = [[TSVideoPlayback alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 383) ];
        _video.delegate = self;
    }
    return _video;
}
-(HomeGoodDetailWKBottomView *)bottomViewWK{
    if (!_bottomViewWK) {
        _bottomViewWK = [HomeGoodDetailWKBottomView initViewNIB];
        @weakify(self);
        [_bottomViewWK setPushCarClickBlock:^{
            @strongify(self);
            ShopCarViewController *vc =[[ShopCarViewController alloc] init];
            vc.isDetail = @"1";
            [self pushController:vc];
            
        }];
        [_bottomViewWK setJoinCarClickBlock:^{
            @strongify(self);
            if (account.isLogin) {
                self.joinCarView.selecSkuDic = self.selecSkuDic;
                self.joinCarView.isJoin = YES;
                [self.view addSubview:self.joinCarView];
                [self.joinCarView updataWithDic:self.dataDic];
                
                [self.joinCarView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.top.trailing.bottom.mas_offset(0);
                }];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
//                vc.isCancel = @"1";
                [self pushController:vc];
            }
            
           
        }];
        
        [_bottomViewWK setBuyClickBlock:^{
            @strongify(self);
            if (account.isLogin) {
                self.joinCarView.selecSkuDic = self.selecSkuDic;
                self.joinCarView.isJoin = NO;
                [self.view addSubview:self.joinCarView];
                [self.joinCarView updataWithDic:self.dataDic];
                
                [self.joinCarView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.top.trailing.bottom.mas_offset(0);
                }];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
//                vc.isCancel = @"1";
                [self pushController:vc];
            }
        }];
       
    }
    return _bottomViewWK;
}
-(HomeGoodDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [HomeGoodDetailBottomView initViewNIB];
        @weakify(self);
        [_bottomView setPushCarClickBlock:^{
            @strongify(self);
            if (account.isLogin) {
                ShopCarViewController *vc =[[ShopCarViewController alloc] init];
                vc.isDetail = @"1";
                [self pushController:vc];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
//                vc.isCancel = @"1";
                [self pushController:vc];
            }
            
        }];
        [_bottomView setJoinCarClickBlock:^{
            @strongify(self);
            if (account.isLogin) {
                self.joinCarView.selecSkuDic = self.selecSkuDic;
                self.joinCarView.isJoin = YES;
                [self.view addSubview:self.joinCarView];
                [self.joinCarView updataWithDic:self.dataDic];
                
                [self.joinCarView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.top.trailing.bottom.mas_offset(0);
                }];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
//                vc.isCancel = @"1";
                [self pushController:vc];
            }

        }];
        
        [_bottomView setBuyClickBlock:^{
            @strongify(self);
            if (account.isLogin) {
                self.joinCarView.selecSkuDic = self.selecSkuDic;
                self.joinCarView.isJoin = NO;
                [self.view addSubview:self.joinCarView];
                [self.joinCarView updataWithDic:self.dataDic];
                
                [self.joinCarView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.top.trailing.bottom.mas_offset(0);
                }];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
//                vc.isCancel = @"1";
                [self pushController:vc];
            }
        }];
        [_bottomView setKefuClickBlock:^{
            @strongify(self);
            if (account.isLogin) {
            MineMessDetailViewController *vc= [[MineMessDetailViewController alloc] init];
            vc.dataDic = self.dataDic;
            vc.isDetail = YES;
            vc.ImsgChannel = @"";
            vc.FromUserId = account.userInfo.userId;
            vc.ToUserId = self.dataDic[@"shopUserId"];
            vc.selDic = self.selecSkuDic;
            [self pushController:vc];
            }
            else{
                LoginViewController *vc = [[LoginViewController alloc] init];
//                vc.isCancel = @"1";
                [self pushController:vc];
            }
        }];
    }
    return _bottomView;
}
-(HomeQuanView *)quanView{
    if (!_quanView) {
        _quanView = [HomeQuanView initViewNIB];
        _quanView.backgroundColor = [UIColor clearColor];
        
    }
    return _quanView;
}

-(JoinShopCartView *)joinCarView{
    if (!_joinCarView) {
        _joinCarView = [JoinShopCartView initViewNIB];
        _joinCarView.backgroundColor = [UIColor clearColor];
        @weakify(self);
        [_joinCarView setJoinItemClickBlock:^(NSDictionary * _Nonnull dic, CGFloat num) {
            @strongify(self);
            
            [self joinCar:dic num:num];
            
        }];
        [_joinCarView setNowBuyClickBlock:^(NSDictionary * _Nonnull dic, CGFloat num) {
            @strongify(self);
            [self pushSureOrder:dic num:num];
            
        }];
    }
    return _joinCarView;
}
#pragma mark - 加入购物车
-(void)joinCar:(NSDictionary*)dic num:(CGFloat)number{
    NSDictionary *parm = @{@"prodId":self.prodId,@"skuId":dic[@"skuId"],@"shopId":self.dataDic[@"shopId"],@"count":@(number),@"basketId":@"0"};
    [NetwortTool getJoinShopCarWithParm:parm Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"加入成功"), @"chenggong",RGB(0x36D053));
       
        [self.joinCarView removeFromSuperview];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
        

    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
#pragma mark - 生成订单
-(void)pushSureOrder:(NSDictionary*)dic num:(CGFloat)number{
    [self.joinCarView removeFromSuperview];
    
       
     
    if (!self.isShowTip) {
        self.isShowTip = YES;
        
        NSDictionary *parm = @{@"basketIds":@[],@"orderItem":@{@"prodId":self.prodId,@"skuId":dic[@"skuId"],@"prodCount":@(number),@"shopId":self.self.dataDic[@"shopId"]},@"addrId":@"0"};
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
