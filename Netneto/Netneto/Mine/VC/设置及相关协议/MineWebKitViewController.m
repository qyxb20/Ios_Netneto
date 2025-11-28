//
//  MineWebKitViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/24.
//

#import "MineWebKitViewController.h"

@interface MineWebKitViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *vi;
@property(nonatomic, strong)UIImageView *bgHeaderView;
@end

@implementation MineWebKitViewController
-(UIImageView *)bgHeaderView{
    if (!_bgHeaderView) {
        _bgHeaderView = [[UIImageView alloc] init];
        _bgHeaderView.userInteractionEnabled = YES;
        _bgHeaderView.image = [UIImage imageNamed:@"homeBackground"];
        
    }
    return _bgHeaderView;
}
-(void)CreateView{
    [self.view addSubview:self.bgHeaderView];
    [self.bgHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_offset(0);
        make.height.mas_offset(99);
    }];
    [self.vi addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.vi loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.vi.scrollView.contentInset = UIEdgeInsetsZero;

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.vi) {
            self.title = self.vi.title;
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
