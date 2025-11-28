//
//  bankZhiNameView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/10/10.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface bankZhiNameView : BaseView
-(void)updateWithDatadic:(NSDictionary *)dic;
+ (instancetype)initViewNIB;
@property(nonatomic, copy) void (^sureBlock) (NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
