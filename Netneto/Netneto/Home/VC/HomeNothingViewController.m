//
//  HomeNothingViewController.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/19.
//

#import "HomeNothingViewController.h"

@interface HomeNothingViewController ()
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)NothingView *nothingView;

@end

@implementation HomeNothingViewController

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
    self.navigationItem.title = self.titleStr;
    
    [self.view addSubview:self.nothingView];
    [self.nothingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.top.mas_offset(HeightNavBar);
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
        _nothingView.ima.image = [UIImage imageNamed:@"shopcartEmty"];
        _nothingView.titleLabel.textAlignment = NSTextAlignmentLeft;
        NSString *str = @"";
        if ([self.titleStr isEqual:TransOutput(@"限时优惠")]) {
            _nothingView.titleLabel.text = TransOutput(@"限时优惠暂无活动，很抱歉给您带来不便，请您谅解");
            
        }else if ([self.titleStr isEqual:TransOutput(@"每日疯抢")]){
            _nothingView.titleLabel.text = TransOutput(@"每日疯抢暂无活动，很抱歉给您带来不便，请您谅解");
            
        }else if ([self.titleStr isEqual:TransOutput(@"领优惠券")]){
            _nothingView.titleLabel.text = TransOutput(@"领优惠券暂无活动，很抱歉给您带来不便，请您谅解");
        }else{
            _nothingView.titleLabel.text = TransOutput(@"暂无活动，很抱歉给您带来不便，请您谅解");
        }
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
