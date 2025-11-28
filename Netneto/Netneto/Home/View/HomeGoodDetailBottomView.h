//
//  HomeGoodDetailBottomView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeGoodDetailBottomView : BaseView
+ (instancetype)initViewNIB;
-(void)updateNumber;
@property (nonatomic, copy) void (^pushCarClickBlock) (void);
@property (nonatomic, copy) void (^joinCarClickBlock) (void);
@property (nonatomic, copy) void (^buyClickBlock) (void);
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UILabel *keLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kefuX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kefuW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *varX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nowW;


@property (nonatomic, copy) void (^kefuClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
