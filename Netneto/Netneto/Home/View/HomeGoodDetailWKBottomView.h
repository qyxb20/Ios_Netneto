//
//  HomeGoodDetailWKBottomView.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeGoodDetailWKBottomView : BaseView
+ (instancetype)initViewNIB;
-(void)updateNumber;
@property (nonatomic, copy) void (^pushCarClickBlock) (void);
@property (nonatomic, copy) void (^joinCarClickBlock) (void);
@property (nonatomic, copy) void (^buyClickBlock) (void);


@end

NS_ASSUME_NONNULL_END
