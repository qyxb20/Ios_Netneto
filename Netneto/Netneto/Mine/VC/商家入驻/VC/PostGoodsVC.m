//
//  PostGoodsVC.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/5.
//

#import "PostGoodsVC.h"

@interface PostGoodsVC ()<UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
{
    UIButton *selectedBtn;
}
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTX;
//@property (nonatomic ,strong) ZYQAssetPickerController *pickerController;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic ,strong) NSArray *classArray;
@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) NSMutableArray *imageDataArray;
@property (nonatomic ,assign) NSInteger i;
@property (weak, nonatomic) IBOutlet UIView *topiew;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UIButton *choseFreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *desNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *desTX;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodDetailLabel;
@property (strong, nonatomic) UICollectionView *detailCollectionView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
//@property (nonatomic ,strong) ZYQAssetPickerController *pickerControllerDetail;
@property (nonatomic, strong) UIImagePickerController *pickerControllerDetail;
@property (nonatomic ,strong) NSMutableArray *imageArrayDetail;
@property (nonatomic ,strong) NSMutableArray *imageDataArrayDetail;
@property (nonatomic ,assign) NSInteger j;
@property (strong, nonatomic) UIScrollView *classScroll;
@property (strong, nonatomic) NSString *categoryNameSel;
@property (strong, nonatomic) NSString *categoryId;
@property (nonatomic ,strong) NSMutableArray *picArray;
@property (nonatomic ,strong) NSMutableArray *picDetailArray;
@end

@implementation PostGoodsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"发布商品");
    self.i = 0;
   
    
     [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    [self.topiew addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(5);
        make.trailing.mas_offset(-5);
        make.top.mas_equalTo(self.nameTX.mas_bottom).offset(5);
        make.bottom.mas_offset(-5);
    }];
    [self.detailCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
   [self.detailCollectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
   [self.detailView addSubview:self.detailCollectionView];
   [self.detailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.mas_offset(5);
       make.trailing.mas_offset(-5);
       make.top.mas_equalTo(self.goodDetailLabel.mas_bottom).offset(3);
       make.bottom.mas_offset(-5);
   }];
    self.nameLabel.text = TransOutput(@"产品名称");
    self.nameNumberLabel.text  = @"0/30";
    [self.nameTX setPlaceholderWithText:TransOutput(@"请写明品牌、商品名、属性、规格等关键信息") Color:RGB(0xB3B3B3)];
    self.nameTX.delegate = self;
   
    self.topiew.backgroundColor = [UIColor whiteColor];
    
    self.classLabel.text = TransOutput(@"产品分类");
   
    self.classScroll = [[UIScrollView alloc] init];
    self.classScroll.scrollEnabled = YES;
    
    self.classScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.classScroll];
  
    [self.classScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.classLabel.mas_trailing).offset(10);
        make.trailing.mas_offset(-26);
        make.top.mas_equalTo(self.classLabel.mas_top).mas_offset(-14);
        make.height.mas_offset(44);
    }];
    
    self.freeLabel.text = TransOutput(@"运费模版");
    [self.choseFreeBtn setTitle:TransOutput(@"请选择") forState:UIControlStateNormal];
    [self.choseFreeBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    self.goodsDesLabel.text = TransOutput(@"产品卖点");
    self.desNumberLabel.text = @"0/500";
    self.desTX.delegate = self;
    [self.desTX setPlaceholderWithText:TransOutput(@"请输入产品卖点") Color:RGB(0xB3B3B3)];
    self.goodDetailLabel.text = TransOutput(@"商品详情");
    [self.nextBtn setTitle:TransOutput(@"下一步") forState:UIControlStateNormal];
    
    self.nextBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    @weakify(self);
    [self.nextBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self)
        [self pushNext];
    }];
}
-(void)pushNext{
    if (self.nameTX.text.length == 0) {
        ToastShow(TransOutput(@"请写明品牌、商品名、属性、规格等关键信息"), errImg, RGB(0xFF830F));
        return;
    }
    else if (self.picArray.count == 0){
        ToastShow(TransOutput(@"请上传商品图片"), errImg, RGB(0xFF830F));
        return;
    }
    else if (self.categoryNameSel.length== 0){
        ToastShow(TransOutput(@"请选择商品分类"), errImg, RGB(0xFF830F));
        return;
    }
    else if (self.categoryNameSel.length== 0){
        ToastShow(TransOutput(@"请选择商品分类"), errImg, RGB(0xFF830F));
        return;
    }
}
- (IBAction)choseFreeClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"送料無料") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.choseFreeBtn setTitle:TransOutput(@"送料無料") forState:UIControlStateNormal];
    }];
    [photoAlbumAction setValue:RGB(0x333333) forKey:@"_titleTextColor"];
  
    UIAlertAction *takeAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"配送料") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.choseFreeBtn setTitle:TransOutput(@"配送料") forState:UIControlStateNormal];
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


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == self.nameTX) {
        
        NSUInteger newLength = textView.text.length + text.length - range.length;
       
        self.nameNumberLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)newLength];
        
        return newLength <= 30;

    }
    else{
       
            NSUInteger newLength = textView.text.length + text.length - range.length;
           
            self.desNumberLabel.text = [NSString stringWithFormat:@"%lu/500",(unsigned long)newLength];
            
            return newLength <= 500;
         
    }
}
-(void)submitPictureToServer:(NSInteger)row{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self pushTZImagePickerController:row];
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
- (void)pushTZImagePickerController:(NSInteger)row {
    if (row == 1) {
        if (self.imageArray.count == 9) {
            ToastShow(TransOutput(@"图片最多上传9张"), errImg,RGB(0xFF830F));
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - self.imageArray.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
         imagePickerVc.showSelectBtn = NO;
        imagePickerVc.view.tag = row;
        imagePickerVc.preferredLanguage = @"ja";
        imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
        
      
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        }];
        
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    }
    else{
        if (self.imageArrayDetail.count == 9) {
            ToastShow(TransOutput(@"图片最多上传9张"), errImg,RGB(0xFF830F));
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - self.imageArrayDetail.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
         imagePickerVc.showSelectBtn = NO;
        imagePickerVc.view.tag = row;
        imagePickerVc.preferredLanguage = @"ja";
        imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
        
      
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        }];
        
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    }


   }

