//
//  shopindructViewController.m
//  Netneto
//
//  Created by apple on 2024/11/13.
//

#import "shopindructViewController.h"

@interface shopindructViewController ()
@property(nonatomic, strong)UIImageView *bgHeaderView;
@property(nonatomic, strong)UIImageView *bgTableViewImge;
@property(nonatomic, strong)UILabel *content;
@end

@implementation shopindructViewController
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
    self.navigationItem.title = TransOutput(@"店铺简介");
    [self.view addSubview:self.bgTableViewImge];
    [self.bgTableViewImge addSubview:self.content];
    self.content.text = self.into;
    
    [self.bgTableViewImge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_equalTo(self.bgHeaderView.mas_bottom).offset(16);
        make.trailing.bottom.mas_offset(-16);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(16);
        make.top.mas_offset(16);
        make.trailing.mas_offset(-16);
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
-(UIImageView *)bgTableViewImge{
    if (!_bgTableViewImge) {
        _bgTableViewImge = [[UIImageView alloc] init];
        _bgTableViewImge.image = [UIImage imageNamed:@"矩形 1450"];
        
    }
    return _bgTableViewImge;
}
-(UILabel *)content{
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont systemFontOfSize:14];
        _content.numberOfLines = 0;
        
    }
    return _content;
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
