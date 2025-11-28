//
//  bankNameSearchView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface bankNameSearchView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, copy) void (^sureBlock) (NSDictionary *dic);
-(void)getBankCustomList;
@end

NS_ASSUME_NONNULL_END
