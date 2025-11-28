//
//  LiveMainViewController.m
//  Netneto
//
//  Created by apple on 2025/2/25.
//

#import "LiveMainViewController.h"

@interface LiveMainViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *pageView;
@property (nonatomic, strong) JXCategoryListContainerView *pageContainView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@property(nonatomic, strong)LiveStartButtonView *startBtnView;
@property(nonatomic, strong)LiveStartShowView *startShowView;
@property(nonatomic, strong)NSString *channel;
@property (nonatomic, strong) NothingView *nothingView;
@property(nonatomic, strong)NSString *showRole;
@property(nonatomic, strong)NSArray *dataArray;
@end

@implementation LiveMainViewController
-(void)initData{
   
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
       [rightButtonView addSubview:rightButton];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitle:TransOutput(@"我的关注") forState:UIControlStateNormal];
       [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGB(0xFFFFFF) forState:UIControlStateNormal];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
      self.navigationItem.rightBarButtonItem = rightCunstomButtonView;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.startShowView removeFromSuperview];
    [self CreateViewUI];
}
-(void)rightClick{
    if (account.isLogin) {
        
    
    followLiveViewController *vc = [[followLiveViewController alloc] init];
    
    [self pushController:vc];
}else{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self pushController:vc];
}
}

- (void)CreateViewUI {
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.bgHeaderView removeFromSuperview];
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"直播列表");
    if ([account.userInfo.merchant isEqual:@"1"]) {
        [self.startBtnView removeFromSuperview];
        [self.view addSubview:self.startBtnView];
        [self.startBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.mas_offset(0);
            make.height.mas_offset(69);
        }];
        
    }
   
    [self.searchView removeFromSuperview];
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(109);
        make.leading.mas_offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_offset(37);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_offset(-16);
        make.top.mas_offset(11);
        make.width.height.mas_offset(15);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(self.SearchImageView.mas_leading).offset(-10);
        make.top.mas_offset(8.5);
        make.height.mas_offset(20);
    }];


    [self.pageView removeFromSuperview];
[self.view addSubview:self.pageView];
    [self.pageContainView removeFromSuperview];
[self.view addSubview:self.pageContainView];
    if ([account.userInfo.merchant isEqual:@"1"]) {
        [self.pageContainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_offset(0);
            make.top.mas_offset(self.pageView.bottom + 10);
            make.bottom.mas_equalTo(-69);
        }];
        
    }
    else{
        [self.pageContainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_offset(0);
            make.top.mas_offset(self.pageView.bottom + 10);
            make.bottom.mas_equalTo(-10);
        }];
    }
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetUserInfo) name:@"uploadUserInfo" object:nil];
    // Do any additional setup after loading the view.
}
-(void)resetUserInfo{
//    if (!self.startShowView) {
    
    
//    [self.startShowView removeFromSuperview];
        if ([account.userInfo.merchant isEqual:@"1"]) {
            [self.pageContainView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.mas_equalTo(-69);
            }];
            [self.startBtnView removeFromSuperview];
            [self.view addSubview:self.startBtnView];
            [self.startBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.bottom.trailing.mas_offset(0);
                make.height.mas_offset(69);
            }];
        }
        else{
            [self.startBtnView removeFromSuperview];
            [self.pageContainView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.mas_equalTo(-10);
            }];
        }
