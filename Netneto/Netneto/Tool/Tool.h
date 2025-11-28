//
//  Tool.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject
#pragma mark - 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;
#pragma mark -根据宽度求高度
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
#pragma mark -根据高度求宽度
+ (CGFloat)getLabelWidthWithText:(NSString *)text height:(CGFloat)height font: (CGFloat)font;
#pragma mark - 计算html字符串高度
+(CGFloat)getAttHtmHeight:(NSString *)str width:(CGFloat)wid font:(CGFloat)font;
#pragma mark - 获取时间戳
+ (NSNumber *)getCurrentTimeNumber;
#pragma mark - 时间转时间戳
+(NSInteger)getTimeStrWithString:(NSString*)str;
#pragma mark - 计算时间差 单位为秒
+(NSInteger)getCompareTime:(NSString *)startTime endTime:(NSString *)endTime;
#pragma mark - 获取时间戳
+(NSString *)getCurtenTimeStrWithString;
#pragma mark - 字典转json字符串
+ (NSString *)DictionaryToJsonStr:(NSDictionary *)dic;
#pragma mark - 压缩图片
+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
#pragma mark -view转成image
+ (UIImage*) imageWithUIView:(UIView*) view;
#pragma mark -获取当前季节
+(NSString *)getCurrentSeason;

+(NSString *)getCurtenTimeStrWithStringYYYYMMDD;
+(NSString *)getCurtenSecondStrWithString;
+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength;
@end

NS_ASSUME_NONNULL_END
