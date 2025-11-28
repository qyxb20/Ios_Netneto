//
//  HomeHeaderView.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>
#import "HomeOneCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeHeaderView : BaseView
@property(nonatomic, strong)SDCycleScrollView *banner;
@property (nonatomic, copy) void (^searchClickBlock) (void);
@property (nonatomic, copy) void (^moreClickBlock) (NSString *idStr);
@property (nonatomic, copy) void (^notifiClickBlock) (void);
@property (nonatomic, copy) void (^btnItemClickBlock) (NSString *titleStr);
@property (nonatomic, copy) void (^cellItemClickBlock) (NSDictionary *dic);
@property (nonatomic, copy) void (^bannerItemClickBlock) (NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
