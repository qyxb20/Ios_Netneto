//
//  ImageViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/30.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisTaps)];
    
    [self.view addGestureRecognizer:taps];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
    imageV.center = self.view.center;
    imageV.image = [UIImage imageWithData:self.imageData];
    [self.view addSubview:imageV];
}

- (void)dismisTaps{
    [self dismissViewControllerAnimated:YES completion:nil];
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
