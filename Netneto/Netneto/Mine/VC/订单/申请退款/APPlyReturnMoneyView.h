//
//  APPlyReturnMoneyView.h
//  Netneto
//
//  Created by apple on 2024/10/17.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface APPlyReturnMoneyView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) OrderModel *model;
@property(nonatomic, strong) OrderModel *modelItem;
@property(nonatomic, copy) void (^submitBlock) (NSString *orderItemId,NSString *goodsNum, NSString *photoFiles,NSString *buyerMsg,NSString *orderNumber,NSString *applyType,OrderModel *modelDic);
@property(nonatomic, copy) void (^chosePicBlock)(void);
@property(nonatomic, copy) void (^upPicBlock)(void);
@property(nonatomic, copy) void (^typeBlock)(void);
@property(nonatomic, copy) void (^delBlock)(NSInteger index);
-(void)updateColloc:(NSMutableArray *)imageArray;
-(void)uploadDel:(NSMutableArray *)imageArray;
-(void)loadData;
-(void)updaApplyType:(NSString *)type;
@property (weak, nonatomic) IBOutlet UIView *backVIew;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UITextView *numTF;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextView *resonTX;
@end

NS_ASSUME_NONNULL_END
