//
//  DDVideoModel.m
//  duck
//
//  Created by lll on 2022/1/14.
//

#import "DDVideoModel.h"

@implementation DDVideoModel

- (void)setFirstFrameImage:(UIImage *)firstFrameImage
{
    _firstFrameImage = firstFrameImage;
    
    if (!_firstFrameImage) {
        // TODO: 替换自己的占位图
        _firstFrameImage = [UIImage imageNamed:@""];
    }
}

- (void)setVideoDuration:(double)videoDuration
{
    _videoDuration = videoDuration;
    
    if (_videoDuration <= 0) {
        // TODO: 替换自己的默认滚动时间
        _videoDuration = 5;
    }
    // TODO: 视频时间过长 置为最大播放时间
//    if (_videoDuration >= 15) {
//        _videoDuration = 15;
//    }
}

@end
