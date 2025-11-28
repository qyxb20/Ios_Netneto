//
//  MineHeaderView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/14.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView : BaseView
@property(nonatomic, strong)UIButton *avatarBtn;
@property(nonatomic, strong)UIButton *nameLabel;
@property(nonatomic, strong)UILabel *idLabel;
@property(nonatomic, strong)UIButton *typeImageView;
@property(nonatomic, copy) void (^loginBlock) (void);
@property(nonatomic, copy) void (^pushOrderBlock) (NSInteger tag);
@property(nonatomic, copy) void(^pushEditInfoBlock) (void);
@property(nonatomic, copy) void(^buttonBlock) (NSInteger tag);
-(void)updata:(UserInfoModel *)model;
- (void)updateCollect;
-(void)updateMsg;
-(void)updateFoot;

@end

NS_ASSUME_NONNULL_END
