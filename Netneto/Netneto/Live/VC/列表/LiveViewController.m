//
//  LiveViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "LiveViewController.h"

@interface LiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)LiveStartButtonView *startBtnView;
@property(nonatomic, strong)LiveStartShowView *startShowView;
@property(nonatomic, strong)NSString *channel;
@property (nonatomic, strong) NothingView *nothingView;
@property(nonatomic, strong)NSString *showRole;
@end

@implementation LiveViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
    }
    [self.view addSubview:self.collectionView];
    if ([account.userInfo.merchant isEqual:@"1"]) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(109);
            make.bottom.mas_equalTo(-69);
            
        }];
        [self.view addSubview:self.startBtnView];
        [self.startBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.mas_offset(0);
            make.height.mas_offset(69);
        }];
        
    }else{
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(0);
            make.top.mas_equalTo(109);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            
        }];
    }
    self.navigationItem.title = TransOutput(@"直播列表");
   
}
-(void)initData{
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    
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
-(void)rightClick{
    if (account.isLogin) {
        
    
    followLiveViewController *vc = [[followLiveViewController alloc] init];
    
    [self pushController:vc];
}else{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self pushController:vc];
}
}
-(void)CreateView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
   
   
}
-(void)GetData{
   
    [NetwortTool getLiveListWithParm:@{@"pageSize":@(10),@"pageNum":@(self.page)} Success:^(id  _Nonnull responseObject) {
        NSLog(@"直播列表:%@",responseObject);
        
  
        NSArray *arr = responseObject;
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            if (arr.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.collectionView.backgroundView = self.nothingView;
         
      }
      else{
         
          self.collectionView.backgroundView = nil;
      }
      
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
         
        }];
    
   
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.dataArr.count;
    
  
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LiveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveListCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LiveListCollectionViewCell" owner:self options:nil].lastObject;
    }
    NSDictionary *dic;
 
        dic= self.dataArr[indexPath.row];
    cell.dataDic = dic;
  
      return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.collectionView.userInteractionEnabled = NO;
    [NetwortTool getRtmInfoUserWithParm:@{@"userId":[NSString isNullStr:account.userInfo.userId],@"uid":[NSString isNullStr:account.userInfo.uid],@"channel":[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"channel"]]} Success:^(id  _Nonnull responseObject) {
         NSString *joinStatus = [NSString stringWithFormat:@"%@",responseObject[@"joinStatus"]];
        
        if ([joinStatus isEqual:@"1"]) {
            [self.startShowView removeFromSuperview];
            
            [self joinRoom:self.dataArr[indexPath.row] daDic:responseObject];
            

        }else{
            self.collectionView.userInteractionEnabled = YES;
            ToastShow(TransOutput(@"您已被踢出该房间"), errImg,RGB(0xFF830F));
            
        }
    } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        self.collectionView.userInteractionEnabled = YES;
        }];
     
}
-(void)joinRoom:(NSDictionary *)dic daDic:(NSDictionary *)dt{
    
    [NetwortTool getLookRoomMsgWithParm:@{@"channel":dic[@"channel"]} Success:^(id  _Nonnull responseObject) {
        NSString *showStatus =[NSString stringWithFormat:@"%@",responseObject[@"showStatus"]];
        if ([showStatus isEqual:@"1"]) {
            self.collectionView.userInteractionEnabled = YES;
            lookVideoViewController *vc = [[lookVideoViewController alloc] init];
            vc.channel = [NSString stringWithFormat:@"%@",dic[@"channel"]];
            vc.userId = [NSString stringWithFormat:@"%@",dt[@"userId"]];
            vc.uid = [NSString stringWithFormat:@"%@",dt[@"uid"]];
            vc.dataDic = dic;
            vc.showtype = [NSString stringWithFormat:@"%@",responseObject[@"showType"]];
            [self pushController:vc];
        }
        else{
            self.collectionView.userInteractionEnabled = YES;
            ToastShow(TransOutput(@"主播暂未开播"), errImg,RGB(0xFF830F));
            return;
        }
    } failure:^(NSError * _Nonnull error) {
        self.collectionView.userInteractionEnabled = YES;
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
#pragma mark - 添加修改房间信息
-(void)creatLiveRoom:(NSString *)name noti:(NSString *)notif pic:(NSString *)picStr msg:(RoomInfoModel *)msg infoDic:(NSDictionary *)infoDic{
    
    NSDictionary *dic;
    dic= @{@"notice":notif,@"shopLogo":[NSString isNullStr:infoDic[@"shopLogo"]],@"shopName":msg.shopName,@"userId":account.userInfo.userId,@"channel":self.channel,@"shopId":msg.shopId,@"showRole":msg.showRole,@"showRoleId":[NSString isNullStr:msg.showRoleId],@"userCount":@"1",@"imgPath":picStr,@"msg":name,@"showStatus":@"1",@"showType":@"1",};
    
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


#pragma mark - lazy
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
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((WIDTH - 64) / 2,263 - 17);
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"LiveListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LiveListCollectionViewCell"];
        @weakify(self);
        _collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self GetData];
        }];
        _collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self GetData];
        }];
        }
    return _collectionView;
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
//        [_startShowView setStartLiveBlock:^(NSString * _Nonnull title, NSString * _Nonnull noti, NSString * _Nonnull pic, RoomInfoModel * _Nonnull model) {
//            if ([model.showRole isEqual:@"0"]) {
//                ToastShow(TransOutput(@"直播被封禁"), errImg, RGB(0xFF830F));
//                return;
//            }
//            @strongify(self);
//            
//            [self getShopInfo:title noti:noti pic:pic msg:model];
//        }];
        
        [_startShowView setPushLiveXieyiClickBlock:^{
            @strongify(self);
            
            MineWebKitViewController *vc =[[MineWebKitViewController alloc] init];
            vc.url = @"https://netneto.com/live_streaming_policy.html";
            [self pushController:vc];
        }];
    }
    return _startShowView;
}
-(void)getShopInfo:(NSString *)name noti:(NSString *)notif pic:(NSString *)picStr msg:(RoomInfoModel *)msg{
    [NetwortTool getShopApplyListWithParm:@{} Success:^(id  _Nonnull responseObject) {
        NSArray *arr =responseObject;
        if (arr.count > 0) {
            [self creatLiveRoom:name noti:notif pic:picStr msg:msg infoDic:arr.firstObject];
        }
      
    } failure:^(NSError * _Nonnull error) {
        
      
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
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无直播");
        _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nothingView;
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
