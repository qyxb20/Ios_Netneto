//
//  addShopUserCustomView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface addShopUserCustomView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *customTF;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchWidth;

+ (instancetype)initViewNIB;
@end

NS_ASSUME_NONNULL_END