//    }
    
}
-(void)GetData{
   
    [NetwortTool getLiveCategorizelistWithParm:@{} Success:^(id  _Nonnull responseObject) {
        NSLog(@"直播分类列表:%@",responseObject);
        self.dataArray = responseObject;
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:TransOutput(@"全部")];
        for (NSDictionary *dic in self.dataArray) {
            [arr addObject:dic[@"categoryName"]];
        }
        
        self.pageView.titles = arr;
        [self.pageView reloadData];
      
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
         
         
        }];
    
   
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.pageContainView didClickSelectedItemAtIndex:index];
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    LiveMainChildViewController *vc = [[LiveMainChildViewController alloc] init];
    if (index == 0) {
        vc.CategoryId = @"";
    }else{
        vc.CategoryId = [NSString stringWithFormat:@"%@",self.dataArray[index - 1][@"showCategoryId"]];
    }
        return vc;

}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.pageView.titles.count;;
}
-(void)chosePic{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choseImgType:UIImagePickerControllerSourceTypePhotoLibrary ];
    }];
    [photoAlbumAction setValue:RGB(0x333333) forKey:@"_titleTextColor"];
  
    UIAlertAction *takeAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choseImgType:UIImagePickerControllerSourceTypeCamera];
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
-(void)choseImgType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqual:@"public.image"]) {
        [HudView showHudForView:self.view];
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

    
        UIImage *imageW = [Tool OriginImage:image scaleToSize:CGSizeMake(80, 80)];
      
        [self.startShowView.picBtn setBackgroundImage:imageW forState:UIControlStateNormal];
        [self.startShowView.picBtn setTitle:@"" forState:UIControlStateNormal];
        [self.startShowView.picBtn setImage:[UIImage new] forState:UIControlStateNormal];
      

        [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
           
        } success:^(id  _Nonnull responseObject) {
            [HudView hideHudForView:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
            });
            self.startShowView.pic = responseObject[@"data"];
            
        }];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - lazy
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 18.5;
        _searchView.clipsToBounds = YES;
        _searchView.userInteractionEnabled = YES;
        _searchView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xF7F7F7),RGB(0xF7F7F7)] withWidth:WIDTH - 32];
        @weakify(self);
        [_searchView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            
            if (account.isLogin) {
                SearchLiveViewController *vc =[[SearchLiveViewController alloc] init];
                [self pushController:vc];
            }else{
                SearchLiveResultViewController *vc = [[SearchLiveResultViewController alloc] init];
                vc.queryParam = @"";
                [self pushController:vc];
            }
        }];

    }
    return _searchView;
}
-(UIImageView *)SearchImageView{
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = NO;
       
    }
    return _SearchImageView;;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = NO;
        _searchTF.delegate = self;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.placeholder = TransOutput(@"搜索");
    }
    return _searchTF;
}
- (JXCategoryTitleView *)pageView {
    if (!_pageView) {
        
            _pageView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 109+47, WIDTH , 43)];
        
        _pageView.backgroundColor = [UIColor whiteColor];
//        _pageView.titles = @[@"1",@"2"];
        _pageView.averageCellSpacingEnabled = NO;
        _pageView.delegate = self;
        _pageView.contentEdgeInsetLeft = 10;
        _pageView.contentEdgeInsetRight = 10;
        _pageView.cellWidthIncrement = 2;
        _pageView.cellSpacing = 20;
        _pageView.titleColor = RGB(0x717272);
        _pageView.titleSelectedColor = [UIColor gradientColorArr:MainColorArr withWidth:100];
        _pageView.titleFont = [UIFont systemFontOfSize:14];
      
        _pageView.titleLabelZoomEnabled = YES;
        _pageView.titleLabelZoomScale = 1.0;
        _pageView.titleColorGradientEnabled = YES;
        _pageView.listContainer = self.pageContainView;
        
        JXCategoryIndicatorLineView *indictView = [[JXCategoryIndicatorLineView alloc] init];
        indictView.indicatorWidth = 33;
        indictView.indicatorHeight = 3;
        indictView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
        indictView.indicatorColor = [UIColor gradientColorArr:MainColorArr withWidth:100];
        indictView.indicatorCornerRadius = 1.5;
        indictView.verticalMargin = 0;
        _pageView.indicators = @[indictView];
    }
    return _pageView;
}

