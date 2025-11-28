//
//  LiveStartShowView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/7.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveStartShowView : BaseView
@property(nonatomic, copy) void(^startLiveBlock) (NSString *title,NSString *noti,NSString *pic,RoomInfoModel *model,NSString *categoryId,NSString *categoryName);
@property(nonatomic, copy) void(^picClickBlock) (void);
@property (nonatomic, copy) void (^pushLiveXieyiClickBlock) (void);
@property (nonatomic, copy) void (^categoryChoseClickBlock) (void);
+ (instancetype)initViewNIB;
@property (weak, nonatomic) IBOutlet UIButton *picBtn;
-(void)updataModel:(RoomInfoModel*)model;
//@property (nonatomic, strong) RoomInfoModel*model;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSDictionary *categoryNameDic;
@end

NS_ASSUME_NONNULL_END
