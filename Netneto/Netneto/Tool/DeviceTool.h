//
//  DeviceTool.h
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define HeightStatusBar [DeviceTool statusBarHeight]
#define HeightNavBar [DeviceTool navigationBarHeight]
#define HeightTabbarExtra [DeviceTool tabbarExtraHeight]
#define HeightTabbar [DeviceTool tabbarHeight]

@interface DeviceTool : NSObject
+ (CGFloat)statusBarHeight;
+ (CGFloat)navigationBarHeight;
+ (CGFloat)tabbarExtraHeight;
+ (CGFloat)tabbarHeight;
+ (NSString *)appVersion;
@end

NS_ASSUME_NONNULL_END
