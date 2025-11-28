//
//  UIImage+tool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (tool)
#pragma mark - color -> Image
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
