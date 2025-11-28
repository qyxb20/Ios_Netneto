//
//  DDBannerModel.h
//  duck
//
//  Created by lll on 2022/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

enum DDBannerType {
    DDBannerTypeLocalImage = 0,//本地图片
    DDBannerTypeNetImage = 1,//网络图片
    DDBannerTypeLocalVideo = 2,//本地视频
    DDBannerTypeNetVideo = 3,//网络视频
};

@interface DDBannerModel : NSObject

@property (nonatomic, assign) enum DDBannerType type;

// DDBannerTypeLocalVideo 例如:xx.mp4  [[NSBundle mainBundle] pathForResource:@"xx" ofType:@"mp4"];
//其余正常传入
@property (nonatomic, copy) NSString *filePath;


@end

NS_ASSUME_NONNULL_END
