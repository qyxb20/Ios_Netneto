//
//  printWuView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface printWuView : BaseView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuGName;
@property (weak, nonatomic) IBOutlet UITextField *wuGTF;
@property (weak, nonatomic) IBOutlet UILabel *numName;
@property (weak, nonatomic) IBOutlet UITextField *numLabel;
@property (weak, nonatomic) IBOutlet UIView *backVIew;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

+ (instancetype)initViewNIB;

@property (nonatomic, copy) void (^subClickBlock) (NSString *name,NSString *number);
@end

NS_ASSUME_NONNULL_END
