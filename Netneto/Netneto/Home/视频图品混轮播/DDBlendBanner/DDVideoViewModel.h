//
//  DDVideoViewModel.h
//  duck
//
//  Created by lll on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import "DDVideoModel.h"
#import <UIKit/UIKit.h>
#import "DDBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DDVideoInfo)(DDVideoModel *ffModel);

/// 单例 储存当前访问的视频的首帧图片 以及视频长度
@interface DDVideoViewModel : NSObject

+ (DDVideoViewModel *)shareVideoModel;

/// 获取当前视频路径的信息
/// @param bannerModel 实体类
/// @param videoInfo 视频的首帧 视频的长度
- (void)getVideoInfo:(DDBannerModel *) bannerModel with:(DDVideoInfo) videoInfo;

@end

NS_ASSUME_NONNULL_END
