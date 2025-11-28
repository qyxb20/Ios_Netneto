//
//  NetWorkRequest.h
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HttpMethod) {
    HttpMethodGET,
    HttpMethodPOST,
    HttpMethodDELETE,
    HttpMethodPUT,
};
#define RequestURL(str) [NSString stringWithFormat:@"%@%@",RequestServerDomain,str]
extern BOOL AppHasNetwork;
extern NSString *kHttpErrorReason;
extern NSString * const RequestServerDomain;
extern NSString * const RequestH5Domain;

@interface NetWorkRequest : NSObject

+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
      needExtraProcess:(BOOL)needExtraProcess
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
      needExtraProcess:(BOOL)needExtraProcess
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
+ (void)getWithUrl:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
+ (void)postWithUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
+ (void)deleteWithUrl:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
+ (void)putWithUrl:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure;
+ (void)postWithFormUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
+ (void)putWithFormUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
+ (void)putWithJson:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
+ (void)postWithJson:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
+ (void)getWithFormUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

+ (void)cancelAllRequest;

+ (void)cancelHttpRequestWithHttpMethod:(HttpMethod)httpMethod requestUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
