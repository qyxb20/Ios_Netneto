//
//  GoodsSureOrderView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/10/9.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSureOrderView : BaseView
+ (instancetype)initViewNIB;
-(void)updataWithDic:(NSDictionary *)dataDic;
@property (nonatomic, copy) void (^peiClickBlock) (void);
@property (nonatomic, copy) void (^tuiClickBlock) (void);
@end

NS_ASSUME_NONNULL_END