- (JXCategoryListContainerView *)pageContainView {
    if (!_pageContainView) {
        _pageContainView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _pageContainView.backgroundColor = [UIColor whiteColor];
       
        
    }
    return _pageContainView;
}
-(LiveStartButtonView *)startBtnView
{
    if (!_startBtnView) {
        _startBtnView = [[LiveStartButtonView alloc] init];
        @weakify(self);
        [_startBtnView setStartLiveBtnClickBlock:^{
            @strongify(self);
            [self getRoomInfo];
           
        }];
    }
    return _startBtnView;
}
-(LiveStartShowView *)startShowView{
    if (!_startShowView) {
        _startShowView = [LiveStartShowView initViewNIB];
        _startShowView.backgroundColor = [UIColor clearColor];
        @weakify(self);
        [_startShowView setPicClickBlock:^{
            @strongify(self);
            [self chosePic];
            
        }];
        [_startShowView setStartLiveBlock:^(NSString * _Nonnull title, NSString * _Nonnull noti, NSString * _Nonnull pic, RoomInfoModel * _Nonnull model, NSString * _Nonnull categoryId, NSString * _Nonnull categoryName) {
        
            if ([model.showRole isEqual:@"0"]) {
                ToastShow(TransOutput(@"直播被封禁"), errImg, RGB(0xFF830F));
                return;
            }
            @strongify(self);
            
            [self getShopInfo:title noti:noti pic:pic msg:model CategoryId:categoryId CategoryName:categoryName];
        }];
        [_startShowView setCategoryChoseClickBlock:^{
            @strongify(self);
            [self typeChose];
        }];
        [_startShowView setPushLiveXieyiClickBlock:^{
            @strongify(self);
            
            MineWebKitViewController *vc =[[MineWebKitViewController alloc] init];
            vc.url = @"https://netneto.com/live_streaming_policy.html";
            [self pushController:vc];
        }];
    }
    return _startShowView;
}
-(void)typeChose{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TransOutput(@"请选择类型") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     
    for (int i = 0; i < self.dataArray.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:self.dataArray[i][@"categoryName"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击后的操作
            NSLog(@"点击了%@", action.title);
            self.startShowView.categoryNameDic = self.dataArray[i];
//            [self.liveClassTypeBtn setTitle:self.categoryNameArray[i][@"categoryName"] forState:UIControlStateNormal];
            
//            self.dictType = [NSString isNullStr:arr[i][@"dictCode"]];
        }];
        [alertController addAction:action];
      
    }
     
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TransOutput(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}
-(void)getShopInfo:(NSString *)name noti:(NSString *)notif pic:(NSString *)picStr msg:(RoomInfoModel *)msg CategoryId:(NSString *)categoryId CategoryName:(NSString *)categoryName{
    [NetwortTool getShopApplyListWithParm:@{} Success:^(id  _Nonnull responseObject) {
        NSArray *arr =responseObject;
        if (arr.count > 0) {
            [self creatLiveRoom:name noti:notif pic:picStr msg:msg infoDic:arr.firstObject CategoryId:categoryId CategoryName:categoryName];
        }
      
    } failure:^(NSError * _Nonnull error) {
        
      
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}

#pragma mark - 添加修改房间信息
-(void)creatLiveRoom:(NSString *)name noti:(NSString *)notif pic:(NSString *)picStr msg:(RoomInfoModel *)msg infoDic:(NSDictionary *)infoDic CategoryId:(NSString *)categoryId CategoryName:(NSString *)categoryName{
    
    NSDictionary *dic;
    dic= @{@"notice":notif,@"shopLogo":[NSString isNullStr:infoDic[@"shopLogo"]],@"shopName":msg.shopName,@"userId":account.userInfo.userId,@"channel":self.channel,@"shopId":msg.shopId,@"showRole":msg.showRole,@"showRoleId":[NSString isNullStr:msg.showRoleId],@"userCount":@"1",@"imgPath":picStr,@"msg":name,@"showStatus":@"1",@"showType":@"1",@"showCategoryId":categoryId,@"showCategoryName":categoryName};
    
    [NetwortTool getAddRoomMsgWithParm:dic Success:^(id  _Nonnull responseObject) {
        [self.startShowView removeFromSuperview];
        StartVideoViewController *vc = [[StartVideoViewController alloc] init];
        vc.channel = self.channel;
        vc.shopId = msg.shopId;
        vc.getLiveDic = dic;
        [self pushController:vc];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}

-(void)getRoomInfo{
    [NetwortTool getRoomMsgWithSuccess:^(id  _Nonnull responseObject) {
        RoomInfoModel *model = [RoomInfoModel mj_objectWithKeyValues:responseObject];
        
        [self.startShowView updataModel:model];
        self.channel = model.channel;
        [self.view addSubview:self.startShowView];
        
        [self.startShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.mas_offset(0);
           
        }];
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
