//
//  UIImage+DDFirstImage.h
//  DDNewThirdDemo
//
//  Created by lll on 2022/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DDFirstImage)

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

+ (UIImage *)thumbnailImageForLocalVideo:(NSString *) videoURL;

@end

NS_ASSUME_NONNULL_END
