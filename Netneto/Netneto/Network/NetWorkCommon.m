//
//  NetWorkCommon.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/19.
//

#import "NetWorkCommon.h"
static NSTimeInterval timeout = 60.0f;
static AFHTTPSessionManager *_manager;

@implementation NetWorkCommon
+ (AFHTTPSessionManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager =  [self managerWithBaseURL:nil sessionConfiguration:NO];
    });
    
    return _manager;
}

+ (AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL
                        sessionConfiguration:(BOOL)isconfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = nil;
    
    NSURL *url;
    if (baseURL) {
        url = [NSURL URLWithString:baseURL];
    }
    
    if (isconfiguration) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    } else {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.operationQueue.maxConcurrentOperationCount = 4;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = timeout;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}


+ (NSURLSessionDataTask *_Nullable)getWithUrl:(NSString *_Nonnull)urlString
                                   httpHeader:(NSDictionary * _Nullable)httpHeader
                                     httpBody:(id _Nullable)httpBody
                                     progress:(ProgressBlock _Nullable)progress
                                      success:(RequestSuccessBlock _Nullable)success
                                      failure:(RequestFailureBlock _Nullable)failure {
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
//    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSURLSessionDataTask *dataTask  = [manager GET:urlString parameters:httpBody headers:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
   
    return dataTask;
}

+ (NSURLSessionDataTask *_Nullable)postWithUrl:(NSString *_Nonnull)urlString
                                    httpHeader:(NSDictionary * _Nullable)httpHeader
                                      httpBody:(NSDictionary *_Nullable)httpBody
                                      progress:(ProgressBlock _Nullable)progress
                                       success:(RequestSuccessBlock _Nullable)success
                                       failure:(RequestFailureBlock _Nullable)failure {
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
    
    NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:httpBody headers:nil progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            success(task, responseObject);
        }
    } failure:failure];
    return dataTask;
}
+ (NSURLSessionDataTask *)deleteWithUrl:(NSString *)urlString httpHeader:(NSDictionary *)httpHeader httpBody:(NSDictionary *)httpBody progress:(ProgressBlock)progress success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure{
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
  
    NSURLSessionDataTask *dataTask = [manager DELETE:urlString parameters:httpBody headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:failure];
    
    return dataTask;
}
+ (NSURLSessionDataTask *)putWithUrl:(NSString *)urlString httpHeader:(NSDictionary *)httpHeader httpBody:(NSDictionary *)httpBody progress:(ProgressBlock)progress success:(RequestSuccessBlock)success failure:(RequestFailureBlock)failure{
    AFHTTPSessionManager *manager = [self shareManager];
    [self configRequestHttpHeader:httpHeader];
    
  
    NSURLSessionDataTask *dataTask = [manager PUT:urlString parameters:httpBody headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:failure];
    
    return dataTask;
}
+ (void)configRequestHttpHeader:(NSDictionary *)httpHeader {
    if ([httpHeader isKindOfClass:[NSDictionary class]]) {
        [httpHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [[self shareManager].requestSerializer setValue:obj forHTTPHeaderField:key];
            
        }];
    }
}

+ (id)responseConfiguration:(id)responseObject {
    if (!responseObject) return nil;
        
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return responseObject;
    }else{
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        return dict;
    }
}

+ (void)cancelAllRequest {
    [[self shareManager].operationQueue cancelAllOperations];
}

+ (void)cancelHttpRequestWithHttpMethod:(NSString *)httpMethod requestUrlString:(NSString *)urlString {
    [self cancelSameRequestWithMethod:httpMethod urlString:urlString httpBody:nil];
}

+ (void)cancelSameRequestWithMethod:(NSString *)httpMethod urlString:(NSString *)urlString httpBody:(NSDictionary *)httpBody {
 
    NSURLRequest *designatedRequest = [[self shareManager].requestSerializer requestWithMethod:httpMethod URLString:urlString parameters:httpBody error:nil];
    for (NSOperation *operation in [self shareManager].operationQueue.operations) {
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            NSURLRequest *currentRequest = [(NSURLSessionTask *)operation currentRequest];
        
            if ([httpMethod isEqualToString:currentRequest.HTTPMethod] && [designatedRequest.URL.path isEqualToString:currentRequest.URL.path]) {
               
                if (httpBody && [designatedRequest.HTTPBody isEqualToData:currentRequest.HTTPBody]) {
                    [operation cancel];
                }else {
                    [operation cancel];
                }
            }
        }
    }
}

@end
