//
//  DDBlendBannerView.h
//  duck
//
//  Created by lll on 2022/1/14.
//

#import <UIKit/UIKit.h>
#import "DDBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 混合banner包含图片视频
@interface DDBlendBannerView : UIView

@property (nonatomic, strong) NSArray<DDBannerModel *> *showArray;

@end

NS_ASSUME_NONNULL_END
