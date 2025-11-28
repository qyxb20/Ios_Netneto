//
//  LiveAddShopGoodsView.m
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "LiveAddShopGoodsView.h"
@interface LiveAddShopGoodsView ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *whieView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) JXCategoryTitleView *pageView;
@property (nonatomic, strong) JXCategoryListContainerView *pageContainView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong)NSMutableArray *prodIdsArr;
@property(nonatomic, strong)NSString *shopId;
@end
@implementation LiveAddShopGoodsView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    [self.closeBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
    self.titleLabel.text = TransOutput(@"添加商品");
    self.sureBtn.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 32];
    [self.sureBtn setTitle:TransOutput(@"确定添加") forState:UIControlStateNormal];
    [self.sureBtn addTapAction:^(UIView * _Nonnull view) {
            @strongify(self);
        [self subClick];
    }];
    self.prodIdsArr = [NSMutableArray array];
}
-(void)subClick{
    if (self.prodIdsArr.count == 0) {
        ToastShow(TransOutput(@"请选择商品"), errImg,RGB(0xFF830F));
        return;
    }
    [NetwortTool getAddShowCartWithParm:@{@"shopId":self.shopId,@"prodIds":[self.prodIdsArr componentsJoinedByString:@","]} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ToastShow(TransOutput(@"添加成功"), @"chenggong",RGB(0x36D053));
            [self.prodIdsArr removeAllObjects];
            [self removeFromSuperview];
        });
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
     
    }];
}
-(void)updataData{
    [self.pageView removeFromSuperview];
    [self.pageContainView removeFromSuperview];
    self.prodIdsArr = [NSMutableArray array];
    [self GetData];
    
}
-(void)GetData{
    self.dataArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    self.prodIdsArr = [NSMutableArray array];
    [NetwortTool getLiveShopCarClassWithSuccess:^(id  _Nonnull responseObject) {
       
        NSLog(@"输出小黄车商品分类：%@",responseObject);
        NSArray *arr = responseObject[@"data"];
        for (NSDictionary *dic in arr) {
            [self.titleArr addObject:[NSString isNullStr:dic[@"categoryName"]]];
            [self.dataArr addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.pageView.titles = self.titleArr;
           
            [self.whieView addSubview:self.pageView];
            [self.whieView addSubview: self.pageContainView];
        });
        
    } failure:^(NSError * _Nonnull error) {
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
     
    }];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.pageContainView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
   
    LiveAddChildViewController *vc = [[LiveAddChildViewController alloc] init];
    vc.dic = self.dataArr[index];
    vc.channel = self.channel;
    [vc setAddGoodsBlock:^(NSDictionary * _Nonnull dic, NSString * _Nonnull shopId) {
        self.shopId = shopId;
        if ([self.prodIdsArr containsObject:dic[@"prodId"]]) {
            [self.prodIdsArr removeObject:dic[@"prodId"]];
        }
        else{
            [self.prodIdsArr addObject:dic[@"prodId"]];
       
        }
    }];
        return vc;
   
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.pageView.titles.count;;
}

- (JXCategoryTitleView *)pageView {
    if (!_pageView) {
        _pageView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(16, 56, WIDTH-16, 43)];
        _pageView.backgroundColor = [UIColor whiteColor];
        
        _pageView.averageCellSpacingEnabled = NO;
        _pageView.delegate = self;
        _pageView.contentEdgeInsetLeft = 10;
        _pageView.contentEdgeInsetRight = 10;
        _pageView.cellSpacing = 20;
        _pageView.titleColor =RGB(0x717272);
        _pageView.titleSelectedColor = RGB(0x197CF5);
        _pageView.titleFont = [UIFont systemFontOfSize:12];
        _pageView.titleSelectedFont = [UIFont systemFontOfSize:12];
        _pageView.titleLabelZoomEnabled = YES;
        _pageView.titleLabelZoomScale = 1;
        _pageView.titleColorGradientEnabled = YES;
        _pageView.listContainer = self.pageContainView;
        
        JXCategoryIndicatorLineView *indictView = [[JXCategoryIndicatorLineView alloc] init];
        indictView.indicatorWidth = 40;
        indictView.indicatorHeight = 2;
        indictView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
        indictView.indicatorColor = [UIColor gradientColorArr:MainColorArr withWidth:60];
        indictView.indicatorCornerRadius = 1;
        indictView.verticalMargin = 5;
        _pageView.indicators = @[indictView];
    }
    return _pageView;
}

- (JXCategoryListContainerView *)pageContainView {
    if (!_pageContainView) {
        _pageContainView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _pageContainView.backgroundColor = [UIColor whiteColor];
        _pageContainView.frame = CGRectMake(0, self.pageView.bottom + 10, WIDTH, 580-self.pageView.bottom - 10 - 76);
    }
    return _pageContainView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
