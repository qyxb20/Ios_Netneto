//
//  LiveShopCartView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/12.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveShopCartView : BaseView
-(void)updataList:(NSString *)Channel isadmin:(NSString *)isadmin;
+ (instancetype)initViewNIB;
@property(nonatomic, copy) void(^addShopBlock) (void);
@property(nonatomic, copy) void(^pushGoodDetailBlock) (NSDictionary *dic);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pubHeight;
@property (nonatomic, assign) BOOL isShowDown;
@end

NS_ASSUME_NONNULL_END
