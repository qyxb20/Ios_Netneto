//
//  NetWorkCommon.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^RequestSuccessBlock)(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject);
typedef void(^RequestFailureBlock)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error);
typedef void(^ProgressBlock)(NSProgress * _Nonnull progress);

@interface NetWorkCommon : NSObject
+ (AFHTTPSessionManager *_Nonnull)shareManager;

+ (NSURLSessionDataTask *_Nullable)getWithUrl:(NSString *_Nonnull)urlString
                                   httpHeader:(NSDictionary * _Nullable)httpHeader
                                     httpBody:(id _Nullable)httpBody
                                     progress:(ProgressBlock _Nullable)progress
                                      success:(RequestSuccessBlock _Nullable)success
                                      failure:(RequestFailureBlock _Nullable)failure;


+ (NSURLSessionDataTask *_Nullable)postWithUrl:(NSString *_Nonnull)urlString
                                    httpHeader:(NSDictionary * _Nullable)httpHeader
                                      httpBody:(NSDictionary *_Nullable)httpBody
                                      progress:(ProgressBlock _Nullable)progress
                                       success:(RequestSuccessBlock _Nullable)success
                                       failure:(RequestFailureBlock _Nullable)failure;
+ (NSURLSessionDataTask *_Nullable)deleteWithUrl:(NSString *_Nonnull)urlString
                                    httpHeader:(NSDictionary * _Nullable)httpHeader
                                      httpBody:(NSDictionary *_Nullable)httpBody
                                      progress:(ProgressBlock _Nullable)progress
                                       success:(RequestSuccessBlock _Nullable)success
                                       failure:(RequestFailureBlock _Nullable)failure;
+ (NSURLSessionDataTask *_Nullable)putWithUrl:(NSString *_Nonnull)urlString
                                    httpHeader:(NSDictionary * _Nullable)httpHeader
                                      httpBody:(NSDictionary *_Nullable)httpBody
                                      progress:(ProgressBlock _Nullable)progress
                                       success:(RequestSuccessBlock _Nullable)success
                                       failure:(RequestFailureBlock _Nullable)failure;

+ (void)cancelAllRequest;

+ (void)cancelHttpRequestWithHttpMethod:(NSString *_Nonnull)httpMethod requestUrlString:(NSString *_Nonnull)urlString;

@end

NS_ASSUME_NONNULL_END
