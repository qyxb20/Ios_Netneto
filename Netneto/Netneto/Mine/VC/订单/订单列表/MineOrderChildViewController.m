//
//  MineOrderChildViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "MineOrderChildViewController.h"

@interface MineOrderChildViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NothingView *nothingView;
@property (nonatomic, strong) APPlyReturnMoneyView *tuiView;
//@property (nonatomic ,strong) ZYQAssetPickerController *pickerController;
@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) NSMutableArray *imageDataArray;
@property (nonatomic ,assign) NSInteger i;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation MineOrderChildViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    self.dataArr = [NSMutableArray array];
    [self loadData];
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_offset(0);
        
    }];
   
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadData" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        NSString *value = [notification.userInfo objectForKey:@"orderNumber"];
        [self replayDic:value];
        NSLog(@"%@", value);
    }];

}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
//        _nothingView.titleLabel.text = TransOutput(@"暂无交易记录");
    }
    return _nothingView;
}
-(void)resetUserInfo:(NSNotification *)notification{
    
}
- (void)loadData{
    
    if (self.index == 5) {
        [HudView showHudForView:self.view];
        if (self.page == 0) {
            self.page += 1;
        }
        NSDictionary *parm = @{@"current":@(self.page),@"size":@(10),@"timeRange":self.timeRange};
          [NetwortTool getUserRefunOrderWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSLog(@"退货订单列表%@",responseObject);
            [HudView hideHudForView:self.view];
            NSArray *arr = responseObject;
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                RefunOrderModel *model = [RefunOrderModel mj_objectWithKeyValues:arr[i]];
                [self.dataArr addObject:model];
            }
            
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
              self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
              self.nothingView.titleLabel.text = TransOutput(@"暂无待收货数据");

            if (self.dataArr.count == 0) {
                self.tableView.backgroundView = self.nothingView;
            }
            else{
                self.tableView.backgroundView = nil;
            }
            
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
        
    }else{
        if (self.index == 4) {
            self.status = @"5";
            
        }
        else{
            self.status = [NSString stringWithFormat:@"%ld",(long)self.index];
        }
        
        
        
        NSDictionary *parm = @{@"status":self.status,@"current":@(self.page),@"timeRange":self.timeRange};
        [HudView showHudForView:self.view];
        [NetwortTool getUserOrderWithParm:parm Success:^(id  _Nonnull responseObject) {
            NSLog(@"订单列表%@",responseObject);
            [HudView hideHudForView:self.view];
            NSArray *arr = responseObject[@"records"];
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            for (int i = 0; i <arr.count; i++) {
                OrderModel *model = [OrderModel mj_objectWithKeyValues:arr[i]];
                [self.dataArr addObject:model];
            }
            self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);

                self.nothingView.titleLabel.text = TransOutput(@"暂无待收货数据");

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.dataArr.count == 0) {
                self.tableView.backgroundView = self.nothingView;
            }
            else{
                self.tableView.backgroundView = nil;
            }
            
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index != 5) {
        MineOrderChildTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
           cell = [[MineOrderChildTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArr.count != 0) {
            OrderModel *models = self.dataArr[indexPath.row];
            cell.model = models;
            @weakify(self);
            [cell setPushComAddBlock:^(OrderModel * _Nonnull model) {
                @strongify(self);
                            AddCommViewController *vc = [[AddCommViewController alloc] init];
                            vc.model = model;
                            [self pushController:vc];
            }];
            [cell.fanJinBtn addTapAction:^(UIView * _Nonnull view) {
                [self isChaoshi:nil mainModel:models type:2];

            }];
            [cell setApplyTuiBlock:^(OrderModel * _Nonnull model) {
                @strongify(self);
                [self isChaoshi:model mainModel:models type:1];
            }];
        }
        
        return cell;
    }
    else{
        MineOrderRefunTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[MineOrderRefunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        RefunOrderModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        return cell;
    }
}
-(void)isChaoshi:(OrderModel *)model mainModel:(OrderModel *)models type:(NSInteger)type{
   

    
    [NetwortTool getSubmitRefundBefore:@{@"orderNumber":models.orderNumber} Success:^(id  _Nonnull responseObject) {
        NSLog(@"审核结果:%@",responseObject);
        if ([responseObject[@"isRefund"] intValue] == 0) {
//
                    CSQAlertView *alert = [[CSQAlertView alloc] initWithCutomOrderTitle:@"" Message: responseObject[@"msg"] btnTitle:TransOutput(@"店舗CSへ") cancelBtnTitle:TransOutput(@"はい") btnClick:^{
                        if (models.prodId.length > 0 ) {
                            [self pushKefu:model];
                        }
                        else{
                            [self pushKefu:models];
                        }

                              
                    } cancelBlock:^{
            
                    }];
                    [alert show];
        }
        else{
            //
            [self tuiViewShow:model mainModel:models type:type];
        }
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
   
}
-(void)pushKefu:(OrderModel *)models{
   
    [HudView showHudForView:self.view];
    NSString *prodId = @"";
    
    if ([[NSString isNullStr:models.prodId] length]> 0) {
        prodId = [NSString stringWithFormat:@"%@",models.prodId];
    }
    else{
        prodId = [NSString stringWithFormat:@"%@",models.orderItemDtos.firstObject[@"prodId"]];
    }
    
    [NetwortTool getHomeProdInfo:prodId userId:account.userInfo.userId success:^(id  _Nonnull responseObject) {
        [HudView hideHudForView:self.view];
        NSDictionary *dataDic = responseObject;
        NSDictionary *selecSkuDic = dataDic[@"skuList"][0];
        NSArray *skuList = dataDic[@"skuList"];
        for (int i = 0; i <skuList.count; i++) {
            if ([skuList[i][@"skuId"] isEqual:models.skuId]) {
                selecSkuDic =skuList[i];
            }
        }
        MineMessDetailViewController *vc= [[MineMessDetailViewController alloc] init];
        vc.dataDic = dataDic;
        vc.isDetail = YES;
        vc.ImsgChannel = @"";
        vc.FromUserId = account.userInfo.userId;
        vc.ToUserId = dataDic[@"shopUserId"];
        vc.selDic = selecSkuDic;
        [self pushController:vc];
        
       
        
        } failure:^(NSError * _Nonnull error) {
            [HudView hideHudForView:self.view];
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
}
-(void)tuiViewShow:(OrderModel *)model mainModel:(OrderModel *)models type:(NSInteger)type{
    @weakify(self);
    [self.imageArray removeAllObjects];
    [self.imageDataArray removeAllObjects];
    [self.tuiView loadData];
    [APPDELEGATE.window addSubview:self.tuiView];
    self.tuiView.index = self.index;
    
    self.tuiView.model = models;
    if (type == 1) {
        self.tuiView.modelItem = model;
    }
    else{
        self.tuiView.numTF.text = [NSString stringWithFormat:@"%@",models.productNums];
        if ([models.status isEqual:@"5"]) {
            self.tuiView.typeBtn.enabled = YES;
        }
        else{
            self.tuiView.typeBtn.enabled = NO;
        }
        self.tuiView.numTF.editable = NO;
    }
//                [self.tuiView updateColloc:self.imageArray];
    [self.tuiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_offset(0);
    }];
    
    [self.tuiView setUpPicBlock:^{
        @strongify(self);
        
        [self submitPictureToServer:1];
    }];
    [self.tuiView setChosePicBlock:^{
        @strongify(self);

    }];
    [self.tuiView setSubmitBlock:^(NSString * _Nonnull orderItemId, NSString * _Nonnull goodsNum, NSString * _Nonnull photoFiles, NSString * _Nonnull buyerMsg,NSString * _Nonnull orderNumber,NSString * _Nonnull applyType,OrderModel * _Nonnull modelDic) {
        @strongify(self);
        if (modelDic.reduceAmount > 0) {
            CSQAlertView *alert = [[CSQAlertView alloc] initWithTitle:@"" Message:TransOutput(@"该订单使用优惠券，申请后所有商品将全部退货,是否继续退款？") btnTitle:TransOutput(@"确定") cancelBtnTitle:TransOutput(@"取消") btnClick:^{
                OrderModel *itemModel = [OrderModel mj_objectWithKeyValues:models.orderItemDtos[0]];
                
                [self applySubmitRefund:orderItemId goodsNum:goodsNum photoFiles:photoFiles buyerMsg:buyerMsg orderNumber:orderNumber applyType:applyType];
            } cancelBlock:^{
                
            }];
            [alert show];
        }else{
            [self applySubmitRefund:orderItemId goodsNum:goodsNum photoFiles:photoFiles buyerMsg:buyerMsg orderNumber:orderNumber applyType:applyType];
        }
    }];
    [self.tuiView setTypeBlock:^{
        @strongify(self);
        [self choseType];
    }];
    
}
-(void)applySubmitRefund:(NSString *)orderItemId goodsNum:(NSString *)goodsNum photoFiles:(NSString *)photoFiles buyerMsg:(NSString *)buyerMsg orderNumber:(NSString *)orderNumber applyType:(NSString *)applyType{
    NSDictionary *parm;
    if (orderItemId.length > 0 ) {
        parm =@{@"refundId":@"0",@"orderItemId":orderItemId,@"goodsNum":goodsNum,@"photoFiles":photoFiles,@"buyerMsg":buyerMsg,@"applyType":applyType};
    }
    else{
        parm =@{@"refundId":@"0",@"goodsNum":goodsNum,@"photoFiles":photoFiles,@"buyerMsg":buyerMsg,@"applyType":applyType,@"orderNumber":orderNumber};

    }
    [NetwortTool getSubmitRefundWithParm:parm Success:^(id  _Nonnull responseObject) {
      
        ToastShow(TransOutput(@"申请成功"),@"chenggong",RGB(0x36D053));
        [self replayDic:orderNumber];
        
        } failure:^(NSError * _Nonnull error) {
            ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
        }];
}
-(void)replayDic:(NSString *)orderNumber{
    [NetwortTool getOrderDetailWithParm:@{@"orderNumber":orderNumber} Success:^(id  _Nonnull responseObject) {
        [self.tuiView removeFromSuperview];
        OrderModel *modelNew = [OrderModel mj_objectWithKeyValues:responseObject];
        modelNew.orderNumber = orderNumber;
    
        for (int i =0; i <self.dataArr.count; i++) {
            OrderModel *models = self.dataArr[i];
            if ([models.orderNumber isEqual:orderNumber]) {
                modelNew.productNums = models.productNums;
                
                [self.dataArr replaceObjectAtIndex:i withObject:modelNew];
                [self.tableView reloadData];
                break;
            }
        }
    } failure:^(NSError * _Nonnull error) {
//        ToastShow(error.userInfo[@"httpError"],@"矢量 20");
    }];
}
-(void)submitPictureToServer:(NSInteger)row{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self choseImgType:UIImagePickerControllerSourceTypePhotoLibrary row:row];
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
   

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - self.imageArray.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.preferredLanguage = @"ja";
     imagePickerVc.showSelectBtn = NO;
    
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
-(void)choseType{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"仅退款") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tuiView updaApplyType:TransOutput(@"仅退款")];
    }];
    [photoAlbumAction setValue:RGB(0x333333) forKey:@"_titleTextColor"];
  
    UIAlertAction *takeAlbumAction = [UIAlertAction actionWithTitle:TransOutput(@"退货退款") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tuiView updaApplyType:TransOutput(@"退货退款")];
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
  
    [self.imageArray addObject:image];
    [self.tuiView updateColloc:self.imageArray];
       
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    NSMutableArray<NSData *> *imageDatas = [NSMutableArray array];
     
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           for (int i=0; i<photos.count; i++) {
               UIImage *result = photos[i];
               
                   dispatch_async(dispatch_get_main_queue(), ^{
                       //由于iphone拍照的图片太大，直接存入数组中势必会造成内存警告，严重会导致程序崩溃，所以存入沙盒中
                       //压缩图片，这个压缩的图片就是做为你传入服务器的图片
                       if (isSelectOriginalPhoto) {
                           [[TZImageManager manager] getOriginalPhotoWithAsset:assets[i] completion:^(UIImage *photo, NSDictionary *info) {
                               NSData *imageData = info[@"PHImageFileDataKey"];
//                               NSData *imageData=UIImageJPEGRepresentation(photo, 1);
                               
                               NSString *dataLength = [Tool getBytesFromDataLength:imageData.length];
                               NSLog(@"输出图片大小:%@",dataLength);
                               if ([dataLength containsString:@"M"]) {
                                   if ([[dataLength substringToIndex:dataLength.length -1] intValue] > 8) {
                                       [HudView hideHudForView:self.view];
                                       ToastShow(TransOutput(@"图片超过8M"), errImg,RGB(0xFF830F));
                                       if (i == assets.count - 1) {
                                        [self.tuiView updateColloc:self.imageArray];
                                                              }
                                      
                                       return;
                                   }
                               }
                               [self.imageDataArray addObject:imageData];
                               [self WriteToBox:imageData];
                               //添加到显示图片的数组中
    //                       UIImage *image = [Tool OriginImage:result scaleToSize:CGSizeMake(80, 80)];
                               [self.imageArray addObject:photo];
                          
                               if (i == assets.count - 1) {
                                                          [self.tuiView updateColloc:self.imageArray];
                                                      }
                           
                           }];
                       }
                       else{
                           NSData *imageData=UIImageJPEGRepresentation(result, 1);
                           NSString *dataLength = [Tool getBytesFromDataLength:imageData.length];
                           NSLog(@"输出图片大小:%@",dataLength);
                           if ([dataLength containsString:@"M"]) {
                               if ([[dataLength substringToIndex:dataLength.length -1] intValue] > 8) {
                                   [HudView hideHudForView:self.view];
                                   ToastShow(TransOutput(@"图片超过8M"), errImg,RGB(0xFF830F));
                                   if (i == assets.count - 1) {
                                                              [self.tuiView updateColloc:self.imageArray];
                                                          }
                                                        
                                   return;
                               }
                           }
                           [self.imageDataArray addObject:imageData];
                           [self WriteToBox:imageData];
                           //添加到显示图片的数组中
//                       UIImage *image = [Tool OriginImage:result scaleToSize:CGSizeMake(80, 80)];
                           [self.imageArray addObject:result];
                               if (i == assets.count - 1) {
                                [self.tuiView updateColloc:self.imageArray];
                                                      }
                       }
//
   
                   });
   
               
           }
   
   
   
       });
   
   
       [self dismissViewControllerAnimated:YES completion:^{
         
   
   
       }];
}




