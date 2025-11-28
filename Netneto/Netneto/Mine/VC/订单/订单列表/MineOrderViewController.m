//
//  MineOrderViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/24.
//

#import "MineOrderViewController.h"

@interface MineOrderViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *pageView;
@property (nonatomic, strong) JXCategoryListContainerView *pageContainView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@property (nonatomic, strong) ShaiXuanView*shaiView;
@property(nonatomic, strong)NSString *timeRange;
@end

@implementation MineOrderViewController
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

    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
       [rightButtonView addSubview:rightButton];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitle:TransOutput(@"筛选") forState:UIControlStateNormal];
       [rightButton addTarget:self action:@selector(choseClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGB(0xFFFFFF) forState:UIControlStateNormal];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
      self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    self.timeRange = @"";
}
-(void)choseClick{
    [APPDELEGATE.window addSubview:self.shaiView];
    [self.shaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_offset(0);
    }];
    @weakify(self);
    [self.shaiView setSureBlock:^(NSString * _Nonnull timeStr) {
        @strongify(self)
        if ([timeStr isEqual:TransOutput(@"1个月")]) {
            self.timeRange = @"1";
        }
       else if ([timeStr isEqual:TransOutput(@"3个月")]) {
            self.timeRange = @"3";
        }
       else if ([timeStr isEqual:TransOutput(@"6个月")]) {
            self.timeRange = @"6";
        }
       else if ([timeStr isEqual:TransOutput(@"今年")]) {
            self.timeRange = @"12";
        }
       else{
           self.timeRange = @"";
       }
        [self.pageContainView reloadData];
        [self.shaiView removeFromSuperview];
    }];
}
-(void)CreateView{
    self.view.backgroundColor = RGB(0xF9F9F9);
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView addSubview:self.searchView];
    [self.searchView addSubview:self.SearchImageView];
    [self.searchView addSubview:self.searchTF];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-8);
        make.leading.mas_offset(55);
        make.trailing.mas_offset(-95);
        make.height.mas_offset(30);
    }];
    [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(12);
        make.top.mas_offset(6.5);
        make.width.height.mas_offset(17);
    }];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.SearchImageView.mas_trailing).offset(10);
        make.trailing.mas_offset(-10);
        make.top.mas_offset(5);
        make.height.mas_offset(20);
    }];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, WIDTH, 1)];
    line.backgroundColor = RGB(0xE1E1E1);
    [self.view addSubview:line];
    [self.view addSubview:self.pageView];
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pageView.bottom-2, WIDTH, 1)];
    line1.backgroundColor = RGB(0xE1E1E1);
    [self.view addSubview:line1];
    [self.view addSubview:self.pageContainView];
    self.pageView.defaultSelectedIndex = self.index;
    
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
        _searchView.layer.cornerRadius = 15;
        _searchView.clipsToBounds = YES;
        _searchView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xFFFFFF),RGB(0xFFFFFF)] withWidth:WIDTH - 50];
        @weakify(self)
        [_searchView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            OrderSearchViewViewController *vc = [[OrderSearchViewViewController alloc] init];
            vc.index = self.pageView.selectedIndex;
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
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.pageContainView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

        MineOrderChildViewController *vc = [[MineOrderChildViewController alloc] init];
        vc.index = index;
    vc.timeRange = self.timeRange;
        return vc;

}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.pageView.titles.count;;
}

#pragma mark - lazy load
- (JXCategoryTitleView *)pageView {
    if (!_pageView) {
        _pageView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 100, WIDTH , 43)];
        _pageView.backgroundColor = [UIColor whiteColor];
        _pageView.titles = @[TransOutput(@"全部"),TransOutput(@"待支付"),TransOutput(@"待发货"),TransOutput(@"待收货"),TransOutput(@"已完成"),TransOutput(@"退款/退货")];
        _pageView.averageCellSpacingEnabled = NO;
        _pageView.delegate = self;
        _pageView.contentEdgeInsetLeft = 10;
        _pageView.contentEdgeInsetRight = 10;
        _pageView.cellWidthIncrement = 15;
        _pageView.cellSpacing = 20;
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
        _pageContainView.frame = CGRectMake(0, self.pageView.bottom + 10, WIDTH, HEIGHT-43-100 - 10);
    }
    return _pageContainView;
}
-(ShaiXuanView *)shaiView{
    if (!_shaiView) {
        _shaiView = [ShaiXuanView initViewNIB];
        _shaiView.backgroundColor = [UIColor clearColor];
    }
    return _shaiView;
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