-(void)choseImgType:(UIImagePickerControllerSourceType)sourceType row:(NSInteger)row{
    if (row ==1) {
        self.pickerController.sourceType = sourceType;
        self.pickerController.view.tag = row;
        [self presentViewController:_pickerController animated:YES completion:nil];



    }else{
        self.pickerControllerDetail.sourceType = sourceType;
        self.pickerControllerDetail.view.tag = row;
        [self presentViewController:_pickerControllerDetail animated:YES completion:nil];
       

    }
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
               
                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image tag:picker.view.tag];
                
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image tag:(NSInteger)row{
    if (row == 1) {
        [self.imageArray addObject:image];

        NSData *imageData=UIImageJPEGRepresentation(image, 0.8);

            [self.imageDataArray addObject:imageData];
        if (self.imageArray.count < 2) {
            [self getClass:self.imageArray[0]];
        }
        

        [self uploadImage:image row:row];
        [self.collectionView reloadData];

    }
    else{
        [self.imageArrayDetail addObject:image];

        NSData *imageData=UIImageJPEGRepresentation(image, 0.8);

        [self.imageDataArrayDetail addObject:imageData];
        
        [self uploadImage:image row:row];
        [self.detailCollectionView reloadData];

    }
}
-(void)getClass:(UIImage *)image{
//    [HudView showHudForView:self.view];
   

    [UploadElement imageShibieClass:image name:@"imagedefault" progress:^(CGFloat percent) {
        
    } success:^(id  _Nonnull responseObject) {
        
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [HudView hideHudForView:self.view];
            ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
            [self.classScroll removeFromSuperview];
            self.classScroll = [[UIScrollView alloc] init];
            self.classScroll.scrollEnabled = YES;
            
            self.classScroll.backgroundColor = [UIColor clearColor];
            [self.view addSubview:self.classScroll];
          
            [self.classScroll mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.classLabel.mas_trailing).offset(10);
                make.trailing.mas_offset(-26);
                make.top.mas_equalTo(self.classLabel.mas_top).mas_offset(-14);
                make.height.mas_offset(44);
            }];
            self.classArray = responseObject[@"data"];
            CGFloat space = 10;
            CGFloat x = 0;
            for (int i = 0 ; i <self.classArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                CGFloat w = [Tool getLabelWidthWithText:self.classArray[i][@"categoryName"] height:17 font:12] +16;
           
                
                button.frame = CGRectMake( x, 7, w, 30);
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if (i == 0) {
                    button.selected = YES;
                    button.layer.borderColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32].CGColor;
                    selectedBtn = button;
                    self.categoryNameSel = self.classArray[i][@"categoryName"];
                }
                else{
                    button.layer.borderColor = RGB(0xE0E0E0).CGColor;
                }
                button.layer.borderWidth = 0.5;
                button.layer.cornerRadius = 5;
                button.tag = i;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.clipsToBounds = YES;
                [button setTitle:self.classArray[i][@"categoryName"] forState:UIControlStateNormal];
                [self.classScroll addSubview:button];
                x += w + space;
                self.classScroll.contentSize = CGSizeMake(x, 44);
                
            }
            
            
        });
      

        
    }];
}
-(void)buttonClick:(UIButton *)sender{
    if (selectedBtn) {
   
        selectedBtn.layer.borderColor = RGB(0xE0E0E0).CGColor;
   
      }
   
      selectedBtn = sender;
   
    selectedBtn.layer.borderColor =  [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32].CGColor;
    self.categoryNameSel = self.classArray[sender.tag][@"categoryName"];


}
-(void)uploadImage:(UIImage *)image row:(NSInteger)row{
   
    [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
        
    } success:^(id  _Nonnull responseObject) {
        if (row == 1) {
           

            [self.picArray addObject: responseObject[@"data"]];
           
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
            });
            [self.picDetailArray addObject: responseObject[@"data"]];
         
        }
    }];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    if (picker.view.tag == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               for (int i=0; i<photos.count; i++) {
                   UIImage *result = photos[i];
                   
                       dispatch_async(dispatch_get_main_queue(), ^{
                           //由于iphone拍照的图片太大，直接存入数组中势必会造成内存警告，严重会导致程序崩溃，所以存入沙盒中
                           //压缩图片，这个压缩的图片就是做为你传入服务器的图片
                           NSData *imageData=UIImageJPEGRepresentation(result, 0.8);
       
                               [self.imageDataArray addObject:imageData];
                               
                               //添加到显示图片的数组中
//                           UIImage *image = [Tool OriginImage:result scaleToSize:CGSizeMake(80, 80)];
                               [self.imageArray addObject:result];
                           [self uploadImage:result row:picker.view.tag];
                           
                           if (i == assets.count - 1) {
                              
                               [self getClass:photos[0]];
           
                           }
                           [self.collectionView reloadData];
                       });
       
                   
               }
       
       
       
           });
       
       
           [self dismissViewControllerAnimated:YES completion:^{
       
                   [self.collectionView reloadData];
       
       
           }];

      
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               for (int i=0; i<photos.count; i++) {
                   UIImage *result = photos[i];
                   
                       dispatch_async(dispatch_get_main_queue(), ^{
                           //由于iphone拍照的图片太大，直接存入数组中势必会造成内存警告，严重会导致程序崩溃，所以存入沙盒中
                           //压缩图片，这个压缩的图片就是做为你传入服务器的图片
                           NSData *imageData=UIImageJPEGRepresentation(result, 0.8);
       
                           [self.imageDataArrayDetail addObject:imageData];
                           
                               //添加到显示图片的数组中
                           UIImage *image = [Tool OriginImage:result scaleToSize:CGSizeMake(80, 80)];
                           [self.imageArrayDetail addObject:image];
                           [self uploadImage:image row:picker.view.tag];
                           if (i == assets.count - 1) {
                               [HudView hideHudForView:self.view];
                           }
                           [self.detailCollectionView reloadData];
       
                       });
       
                   
               }
       
       
       
           });
       
       
           [self dismissViewControllerAnimated:YES completion:^{
       
               [self.detailCollectionView reloadData];
       
       
           }];

      
    }
   
}