#pragma mark --------存入沙盒------------

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
    NSString *newPath = [collectPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Picture_%ld.png",_i]];
    NSLog(@"++%@",newPath);
    [imageData writeToFile:newPath atomically:YES];
}








- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index != 5) {
        if (self.dataArr.count>0) {
            OrderModel *model = self.dataArr[indexPath.row];
            if (model.reduceAmount > 0) {
                
                    if (  [model.status intValue] == 2 || [model.status intValue] == 5) {
                        if ( [model.refundSts isEqual:@"1"]){
                            return model.orderItemDtos.count * 98 + 66 + 12;
                        }else{
                            return model.orderItemDtos.count * 98 + 66 + 12 + 40;
                        }
                }
                else if([model.status intValue] == 6 || [model.status intValue]  == 3 || [model.status intValue]  == 1){
                    return model.orderItemDtos.count * 98 + 66 + 12;
                }
                else{
                    return model.orderItemDtos.count * 98 + 66 + 12 + 40;
                }
            }else{
                return model.orderItemDtos.count * 98 + 66 + 12;
            }
        }else{
            return 0;
        }
      }
    else{
        if (self.dataArr.count>0) {
            RefunOrderModel *model = self.dataArr[indexPath.row];

            return model.orderItems.count * 98 + 66 + 12 + 30;

        }else{
            return 0;
        }

  
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index != 5) {
        if (self.dataArr.count != 0) {
            OrderModel *model = self.dataArr[indexPath.row];
            OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
            vc.orderNumber =model.orderNumber;
            vc.staus = model.status;
            [self pushController:vc];
        }
       
    }else
    {
        if (self.dataArr.count != 0 ) {
            RefunOrderModel *model = self.dataArr[indexPath.row];
            OrderDetailInfoRefunViewController *vc = [[OrderDetailInfoRefunViewController alloc] init];
            vc.refundId =model.refundId;
            vc.orderNumber = model.orderNumber;
            [self pushController:vc];
        }
      
    }
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        @weakify(self)
        _tableView.mj_header  = [MJRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            @strongify(self)
            self.page++;
            [self loadData];
        }];
    }
    return _tableView;
}
-(APPlyReturnMoneyView *)tuiView{
    if (!_tuiView) {
        _tuiView = [APPlyReturnMoneyView initViewNIB];
        _tuiView.backgroundColor = [UIColor clearColor];
        @weakify(self)
        [_tuiView setDelBlock:^(NSInteger index) {
            @strongify(self);
                    [self.imageArray removeObjectAtIndex:index];
            [self.tuiView uploadDel:self.imageArray];
        }];
        
    }
    return _tuiView;
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
