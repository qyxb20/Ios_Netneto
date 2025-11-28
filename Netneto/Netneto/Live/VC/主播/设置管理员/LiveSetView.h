//
//  LiveSetView.h
//  Netneto
//
//  Created by apple on 2024/10/14.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveSetView : BaseView
+ (instancetype)initViewNIB ;
-(void)updateJinStr:(NSString *)jin;
-(void)updateKitStr:(NSString *)kit;
@property(nonatomic, copy) void(^jinTimeClickBlock) (void);
@property(nonatomic, copy) void(^kitTimeClickBlock) (void);
@property(nonatomic, copy) void(^sureClickBlock) (NSString *timeStr,NSString *choseWho);
-(void)show;
@end

NS_ASSUME_NONNULL_END
