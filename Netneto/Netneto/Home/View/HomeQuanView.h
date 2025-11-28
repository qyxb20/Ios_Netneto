//
//  HomeQuanView.h
//  Netneto
//
//  Created by apple on 2025/2/5.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeQuanView : BaseView
+ (instancetype)initViewNIB;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy) void (^loginClickBlock) (void);

@end

NS_ASSUME_NONNULL_END
