//
//  APPlyReturnMoneyView.m
//  Netneto
//
//  Created by apple on 2024/10/17.
//

#import "APPlyReturnMoneyView.h"
@interface APPlyReturnMoneyView ()<UITextFieldDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,SDPhotoBrowserDelegate>
{
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic ,strong) ZYQAssetPickerController *pickerController;
@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) NSMutableArray *imageDataArray;
@property (nonatomic ,assign) NSInteger i;
@property (nonatomic ,strong) NSMutableArray *picArray;

@end
@implementation APPlyReturnMoneyView

+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
   
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [self.backVIew addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
   
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
   [self.collectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"identifier"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.whiteView addSubview:self.collectionView];
    self.i = 0;
   [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.mas_offset(5);
       make.trailing.mas_offset(-5);
       make.height.mas_offset(92);
       make.bottom.mas_equalTo(self.subBtn.mas_top).offset(-36);
   }];
    [self.typeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        if ([self.resonTX isFirstResponder]) {
            [self.resonTX resignFirstResponder];
        }
        if ([self.numTF isFirstResponder]) {
            [self.numTF resignFirstResponder];
        }
        ExecBlock(self.typeBlock);
    }];
   
}

-(void)loadData{
    @weakify(self)
    self.titleLabel.text = TransOutput(@"申请退款");
    self.applyTypeLabel.text = TransOutput(@"申请类型:");
    [self.typeBtn setTitle:TransOutput(@"仅退款") forState:UIControlStateNormal];
    [self.typeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.typeBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
    self.reasonLabel.text = TransOutput(@"申请原因:");
    [self.resonTX setPlaceholderWithText:TransOutput(@"请输入申请退款原因") Color:RGB(0xB3B3B3)];
    self.resonTX.delegate = self;
    [self.subBtn setTitle:TransOutput(@"提交退款申请") forState:UIControlStateNormal];
    self.subBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [self.subBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        
        if (self.numTF.text.length == 0) {
            ToastShow(TransOutput(@"请输入退款商品数量"), errImg,RGB(0xFF830F));
            return;
        }
        if (self.resonTX.text.length == 0) {
            ToastShow(TransOutput(@"请输入申请退款原因"), errImg,RGB(0xFF830F));
            return;
        }
        NSString *str =self.numTF.text;
        if ([self.numTF.text integerValue] <= [self.modelItem.prodCount integerValue]) {
            if ([str integerValue] == 0 && str.length > 0) {
    
                 ToastShow(TransOutput(@"申请数量不能为0"), errImg,RGB(0xFF830F));
                return;
             }
    
            
        }
    
        else{
            if (self.model.reduceAmount == 0) {
                ToastShow(TransOutput(@"申请数量不可大于购买数量"), errImg,RGB(0xFF830F));
                return;
            }
            
        }
        NSString *applyType;
        if ([self.typeBtn.titleLabel.text isEqual:TransOutput(@"仅退款")]) {
            applyType = @"1";
        }else{
            applyType = @"2";
        }
        ExecBlock(self.submitBlock,self.modelItem.orderItemId,self.numTF.text,[self.picArray componentsJoinedByString:@","],self.resonTX.text,self.model.orderNumber,applyType,self.model);
        
    }];
    self.numLabel.text = TransOutput(@"退款商品数量:");
    self.numTF.delegate = self;
    self.numTF.text = @"";
    self.resonTX.text = @"";
//    self.numTF.textAlignment = NSTextAlignmentRight;
    [self.numTF setRightPlaceholderWithText:TransOutput(@"请输入退款商品数量") Color:RGB(0xB3B3B3)];

    self.picArray = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    [self.collectionView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = kbFrame.size.height;
    // 调整视图位置
    self.frame = CGRectMake(0, -keyboardHeight, self.frame.size.width, self.frame.size.height);
}
- (void)keyboardWillHide:(NSNotification*)aNotification {
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   
        NSUInteger newLength = textView.text.length + text.length - range.length;
        
        
        return newLength <= 200;
        
    
}
-(void)updaApplyType:(NSString *)type{
    [self.typeBtn setTitle:type forState:UIControlStateNormal];
    [self.typeBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
    [self.typeBtn layoutButtonWithButtonStyle:ButtonStyleImageRightTitleLeft imageTitleSpace:10];
}

-(void)updateColloc:(NSMutableArray *)imageArray{
    NSMutableArray<NSData *> *imageDatas = [NSMutableArray array];
    if (![imageArray isEqualToArray:self.imageArray]) {
        self.picArray = [NSMutableArray array];
        self.imageArray =[NSMutableArray arrayWithArray:imageArray];
    
    if (self.imageArray.count > 0) {
       

              for ( int i = 0;i < self.imageArray.count; i++) {
            UIImage *image =self.imageArray[i];
                  NSData *imageData=UIImageJPEGRepresentation(image, 1);
                  [imageDatas addObject:imageData];
//            [self uploadImage:image index:i];
           
        }
        [self uploadImageArray:imageDatas];
    }
        
    [self.collectionView reloadData];
    }
    
      
    
}

-(void)uploadDel:(NSMutableArray *)imageArray{
    self.picArray = [NSMutableArray array];
        self.imageArray =[NSMutableArray arrayWithArray:imageArray];
    [self.collectionView reloadData];
}
-(void)uploadImageArray:(NSArray *)array{
//    if (index == 0) {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        self->hud.label.text = @"";
    });
//    }
    
    
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
                
            });
            //            NSString *str =[NSString stringWithFormat:@"http://yueran.vip/%@",responseObject[@"data"]];
            NSArray *arr = [responseObject[@"data"] componentsSeparatedByString:@","];
            for (NSString *str  in arr) {
                [self.picArray addObject: str];
            }
        }
    }];
}
-(void)uploadImage:(UIImage *)image index:(NSInteger)index{
    if (index == 0) {
        [HudView showHudForView:self];
    }
    [UploadElement UploadElementWithImage:image name:@"imagedefault" progress:^(CGFloat percent) {
       
    } success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == self.imageArray.count - 1) {
            
                    [HudView hideHudForView:self];
                ToastShow(TransOutput(@"图片上传成功"), @"chenggong", RGB(0x36D053));
                
            }
           
        });
        [self.picArray addObject: responseObject[@"data"]];
        
    }];
}

