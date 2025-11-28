//
//  ClassificationViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "ClassificationViewController.h"

@interface ClassificationViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** 左侧 */
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) NSMutableArray *leftDataArray;

/** 右侧 */
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) NSMutableArray *rightDataArray;

/** 选中效果 */
@property (nonatomic, assign) NSInteger index_selected;

@property(nonatomic, strong)UIImageView *bgHeaderView;


@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@property(nonatomic, strong)ClassNameModel *selectModel;

@end

@implementation ClassificationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hbd_barHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hbd_barHidden = NO;
}
-(void)initData{
    
}
-(void)CreateView{
     [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(0);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width*0.3));
    }];
    
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(0);
       
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(50);
        make.leading.mas_offset(25);
        make.trailing.mas_offset(-25);
        make.height.mas_offset(37);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.top.mas_offset(9.23);
        make.width.height.mas_offset(17);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.SearchImageView.mas_trailing).offset(10);
        make.trailing.mas_offset(-10);
        make.top.mas_offset(8);
        make.height.mas_offset(20);
    }];
}
- (void)GetData{
    [NetwortTool getClassParentData:@{@"parentId":@"0"} Success:^(id  _Nonnull responseObject){
        NSArray *arr = responseObject;
        self.leftDataArray = [arr mutableCopy];
        self.selectModel = [ClassNameModel mj_objectWithKeyValues:self.leftDataArray.firstObject];
        [self getColloctionData:self.selectModel];
        [self.leftTableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
    
   
   

}
-(void)getColloctionData:(ClassNameModel*)model{
    [NetwortTool getClassParentData:@{@"parentId":model.categoryId} Success:^(id  _Nonnull responseObject){
        NSArray *arr = responseObject;
        self.rightDataArray = [arr mutableCopy];
        [self.rightCollectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
    }];
    
}
#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ClassNameTableViewCell class])];

    ClassNameModel *model = [[ClassNameModel alloc]init];
    model = [ClassNameModel mj_objectWithKeyValues:self.leftDataArray[indexPath.row]];
    
    if (_index_selected == indexPath.row) {
        model.isSeleced = YES;
    }else{
        model.isSeleced = NO;
    }
    
    cell.tabModel = model;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _index_selected = indexPath.row;
    self.selectModel = [ClassNameModel mj_objectWithKeyValues:self.leftDataArray[indexPath.row]];
      [self getColloctionData:self.selectModel];
  
    [self leftTableViewOffsetWithIndexPath:indexPath];
    [self.leftTableView reloadData];
    
    
    
    
}
#pragma mark - UICollectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.rightDataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        NSArray *arr =self.rightDataArray[section-1][@"categories"];
        return arr.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ClassContentTopCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ClassContentTopCollectionViewCell class]) forIndexPath:indexPath];
        
    
        cell.topModel = self.selectModel;
        return cell;
        
    }else{
        ClassContentCommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ClassContentCommonCollectionViewCell class]) forIndexPath:indexPath];
        NSArray *arr =self.rightDataArray[indexPath.section -1][@"categories"];
      
        cell.model = [ClassContentModel mj_objectWithKeyValues:arr[indexPath.row]];
        return cell;
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width*0.7, 100+10*2);
        
    }else{
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width*0.7 - 4*10)*0.33, ([UIScreen mainScreen].bounds.size.width*0.7 - 4*10)*0.33+5*2+40);
        
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0);
        
    }else{
        return CGSizeMake([UIScreen mainScreen].bounds.size.width*0.7, 50);
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *reuserbleViwe = nil;
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (indexPath.section != 0) {
            for (UILabel *label in headerView.subviews) {
                [label removeFromSuperview];
            }
            
  
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.textColor = RGB(0x333333);
            titleLabel.font = [UIFont boldSystemFontOfSize:15];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.text = [NSString isNullStr:self.rightDataArray[indexPath.section-1][@"categoryName"]];
            [headerView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.equalTo(headerView);
                make.left.equalTo(headerView.mas_left).offset(10);
            }];
            
            
        }
        
        
        
        reuserbleViwe = headerView;
        
        return reuserbleViwe;
        
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {
        NSArray *arr =self.rightDataArray[indexPath.section -1][@"categories"];
      
        ClassContentModel *model = [ClassContentModel mj_objectWithKeyValues:arr[indexPath.row]];
    
        HomeSectionViewController *vc = [[HomeSectionViewController alloc] init];
        vc.isClass = YES;
        vc.titleStr = [NSString isNullStr:model.categoryName];
        vc.categoryId = [NSString stringWithFormat:@"%@",[NSString isNullStr:model.categoryId]];
        [self pushController:vc];
    }
}


#pragma mark -  私有方法
- (void)leftTableViewOffsetWithIndexPath:(NSIndexPath *)indexPath
{
   
}



#pragma mark - 懒加载
- (UICollectionView *)rightCollectionView{
    if (_rightCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
        
        /** 注册 */
        [_rightCollectionView registerClass:[ClassContentTopCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ClassContentTopCollectionViewCell class])];
        [_rightCollectionView registerClass:[ClassContentCommonCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ClassContentCommonCollectionViewCell class])];
        
        /** 注册-头部视图 */
        [_rightCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
    }
    return _rightCollectionView;
}

- (UITableView *)leftTableView{
    if (_leftTableView == nil) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = RGB(0xF7F7F7);
        _leftTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _leftTableView.showsVerticalScrollIndicator = NO;
        
        /** 注册 */
        [_leftTableView registerClass:[ClassNameTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ClassNameTableViewCell class])];
        
    }
    return _leftTableView;
}


- (NSMutableArray *)leftDataArray{
    if (_leftDataArray == nil) {
        _leftDataArray = [NSMutableArray array];
    }
    return _leftDataArray;
}

- (NSMutableArray *)rightDataArray{
    if (_rightDataArray == nil) {
        _rightDataArray = [NSMutableArray array];
    }
    return _rightDataArray;
}

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
        _searchView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xFFFFFF),RGB(0xFFFFFF)] withWidth:WIDTH - 50];
        @weakify(self)
        [_searchView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            searchViewController *vc = [[searchViewController alloc] init];
            [self pushController:vc];
   
                }];
    }
    return _searchView;
}
-(UIImageView *)SearchImageView{
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = YES;
    }
    return _SearchImageView;;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = NO;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.text = TransOutput(@"搜索");
    }
    return _searchTF;
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
