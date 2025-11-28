//
//  MyCollectViewController.m
//  Netneto
//
//  Created by apple on 2024/10/24.
//

#import "MyCollectViewController.h"

@interface MyCollectViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@property(nonatomic, strong)NSString *searchCount;
@property (nonatomic, strong) JXCategoryTitleView *pageView;
@property (nonatomic, strong) JXCategoryListContainerView *pageContainView;
@end

@implementation MyCollectViewController
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
    self.searchCount = @"";
}
-(void)CreateView{
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"我的收藏");
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(10);
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 99 + 57, WIDTH, 1)];
    line.backgroundColor = RGB(0xE1E1E1);
    [self.view addSubview:line];
    [self.view addSubview:self.pageView];
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pageView.bottom-2, WIDTH, 1)];
    line1.backgroundColor = RGB(0xE1E1E1);
    [self.view addSubview:line1];
    [self.view addSubview:self.pageContainView];
    
    
    // Do any additional setup after loading the view.
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.pageContainView didClickSelectedItemAtIndex:index];
    if (index == 0) {
        _searchTF.placeholder = TransOutput(@"请输入商品关键字");
       
    }else {
        _searchTF.placeholder = TransOutput(@"请输入店铺关键字");
       
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
          MyCollectGoodsViewController *vc = [[MyCollectGoodsViewController alloc] init];
        vc.searchCount = self.searchCount;
        return vc;
    }else {
         MyCollectShopViewController *vc = [[MyCollectShopViewController alloc] init];
        vc.searchCount = self.searchCount;
        return vc;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.pageView.titles.count;;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    self.searchCount = [textField.text stringByReplacingCharactersInRange:range withString:string];
        

    [self.pageContainView reloadData];
    return YES;
}

#pragma mark - 搜索回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchCount = textField.text;
    [self.pageContainView reloadData];
    return YES;
}
#pragma mark - lazy load
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 18.5;
        _searchView.clipsToBounds = YES;
        _searchView.backgroundColor =RGB(0xEBEDEF);
        
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
        _searchTF.enabled = YES;
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.placeholder = TransOutput(@"请输入商品关键字");
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
    }
    return _searchTF;
}
- (JXCategoryTitleView *)pageView {
    if (!_pageView) {
        _pageView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 158, WIDTH , 43)];
        _pageView.backgroundColor = [UIColor whiteColor];
        _pageView.titles = @[TransOutput(@"商品"),TransOutput(@"店铺")];
        _pageView.averageCellSpacingEnabled = NO;
        _pageView.delegate = self;
        _pageView.contentEdgeInsetLeft = 10;
        _pageView.contentEdgeInsetRight = 10;
        _pageView.cellWidthIncrement = 15;
        _pageView.cellSpacing = 20;
        _pageView.cellWidth = (WIDTH - 40) / 2;
        _pageView.titleColor = RGB(0x717272);
        _pageView.titleSelectedColor = [UIColor gradientColorArr:MainColorArr withWidth:100];
        _pageView.titleFont = [UIFont systemFontOfSize:14];
        _pageView.titleLabelZoomEnabled = YES;
        _pageView.titleLabelZoomScale = 1.3;
        _pageView.titleColorGradientEnabled = YES;
        _pageView.listContainer = self.pageContainView;
        
        JXCategoryIndicatorLineView *indictView = [[JXCategoryIndicatorLineView alloc] init];
        indictView.indicatorWidth = 33;
        indictView.indicatorHeight = 3;
        indictView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
        indictView.indicatorColor = [UIColor gradientColorArr:MainColorArr withWidth:100];
        indictView.indicatorCornerRadius = 1.5;
        indictView.verticalMargin = 5;
        _pageView.indicators = @[indictView];
    }
    return _pageView;
}

- (JXCategoryListContainerView *)pageContainView {
    if (!_pageContainView) {
        _pageContainView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _pageContainView.backgroundColor = [UIColor whiteColor];
        _pageContainView.frame = CGRectMake(0, self.pageView.bottom + 10, WIDTH, HEIGHT-158 - 10);
    }
    return _pageContainView;
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
