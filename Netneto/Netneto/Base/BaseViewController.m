//
//  BaseViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseViewController.h"

@interface BaseViewController ()<SRWebSocketDelegate>
@property(nonatomic,strong)SRWebSocket *socket;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hbd_titleTextAttributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold],
        NSForegroundColorAttributeName:RGB(0xFFFFFF)
    };
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = RGB(0xFFFFFF);
    self.hbd_barShadowHidden = YES;
    self.hbd_barAlpha = 0;
    self.currentPage = 1;
    
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updataShopNumber" object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (account.isLogin) {
                [self getCarNumber];

            }
            else{
                [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
            }
        });
    }];
    [self initData];
    [self CreateView];
    [self GetData];

}
#pragma mark - 获取购物车商品数量
-(void)getCarNumber{
    
    [NetwortTool getGoodsNumberWithParm:@{} Success:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [NSString stringWithFormat:@"%@",responseObject];
            if ([str isEqual:@"0"] ) {
                [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
            }else{
                if ([responseObject integerValue] > 99) {
                    [self.tabBarController.tabBar showBadgeOnItemIndex:2 tex:[NSString stringWithFormat:@"99+"]];
                }
                else{
                    [self.tabBarController.tabBar showBadgeOnItemIndex:2 tex:[NSString stringWithFormat:@"%@",responseObject]];
                }
            }
        });
    } failure:^(NSError * _Nonnull error) {
        [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
    }];
}


- (void)initData{}
- (void)CreateView{}
- (void)GetData{}
- (void)setNavTitle:(NSString *)navTitle {
    self.navigationItem.title = navTitle;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }else {
        return UIStatusBarStyleDefault;
    }
}


- (void)pushViewController:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
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
