//
//  DDVideoViewModel.m
//  duck
//
//  Created by lll on 2022/1/14.
//

#import "DDVideoViewModel.h"
#import "UIImage+DDFirstImage.h"
#import <AVFoundation/AVFoundation.h>

@interface DDVideoViewModel()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DDVideoModel *> *videoDictionary;
@end

@implementation DDVideoViewModel

+ (DDVideoViewModel *)shareVideoModel
{
    static DDVideoViewModel *videoModel = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        videoModel = [[DDVideoViewModel alloc] init];
    });
    
    return videoModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)getVideoInfo:(DDBannerModel *)bannerModel with:(DDVideoInfo)videoInfo
{
    NSString *videoUrl = bannerModel.filePath;
    //当内存中有当前视频路径解析数据
    if (self.videoDictionary[videoUrl]) {
        DDVideoModel *model = self.videoDictionary[videoUrl];
        videoInfo(model);
        return;
    }
    //当前内存中没有当前视频路径的数据
    __weak typeof(self) weakSelf = self;
    __block DDVideoModel *dvModel = [[DDVideoModel alloc] init];
    dvModel.videoPath = videoUrl;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    //取得第一帧图片
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        UIImage *image;
        if (bannerModel.type == DDBannerTypeLocalVideo) {
            dvModel.videoPath = bannerModel.filePath;
            image = [UIImage thumbnailImageForLocalVideo:bannerModel.filePath];
        }else{
            image = [UIImage thumbnailImageForVideo:[NSURL URLWithString:bannerModel.filePath] atTime:0];
        }
        dvModel.firstFrameImage = image;
        dispatch_group_leave(group);
    });

    //取得视频时间
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        double videoSecond = 0;
        if (bannerModel.type == DDBannerTypeLocalVideo) {
            AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:bannerModel.filePath]];
            CMTime time = [asset duration];
            videoSecond = time.value/time.timescale;
        }else{
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:bannerModel.filePath] options:nil];
            videoSecond = asset.duration.value/asset.duration.timescale;
        }
        
        dvModel.videoDuration = videoSecond;
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.videoDictionary setObject:dvModel forKey:videoUrl];
            videoInfo(dvModel);
        });
    });
    
}

@end
