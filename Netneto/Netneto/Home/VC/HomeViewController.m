//
//  HomeViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong)HomeHeaderView *HeaderView;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)NSMutableArray *secArr;
@property(nonatomic, strong)NSMutableArray *rowArr;
@property(nonatomic, strong)NSArray *hotArr;

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hbd_barHidden = YES;

}
-(void)updateMineMsgNum{
    if ([[NSString isNullStr:account.userInfo.userId] length]> 0) {
        [NetwortTool getfindImCountsWithParm:@{@"userId":account.userInfo.userId} Success:^(id  _Nonnull responseObject) {
            
            if ([responseObject integerValue] == 0 ) {
                [self.tabBarController.tabBar removeBadgeOnItemIndex:4];
            }else{
                if ([responseObject integerValue] > 99) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:4 tex:[NSString stringWithFormat:@"99+"]];
                }
                else{
                    [self.tabBarController.tabBar showBadgeOnItemIndex:4 tex:[NSString stringWithFormat:@"%ld",(long)[responseObject integerValue]]];
                }
            }
        } failure:^(NSError * _Nonnull error) {
            [self.tabBarController.tabBar removeBadgeOnItemIndex:4];
        }];
    }
}
-(void)appactive{
   
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hbd_barHidden = NO;

}


-(void)initData{
    self.dataArr = [NSMutableArray array];
}
-(void)CreateView{
    UIPrintInteractionController *vc= [[UIPrintInteractionController alloc] init];
      if (@available(iOS 11.0, *)) {

            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        }
       [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"uploadMsg" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self updateMineMsgNum];
        });
    }];
}
- (void)GetData{
    [NetwortTool getHomeAllGoodsSuccess:^(id  _Nonnull responseObject) {
        NSArray *arr = responseObject;
        for (int i = 0 ; i < arr.count; i++) {

               
                [self.dataArr addObject:arr[i]];

        }

        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
    
}
-(HomeHeaderView *)HeaderView{
    if (!_HeaderView) {
        _HeaderView = [[HomeHeaderView alloc] init];
        @weakify(self)
        [_HeaderView setMoreClickBlock:^(NSString * _Nonnull idStr) {

           @strongify(self)
            HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
            
            vc.titleStr =TransOutput(@"每日上新");
            vc.isTag = YES;
            vc.tagId = idStr;
            [self pushController:vc];
        }];
        [_HeaderView setCellItemClickBlock:^(NSDictionary * _Nonnull dic) {
            @strongify(self)
             HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
             vc.prodId = dic[@"prodId"];
             [self pushController:vc];
        }];
        [_HeaderView setNotifiClickBlock:^{
            @strongify(self)
            HomeNotificationViewController *vc = [[HomeNotificationViewController alloc] init];
            [self pushController:vc];
        }];
        
        [_HeaderView setBtnItemClickBlock:^(NSString * _Nonnull titleStr) {
            @strongify(self)
            
            if ([titleStr isEqualToString:TransOutput(@"新品推荐")]) {
                HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
                vc.urlStr = RequestURL(@"/index/lastedProdPage");
                vc.titleStr =titleStr;
                [self pushController:vc];
            }
            else if([titleStr isEqualToString:TransOutput(@"每日疯抢")]){

//                HomeNothingViewController *vc = [[HomeNothingViewController alloc] init];
//                vc.titleStr =titleStr;
//                [self pushController:vc];
                HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
                vc.urlStr = RequestURL(@"/pc/index/discountProdList");
                vc.titleStr =titleStr;
                [self pushController:vc];
            }
            else if([titleStr isEqualToString:TransOutput(@"领优惠券")]){

                GouponCenterViewController *vc = [[GouponCenterViewController alloc] init];
                vc.titleArr = @[TransOutput(@"全部"),TransOutput(@"固定金额"),TransOutput(@"百分比"),TransOutput(@"满减")];
                vc.title = TransOutput(@"领券中心");
                [self pushController:vc];
            }else{
                HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
                vc.urlStr = RequestURL(@"/pc/index/moreBuyProdList");
                vc.titleStr =titleStr;
                [self pushController:vc];
            }
            
        }];
        [_HeaderView setBannerItemClickBlock:^(NSDictionary * _Nonnull dic) {
            @strongify(self);
            NSString *relation = [NSString stringWithFormat:@"%@",dic[@"relation"]];
            if ([[NSString isNullStr:relation] length] > 0) {
                HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
                vc.prodId = relation;
                [self pushController:vc];
            }
            
        }];
    }
    return _HeaderView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0,16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
        [_collectionView registerClass:[HomeOneCollectionViewCell class] forCellWithReuseIdentifier:@"HomeOneCollectionViewCell"];
       
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
       
        [_collectionView registerClass:[HomeSectionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerOther"];
        @weakify(self);
        _collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.dataArr = [NSMutableArray array];
            [self.HeaderView GetData];
            [self GetData];
        }];
       
        }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = nil;
    
   
    if (indexPath.section == 0) {
        [self.HeaderView removeFromSuperview];
        [headerView removeFromSuperview];
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
     
   
        [headerView addSubview:self.HeaderView];
        @weakify(self);
        [self.HeaderView setSearchClickBlock:^{
            @strongify(self);
            searchViewController *vc = [[searchViewController alloc] init];
            [self pushController:vc];
        }];
        [self.HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_offset(0);
            make.height.mas_offset(730 - 244);
        }];

            UILabel *labelHot = [[UILabel alloc] init];
        if (self.dataArr.count > 0) {
            labelHot.text = [NSString isNullStr:self.dataArr[indexPath.section][@"title"]];
       
        }
               labelHot.font = [UIFont boldSystemFontOfSize:20];
            labelHot.textColor = RGB(0x4B4B4B);
            [headerView addSubview:labelHot];
            [labelHot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_offset(16);
                make.top.mas_equalTo(self.HeaderView.mas_bottom).offset(13);
                make.height.mas_offset(26);
                
            }];
            
            UIButton *moreBtnHot = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBtnHot setTitle:TransOutput(@"更多") forState:UIControlStateNormal];
           
            [moreBtnHot addTapAction:^(UIView * _Nonnull view) {
                        @strongify(self)
                HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
                vc.titleStr =[NSString isNullStr:self.dataArr[indexPath.section][@"title"]];
                vc.isTag = YES;
                vc.tagId =self.dataArr[indexPath.section][@"id"];
                
                [self pushController:vc];
            }];
            [moreBtnHot.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size:14]];
            [moreBtnHot setTitleColor:RGB(0x8D8B8B) forState:UIControlStateNormal];
            [headerView addSubview:moreBtnHot];
            [moreBtnHot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_offset(-20);
                make.top.mas_equalTo(self.HeaderView.mas_bottom).offset(13);
                make.height.mas_offset(26);
            }];

        
        return headerView;
    }
    else{
        [headerView removeFromSuperview];
        HomeSectionCollectionReusableView  *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerOther" forIndexPath:indexPath];
        if (self.dataArr.count > 0) {
            headerView.labelHot.text = [NSString isNullStr:self.dataArr[indexPath.section][@"title"]];
          
        }
        
       
        
        @weakify(self)
        [ headerView.moreBtnHot addTapAction:^(UIView * _Nonnull view) {
                    @strongify(self)
            HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
            vc.titleStr =[NSString isNullStr:self.dataArr[indexPath.section][@"title"]];
            vc.isTag = YES;
            vc.tagId =self.dataArr[indexPath.section][@"id"];
            
            [self pushController:vc];
        }];
       
        return headerView;
  

    }
    return nil;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return  CGSizeMake(WIDTH, 779 - 244);
    }else{
        return CGSizeMake(WIDTH, 50);
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (self.dataArr.count > 0) {
            NSArray *arr = self.dataArr[section][@"productDtoList"];
            
            return arr.count;
        }else{
            return 0;
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(WIDTH, 204);
        
    }else{
        return CGSizeMake((WIDTH - 48) / 2,244 );
        
    }
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeOneCollectionViewCell" forIndexPath:indexPath];
        if (self.dataArr.count > 0) {
            NSArray *arr = self.dataArr[indexPath.section][@"productDtoList"];
        
            cell.dataArr = arr;
        }
       
        [cell setCellItemClickBlock:^(NSDictionary * _Nonnull dic) {
            HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
            vc.prodId = dic[@"prodId"];
            [self pushController:vc];
    
        }];
        return cell;
    }
    else{
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"HomeCollectionViewCell" owner:self options:nil].lastObject;
        }
        if (self.dataArr.count> 0) {
            NSArray *arr = self.dataArr[indexPath.section][@"productDtoList"];
            
            NSDictionary *dic = arr[indexPath.item];
            cell.dic = dic;
        }
        
        
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (self.dataArr.count> 0) {
            
            NSArray *arr = self.dataArr[indexPath.section][@"productDtoList"];
            
            NSDictionary *dic = arr[indexPath.item];
            
            HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
            vc.prodId = dic[@"prodId"];
            [self pushController:vc];
        }
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
