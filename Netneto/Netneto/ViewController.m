//
//  ViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) UIImageView *bgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /**加载数据*/
    [account loadRootController];
    // Do any additional setup after loading the view.
}


@end
