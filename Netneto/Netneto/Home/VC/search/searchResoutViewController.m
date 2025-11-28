//
//  searchResoutViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/23.
//

#import "searchResoutViewController.h"

@interface searchResoutViewController () <UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) NothingView *nothingView;
@end

@implementation searchResoutViewController
-(void)initData{
    
}
-(void)CreateView{
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 80, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 100, 44)];
    self.searchBar.delegate = self;
    self.searchBar.text = self.searStr;

    self.searchBar.showsCancelButton = NO;
    // 键盘确认按钮的名字
    self.searchBar.returnKeyType = UIReturnKeySearch;
    // 把默认灰色背景浮层给去掉
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    UITextField *searBarTextField;
    if (@available(iOS 13.0, *)) {
        searBarTextField =[_searchBar valueForKey:@"_searchTextField"];
               }else{
                   searBarTextField = [_searchBar valueForKey:@"_searchField"];
           }
    if (searBarTextField)
    {
        [searBarTextField setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]];
        searBarTextField.borderStyle = UITextBorderStyleRoundedRect;
        searBarTextField.layer.cornerRadius = 5.0f;
    }
    else
    {
        // 通过颜色画一个Image出来
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1] size:CGSizeMake(28, 28)];
        [self.searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    }
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;

    if (@available(iOS 11.0, *)) {

          self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

      }
     [self.view addSubview:self.collectionView];
  
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.trailing.mas_equalTo(0);
      make.top.mas_equalTo(115);
      make.bottom.mas_equalTo(self.view.mas_bottom);
      
  }];

}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
       
        
        _collectionView.showsVerticalScrollIndicator = NO;
         [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
        
       
   
       
        }
    return _collectionView;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
        return CGSizeMake((WIDTH - 64) / 2,244);
        
    
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HomeCollectionViewCell" owner:self options:nil].lastObject;
    }
  
    NSDictionary *dic = self.dataArr[indexPath.item];
   
    cell.dic = dic;
    
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.item];
   
   
   
    HomeGoodDetailViewController *vc = [[HomeGoodDetailViewController alloc] init];
    vc.prodId = dic[@"prodId"];
    [self pushController:vc];
}
// 配置

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *useridStr = @"";
    if (account.isLogin) {
        useridStr =[NSString stringWithFormat:@"%@",account.userInfo.userId];
    }
    [NetwortTool getHomeSearchData:@{@"prodName":searchBar.text,@"sort":@"0",@"orderBy":@"0",@"userId":useridStr} Success:^(id  _Nonnull responseObject) {
        NSLog(@"搜索结果%@",responseObject);
        self.dataArr = responseObject[@"records"];
        [self.collectionView reloadData];
        
        self.nothingView.frame = CGRectMake(0, 80, WIDTH, HEIGHT - 460);
        
      if (self.dataArr.count == 0) {
          self.collectionView.backgroundView = self.nothingView;
         
      }
      else{
         
          self.collectionView.backgroundView = nil;
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
        _nothingView.titleLabel.text = TransOutput(@"暂无搜索数据");
    }
    return _nothingView;
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
