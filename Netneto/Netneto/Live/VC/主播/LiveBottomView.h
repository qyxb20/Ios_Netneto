//
//  LiveBottomView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/11.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveBottomView : BaseView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
+ (instancetype)initViewNIB;
@property(nonatomic, copy) void(^SendMessageBlock) (NSString *message);
@end

NS_ASSUME_NONNULL_END