#pragma mark ---------collectionView代理方法--------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
        return self.imageArray.count + 1 ;
      
    

    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.imageArray.count == 0) {
        AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
        
       
            [cell1.addImageV setImage:[UIImage imageNamed:@"path-26"] forState:UIControlStateNormal];
            [cell1.addImageV setTitle:TransOutput(@"退款凭证") forState:UIControlStateNormal];
            [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
            return cell1;
            
        }else{
            
           
            if (indexPath.item == 0 ) {
                AddCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
                [cell1.addImageV setImage:[UIImage imageNamed:@"矢量 8"] forState:UIControlStateNormal];
                [cell1.addImageV setTitle:TransOutput(@"退款凭证") forState:UIControlStateNormal];
                [cell1.addImageV layoutButtonWithButtonStyle:ButtonStyleImageTopTitleBottom imageTitleSpace:10];
                return cell1;
                
                
            }else{
                CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                
                cell.imageV.image = self.imageArray[indexPath.item - 1];
                [cell.imageV addSubview:cell.deleteButotn];
                cell.deleteButotn.tag = indexPath.item -1 + 100;
                [cell.deleteButotn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
           
        }
   
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
        if (indexPath.item == 0 ) {
            NSLog(@"上传");
//            [self submitPictureToServer:1];
            ExecBlock(self.upPicBlock);
        }else{
           
//            ExecBlock(self.chosePicBlock);
//
            
            SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
            broser.currentImageIndex = indexPath.row-1;
            broser.tag = 2;
            broser.sourceImagesContainerView = self.collectionView;
            broser.imageCount =self.imageArray.count  ;
            broser.delegate = self;
            [broser show];
        }
        
   
}




//-(NSURL*)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
////网络图片（如果崩溃，可能是此图片地址不存在了）
//NSMutableArray *array;
//if (browser.tag == 2) {
//
//array = self.imageArray;
//}
//
////
//if (browser.tag == 1) {
//[array removeObjectAtIndex:0];
//}
//NSString *imageName = array[index];
//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageName]];
//
//return url;
//}
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

#pragma mark --------删除图片-----------

- (void)deleteImage:(UIButton *)sender{
    NSInteger index = sender.tag - 100;
    ExecBlock(self.delBlock,index);
       
     
    
    
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
    NSString *newPath = [collectPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Picture_%ld.png",_i]];
    NSLog(@"++%@",newPath);
    [imageData writeToFile:newPath atomically:YES];
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayOut.itemSize = CGSizeMake(70, 70);
        flowLayOut.sectionInset = UIEdgeInsetsMake(11, 11, 0, 11);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
        
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

    }
    return _collectionView;
}

-(void)setModelItem:(OrderModel *)modelItem{
    _modelItem = modelItem;
    if (![self.model.status isEqual:@"5"]) {
        self.numTF.text =[NSString stringWithFormat:@"%@",modelItem.prodCount] ;

    }
   
}
-(void)setModel:(OrderModel *)model{
    _model = model;
    switch ([model.status intValue]) {
        case 6:
            
            break;
        case 5:
            //已完成
            self.typeBtn.enabled = YES;
            self.numTF.editable = YES;
            break;
        
        case 3:
            //待收货
//            self.typeBtn.enabled = YES;
            
            break;
        case 2:
            //待发货
            self.typeBtn.enabled = NO;
            self.numTF.editable = NO;
            break;
        case 1:
            //待支付
            
            break;
        default:
            break;
    }
}
- (IBAction)closeClick:(id)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
