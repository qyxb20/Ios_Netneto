//
//  MyShopViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/11.
//

#import "MyShopViewController.h"

@interface MyShopViewController ()
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property (nonatomic, strong) NothingView *nothingView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation MyShopViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    self.navigationItem.title = TransOutput(@"我的店铺");
    self.nothingView.frame = CGRectMake(0, 180, WIDTH, HEIGHT - 460);
    [self.view addSubview:self.nothingView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:TransOutput(@"发布店铺") forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor gradientColorArr:MainColorArr withWidth:WIDTH - 30];
    self.button.layer.cornerRadius = 22;
    self.button.clipsToBounds = YES;
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(15);
        make.bottom.mas_offset(-8);
        make.height.mas_offset(44);
        make.trailing.mas_offset(-15);
    }];
   
    @weakify(self);
    [self.button addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ModeyShopInfoViewController *vc = [[ModeyShopInfoViewController alloc] init];
        vc.isShopVC = @"0";
        [self pushController:vc];
    }];
    
    
    
    // Do any additional setup after loading the view.
}
-(NothingView *)nothingView{
    if (!_nothingView) {
        _nothingView =[NothingView initViewNIB];
        _nothingView.backgroundColor = [UIColor clearColor];
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.text = TransOutput(@"暂无数据");
    }
    return _nothingView;
}
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
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
