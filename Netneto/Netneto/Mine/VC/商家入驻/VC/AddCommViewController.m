//
//  AddCommViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/11.
//

#import "AddCommViewController.h"

@interface AddCommViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,SDPhotoBrowserDelegate>{
    MBProgressHUD *hud;
}
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *shopTitle;
@property (weak, nonatomic) IBOutlet UILabel *skuName;
@property (weak, nonatomic) IBOutlet UIButton *goodComBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhongComBtn;
@property (weak, nonatomic) IBOutlet UIButton *chaComBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *nimingBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic ,assign) NSInteger i;
@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) NSMutableArray *imageDataArray;
@property (nonatomic ,strong) NSMutableArray *picArray;
//@property (nonatomic ,strong) ZYQAssetPickerController *pickerController;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong)NSString *evaluate;
@property (nonatomic, strong)NSString *isAnonymous;
@end

@implementation AddCommViewController
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
    self.picArray = [NSMutableArray array];
    self.evaluate = @"";
    self.isAnonymous = @"0";
}
-(void)CreateView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"写评论");
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[NSString isNullStr:self.model.pic]]];
    self.shopTitle.text = [NSString isNullStr:self.model.prodName];
    self.skuName.text = [NSString isNullStr:self.model.skuName];
    [self.goodComBtn setImage:[UIImage imageNamed:@"negative_reviews_icon"] forState:UIControlStateNormal];
    [self.goodComBtn setTitle:TransOutput(@"差评") forState:UIControlStateNormal];
    [self.goodComBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
    [self.goodComBtn addTapAction:^(UIView * _Nonnull view) {
        self.goodComBtn.backgroundColor = RGB(0xD7EDFD);
        [self.goodComBtn setTitleColor:RGB(0x5D84A8) forState:UIControlStateNormal];
        self.zhongComBtn.backgroundColor = [UIColor systemGray5Color];
        [self.zhongComBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.chaComBtn.backgroundColor = [UIColor systemGray5Color];
        [self.chaComBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.evaluate = @"2";
    }];
    
    [self.zhongComBtn setImage:[UIImage imageNamed:@"mid_reviews_icon"] forState:UIControlStateNormal];
    [self.zhongComBtn setTitle:TransOutput(@"中评") forState:UIControlStateNormal];
    [self.zhongComBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
    [self.zhongComBtn addTapAction:^(UIView * _Nonnull view) {
        self.zhongComBtn.backgroundColor = RGB(0xD7EDFD);
        [self.zhongComBtn setTitleColor:RGB(0x5D84A8) forState:UIControlStateNormal];
        self.goodComBtn.backgroundColor = [UIColor systemGray5Color];
        [self.goodComBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.chaComBtn.backgroundColor = [UIColor systemGray5Color];
        [self.chaComBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.evaluate = @"1";
    }];
    
    [self.chaComBtn setImage:[UIImage imageNamed:@"positive_reviews_icon"] forState:UIControlStateNormal];
    [self.chaComBtn setTitle:TransOutput(@"好评") forState:UIControlStateNormal];
    [self.chaComBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
    [self.chaComBtn addTapAction:^(UIView * _Nonnull view) {
        self.chaComBtn.backgroundColor = RGB(0xD7EDFD);
        [self.chaComBtn setTitleColor:RGB(0x5D84A8) forState:UIControlStateNormal];
        self.goodComBtn.backgroundColor = [UIColor systemGray5Color];
        [self.goodComBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        self.zhongComBtn.backgroundColor = [UIColor systemGray5Color];
        [self.zhongComBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.evaluate = @"0";
    }];
    
    [self.textView setPlaceholderWithText:TransOutput(@"你的感受很重要，展开写写吧") Color:RGB(0xB3B3B3)];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
   [self.collectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
   
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(16);
        make.trailing.mas_offset(-16);
        make.height.mas_equalTo(82);
    }];
    
    
    CGFloat w = [Tool getLabelWidthWithText:TransOutput(@"匿名评价") height:32 font:16];
    [self.nimingBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
    [self.nimingBtn setTitle:TransOutput(@"匿名评价") forState:UIControlStateNormal];
    [self.nimingBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
    @weakify(self);
    [self.nimingBtn addTarget:self action:@selector(niClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    [self.subBtn setTitle:TransOutput(@"投稿") forState:UIControlStateNormal];
    self.subBtn.backgroundColor =  [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [self.subBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self subClick];
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)niClick:(UIButton *)sender{
    if (!sender.selected) {
        sender.selected = YES;
        [self.nimingBtn setImage:[UIImage imageNamed:@"组合 132"] forState:UIControlStateNormal];
        [self.nimingBtn setTitle:TransOutput(@"匿名评价") forState:UIControlStateNormal];
         [self.nimingBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        self.isAnonymous = @"1";
    }
    else{
        sender.selected = NO;
        [self.nimingBtn setImage:[UIImage imageNamed:@"椭圆 7"] forState:UIControlStateNormal];
        [self.nimingBtn setTitle:TransOutput(@"匿名评价") forState:UIControlStateNormal];
         [self.nimingBtn layoutButtonWithButtonStyle:ButtonStyleImageLeftTitleRight imageTitleSpace:10];
        self.isAnonymous = @"0";
    }
}
-(void)subClick{
    if (self.evaluate.length == 0) {
        ToastShow(TransOutput(@"请选择评分"), errImg,RGB(0xFF830F));
        return;
    }
    if (self.textView.text.length == 0) {
        ToastShow(TransOutput(@"请输入评论内容"), errImg,RGB(0xFF830F));
        return;
    }
    NSString *score;
    if ([self.evaluate isEqual:@"0"]) {
        score = @"5";
    }
    if ([self.evaluate isEqual:@"1"]) {
        score =@"3";
    }
    if ([self.evaluate isEqual:@"2"]) {
        score = @"1";
    }
    [NetwortTool getAddProdCommWithParm:@{@"prodId":self.model.prodId,@"orderItemId":self.model.orderItemId,@"score":score,@"content":self.textView.text,@"pics":[self.picArray componentsJoinedByString:@","],@"isAnonymous":self.isAnonymous,@"evaluate":self.evaluate} Success:^(id  _Nonnull responseObject) {
        ToastShow(TransOutput(@"评价成功"),@"chenggong",RGB(0x36D053));
        [self popViewControllerAnimate];
        
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.imageArray.count + 1 ;
      
  

    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
         
        if (self.imageArray.count == 0) {
            AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
        
                [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
                [cell1.addImageV setTitle:TransOutput(@"添加图片") forState:UIControlStateNormal];
            [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            return cell1;
            
        }else{
            
            
            if (indexPath.item == 0 ) {
                AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
            
                    [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
                    [cell1.addImageV setTitle:TransOutput(@"添加图片") forState:UIControlStateNormal];
                [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            
                return cell1;
                
                
            }else{
                CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                
                    cell.imageV.image = self.imageArray[indexPath.item -1];
            
                [cell.imageV addSubview:cell.deleteButotn];
                cell.deleteButotn.tag = indexPath.item - 1 + 100;
                [cell.deleteButotn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
          
        }
    

    
    
}
- (void)deleteImage:(UIButton *)sender{
   
        NSInteger index = sender.tag - 100;
       
        //移除沙盒数组中imageDataArray的数据
//    if (self.imageDataArray.count == self.imageArray.count) {
//        [self.imageDataArray removeObjectAtIndex:index];
//    }
    //移除显示图片数组imageArray中的数据
    [self.imageArray removeObjectAtIndex:index];
    [self.picArray removeObjectAtIndex:index];
    
        NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取Document文件的路径
        NSString *collectPath = filePath.lastObject;
        NSFileManager * fileManager = [NSFileManager defaultManager];
        //移除所有文件
        [fileManager removeItemAtPath:collectPath error:nil];
        //重新写入
        for (int i = 0; i < self.imageDataArray.count; i++) {
            NSData *imgData = self.imageDataArray[i];
            [self WriteToBox:imgData];
        }
        
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
    NSData *imageData=UIImageJPEGRepresentation(image, 1);

        [self.imageDataArray addObject:imageData];
        [self WriteToBox:imageData];
    [self uploadImage:image];
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

                                       [self.collectionView reloadData];
                                     
                                       return;
                                   }
                               }
                               [self.imageDataArray addObject:imageData];
                               [self WriteToBox:imageData];
                        
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
                           [self.imageDataArray addObject:imageData];
                           [self WriteToBox:imageData];
            
                           [self.imageArray addObject:result];
                           [imageDatas addObject:imageData];
//
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

            
        });
   
       });
   
  
       [self dismissViewControllerAnimated:YES completion:^{
   
               [self.collectionView reloadData];
   
   
       }];

  
}



-(void)uploadImageArray:(NSArray *)array{
//    if (index == 0) {
       
//    }
    if (array.count > 0) {
        
   
    
        [UploadElement UploadElementWithImageArr:array name:@"imagedefault" progress:^(NSString * _Nonnull percent) {
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self->hud.label.text = percent;
    
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
              
            });
            //            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
            NSArray *arr = [responseObject[@"data"] componentsSeparatedByString:@","];
            for (NSString *str  in arr) {
                [self.picArray addObject: str];
            }
        }
    }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }
}

-(void)uploadImage:(UIImage *)image{
   
    [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
        
    } success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
            [self.picArray addObject: responseObject[@"data"]];
            if (self.picArray.count == self.imageArray.count) {
                [HudView hideHudForView:self.view];
            }
        });
//            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
       
    }];
}

//选择图片上限提示
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"到达9张图片上限") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
      } cancelBlock:^{
    }];
    [alert show];
   
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
- (NSMutableArray *)imageArray{
       if (!_imageArray) {
           self.imageArray = [NSMutableArray array];
          
       }
       return _imageArray;
}
- (NSMutableArray *)imageDataArray{
        if (!_imageDataArray) {
            self.imageDataArray = [NSMutableArray array];
        }
        return _imageDataArray;
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
