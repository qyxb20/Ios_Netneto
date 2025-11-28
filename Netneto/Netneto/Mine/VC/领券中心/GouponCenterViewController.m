//
//  GouponCenterViewController.m
//  Netneto
//
//  Created by apple on 2025/1/16.
//

#import "GouponCenterViewController.h"

@interface GouponCenterViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong)UIImageView *bgHeaderView;

@property (nonatomic, strong) JXCategoryTitleView *pageView;
@property (nonatomic, strong) JXCategoryListContainerView *pageContainView;
@property(nonatomic, strong)UIView *searchView;
@property(nonatomic, strong)UIImageView *SearchImageView;
@property(nonatomic, strong)UITextField *searchTF;
@end

@implementation GouponCenterViewController
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
    
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
  
        [self.view addSubview:self.searchView];
        [self.searchView addSubview:self.SearchImageView];
        [self.searchView addSubview:self.searchTF];
        [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(109);
            make.leading.mas_offset(16);
            make.trailing.mas_offset(-16);
            make.height.mas_offset(37);
        }];
        [self.SearchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_offset(-16);
            make.top.mas_offset(11);
            make.width.height.mas_offset(15);
        }];
        [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.trailing.mas_equalTo(self.SearchImageView.mas_leading).offset(-10);
            make.top.mas_offset(8.5);
            make.height.mas_offset(20);
        }];
    
   
    
    [self.view addSubview:self.pageView];
  
    [self.view addSubview:self.pageContainView];
    
    
    // Do any additional setup after loading the view.
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.pageContainView didClickSelectedItemAtIndex:index];
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

        GouponCenterChildViewController *vc = [[GouponCenterChildViewController alloc] init];
        vc.titleStr =self.pageView.titles[index];
    vc.rootTitleStr = self.title;
    if (self.pageView.titles.count == 3) {
        vc.type = @"0";
    }
    else{
        vc.type = @"1";
    }
    vc.searchStr = self.searchTF.text;
        return vc;

}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.pageView.titles.count;;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCouponChild" object:nil userInfo:@{@"searchText":textField.text}];
    [self.searchTF resignFirstResponder];
    return YES;
}
#pragma mark - lazy load
-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.layer.cornerRadius = 18.5;
        _searchView.clipsToBounds = YES;
        _searchView.userInteractionEnabled = YES;
        _searchView.backgroundColor = [UIColor gradientColorArr:@[RGB(0xF7F7F7),RGB(0xF7F7F7)] withWidth:WIDTH - 32];
      

    }
    return _searchView;
}
-(UIImageView *)SearchImageView{
    if (!_SearchImageView) {
        _SearchImageView = [[UIImageView alloc] init];
        _SearchImageView.image = [UIImage imageNamed:@"homeSearch"];
        _SearchImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_SearchImageView addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadCouponChild" object:nil userInfo:@{@"searchText":self.searchTF.text}];
            [self.searchTF resignFirstResponder];
        }];
    }
    return _SearchImageView;;
}
-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] init];
        _searchTF.enabled = YES;
        _searchTF.delegate = self;
        _searchTF.font = [UIFont fontWithName:@"思源黑体" size:14];
        _searchTF.placeholder = TransOutput(@"搜索");
    }
    return _searchTF;
}
- (JXCategoryTitleView *)pageView {
    if (!_pageView) {
        
            _pageView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 109+47, WIDTH , 43)];
        
        _pageView.backgroundColor = [UIColor whiteColor];
        _pageView.titles = self.titleArr;
        _pageView.averageCellSpacingEnabled = NO;
        _pageView.delegate = self;
        _pageView.contentEdgeInsetLeft = 10;
        _pageView.contentEdgeInsetRight = 10;
        _pageView.cellWidthIncrement = 2;
        _pageView.cellSpacing = 20;
        _pageView.titleColor = RGB(0x717272);
        _pageView.titleSelectedColor = [UIColor gradientColorArr:MainColorArr withWidth:100];
        _pageView.titleFont = [UIFont systemFontOfSize:14];
      
        _pageView.titleLabelZoomEnabled = YES;
        _pageView.titleLabelZoomScale = 1.0;
        _pageView.titleColorGradientEnabled = YES;
        _pageView.listContainer = self.pageContainView;
        
        JXCategoryIndicatorLineView *indictView = [[JXCategoryIndicatorLineView alloc] init];
        indictView.indicatorWidth = 33;
        indictView.indicatorHeight = 3;
        indictView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
        indictView.indicatorColor = [UIColor gradientColorArr:MainColorArr withWidth:100];
        indictView.indicatorCornerRadius = 1.5;
        indictView.verticalMargin = 0;
        _pageView.indicators = @[indictView];
    }
    return _pageView;
}

- (JXCategoryListContainerView *)pageContainView {
    if (!_pageContainView) {
        _pageContainView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _pageContainView.backgroundColor = [UIColor whiteColor];
        _pageContainView.frame = CGRectMake(0, self.pageView.bottom + 10, WIDTH, HEIGHT-self.pageView.bottom - 10);
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
