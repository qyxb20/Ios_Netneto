//
//  UploadElement.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/29.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^UploadProgressBlock)(CGFloat percent);
typedef void (^UploadSuccessBlock)(int code, NSString *url);
typedef void (^UploadProgressStrBlock)(NSString *percent);
@interface UploadElement : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate>
#pragma mark - 上传图片
+ (void)UploadElementWithImage:(UIImage *)img name:(NSString *)name progress:(UploadProgressBlock)upProgress success:(void (^)(id responseObject))success;
+ (void)UploadElementWithImageArr:(NSArray *)img name:(NSString *)name progress:(UploadProgressStrBlock)upProgress success:(void (^)(id responseObject))success;
+(void)imageShibieClass:(UIImage *)img name:(NSString *)name progress:(UploadProgressBlock)upProgress success:(void (^)(id responseObject))success;
#pragma mark - 上传文件
+ (void)UploadElementWithPdf:(NSData *)imageData name:(NSString *)name progress:(UploadProgressStrBlock)upProgressm success:(void (^)(id responseObject))success;
@end

NS_ASSUME_NONNULL_END
