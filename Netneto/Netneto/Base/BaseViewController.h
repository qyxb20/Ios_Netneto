//
//  BaseViewController.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, LoginType) {
    LoginType_phone,
    LoginType_psd,
};

typedef void(^backBlock)(void);
typedef void(^rightBtnBlock)(void);

@interface BaseViewController : UIViewController
@property(nonatomic,copy)backBlock backBlock;
@property(nonatomic,copy)rightBtnBlock rightBlock;

@property (nonatomic, assign) BOOL navBarHidden;
@property (nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign)NSInteger pageSize;
@property(nonatomic,copy)NSString *navTitle;


- (void)initData;
- (void)CreateView;
- (void)GetData;
- (void)pushViewController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