#pragma mark ---------collectionView代理方法--------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionView) {
        return self.imageArray.count + 1 ;
      
    }

    else{
        return self.imageArrayDetail.count + 1;
    }

    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionView) {
       
        
        if (self.imageArray.count == 0) {
            AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
            [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
            [cell1.addImageV setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
            [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            return cell1;
            
        }else{
            
           
            
            if (indexPath.item + 1 > self.imageArray.count ) {
                
                AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
                [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
                [cell1.addImageV setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
                [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
                return cell1;
                
                
            }else{
                CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                cell.imageV.image = self.imageArray[indexPath.item];
                [cell.imageV addSubview:cell.deleteButotn];
                cell.deleteButotn.tag = indexPath.item + 100;
                [cell.deleteButotn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
            
        }
    }else
    {
       
        if (self.imageArrayDetail.count == 0) {
            AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
            
            [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
            [cell1.addImageV setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
            [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            return cell1;
            
        }else{
            
           
            if (indexPath.item + 1 > self.imageArrayDetail.count ) {
                
                AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
                
                [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
                [cell1.addImageV setTitle:TransOutput(@"商品图片") forState:UIControlStateNormal];
                [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
                return cell1;
                
                
            }else{
                CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                
                cell.imageV.image = self.imageArrayDetail[indexPath.item];
                [cell.imageV addSubview:cell.deleteButotn];
                cell.deleteButotn.tag = indexPath.item + 1000;
                [cell.deleteButotn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
            
        }
    }
    

    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView== self.collectionView) {
        if (indexPath.item + 1 > self.imageArray.count ) {
            NSLog(@"上传");
            [self submitPictureToServer:1];
        }else{
          }
        
    }
    else{
        if (indexPath.item + 1 > self.imageArrayDetail.count ) {
            NSLog(@"上传");
            [self submitPictureToServer:2];
        }else{
           }
        
    }
}

#pragma mark --------删除图片-----------

- (void)deleteImage:(UIButton *)sender{
    if (sender.tag > 900) {
        NSInteger index = sender.tag - 1000;
        //移除显示图片数组imageArray中的数据
        [self.imageArrayDetail removeObjectAtIndex:index];
        //移除沙盒数组中imageDataArray的数据
        [self.imageDataArrayDetail removeObjectAtIndex:index];
        
       
        [self.detailCollectionView reloadData];

    }else{
        NSInteger index = sender.tag - 100;
        //移除显示图片数组imageArray中的数据
        [self.imageArray removeObjectAtIndex:index];
        //移除沙盒数组中imageDataArray的数据
        [self.imageDataArray removeObjectAtIndex:index];
        
        if (self.imageArray.count == 0) {
            [self.classScroll removeFromSuperview];
            self.categoryNameSel = @"";
        }
        
        [self.collectionView reloadData];
    }
    
}




-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];

        flowLayOut.itemSize = CGSizeMake(70, 70);
        flowLayOut.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

    }
    return _collectionView;
}

-(UICollectionView *)detailCollectionView{
    if (!_detailCollectionView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];

        flowLayOut.itemSize = CGSizeMake(70, 70);
        flowLayOut.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        self.detailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        
        
        _detailCollectionView.backgroundColor = [UIColor clearColor];
        
        
        self.detailCollectionView.delegate = self;
        self.detailCollectionView.dataSource = self;

    }
    return _detailCollectionView;
}
- (NSMutableArray *)imageDataArray{
        if (!_imageDataArray) {
            self.imageDataArray = [NSMutableArray array];
        }
        return _imageDataArray;
 }
 - (NSMutableArray *)imageArray{
        if (!_imageArray) {
            self.imageArray = [NSMutableArray array];
           
        }
        return _imageArray;
 }

- (UIImagePickerController *)pickerController{
    if (!_pickerController) {
        
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _pickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _pickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
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
        return _pickerController;
}

- (NSMutableArray *)imageDataArrayDetail{
        if (!_imageDataArrayDetail) {
            self.imageDataArrayDetail = [NSMutableArray array];
        }
        return _imageDataArrayDetail;
 }
 - (NSMutableArray *)imageArrayDetail{
        if (!_imageArrayDetail) {
            self.imageArrayDetail = [NSMutableArray array];
           
        }
        return _imageArrayDetail;
 }
- (UIImagePickerController *)pickerControllerDetail {
    if (_pickerControllerDetail == nil) {
        _pickerControllerDetail = [[UIImagePickerController alloc] init];
        _pickerControllerDetail.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _pickerControllerDetail.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _pickerControllerDetail.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
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
    return _pickerControllerDetail;
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
