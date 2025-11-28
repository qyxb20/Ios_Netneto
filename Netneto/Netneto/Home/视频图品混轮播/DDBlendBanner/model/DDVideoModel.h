//
//  DDVideoModel.h
//  duck
//
//  Created by lll on 2022/1/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDVideoModel : NSObject

@property (nonatomic, strong) UIImage *firstFrameImage;//第一帧图片

@property (nonatomic, assign) double videoDuration;//视频长度

@property (nonatomic, copy) NSString *videoPath;//视图路径

@end

NS_ASSUME_NONNULL_END
