//
//  NetWorkRequest.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/19.
//

#import "NetWorkRequest.h"
NSString *kHttpErrorReason = @"httpError";
NSString * const RequestServerDomain = @"https://api.netneto.jp";
NSString * const RequestH5Domain = @"https://api.netneto.jp";
//NSString * const RequestServerDomain = @"http://133.242.182.135:8086";
//NSString * const RequestH5Domain = @"http://133.242.182.135:8086";
//NSString * const RequestServerDomain = @"http://133.242.182.135";
//NSString * const RequestH5Domain = @"http://133.242.182.135";
//NSString * const RequestServerDomain = @"http://192.168.1.117:8086";
//NSString * const RequestH5Domain = @"http://192.168.1.117:8086";


@implementation NetWorkRequest
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
        needEncryption:(BOOL)needEncryption
      needExtraProcess:(BOOL)needExtraProcess
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    
    NSDictionary *httpHeader;
    httpHeader = [self builderHttpHeader];
//    if ([urlString isEqual:RequestURL(@"/p/agora/addRoomMsg")]) {
//        httpHeader = @{};
//    }
    BOOL encrypt = NO;
    if ((httpMethod == HttpMethodPOST) && needEncryption) {
        encrypt = YES;
    }
  
    [self requestLogPrint:urlString httpHeader:httpHeader parameters:parameters];
    [self httpRequestWithUrl:urlString
                     httpMethod:httpMethod
                     httpHeader:httpHeader
                       httpBody:parameters
                       progress:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [self responseConfiguration:responseObject encrypt:encrypt];
        [self responseLogPrint:task.response.URL.absoluteString responseData:responseObject];
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [self requestFailureWithMsg:nil code:@"-1" block:failure];
                                return;
           }
                            
          if (needExtraProcess) {
              if (success) {
                     success(responseObject);
               }
          }else {
                   NSDictionary *dic = (NSDictionary *)responseObject;
//                   int code = [dic[@"code"] intValue];
              if ([dic[@"code"] isEqual:@"00000"]) {
                      
                           if (success) {
                                            success(dic[@"data"]);
                                        }
                        }
                   else if ([dic[@"code"] isEqual:@"A00004"]) {
                     //登录失效
//                       if ([urlString containsString:@"/p/user/collection/count"]) {
//                           [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
//                       }else{
                       if (account.isLogin) {
                         
                           [account Kitout];
                       }
                       else{
                           [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
                       }
                           
//                       }
//                       [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
                 }
                   else {
//                       success(dic);
                       [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
                             
                                    }
                             
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            [self errorLogPrint:error];
                            
                            NSError *bitchError = [self errorInfoHandle:error];
                            if (bitchError.code == 700) {

                            }else {
                                if (failure) {
                                    failure(bitchError);
                                }
                            }
                        }];
}
+ (void)getWithFormUrl:(NSString *)urlString parameters:(id)parameters success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:30];
   
    request.HTTPMethod = @"GET";
    
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    request.allHTTPHeaderFields = @{
        @"Authorization":account.accessToken
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if ([dic[@"code"] isEqual:@"00000"]) {
            success(dic);
        }
        else if ([dic[@"code"] isEqual:@"A00004"]) {
            //登录失效
            if (account.isLogin) {
               
                [account Kitout];
            }
            else{
                [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
            }
//            [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
        }
        else{
            [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
        }
    }];
  
}
+ (void)postWithFormUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:30];
   
    request.HTTPMethod = @"POST";
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];

    [request setValue:account.accessToken forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];


    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if ([dic[@"code"] isEqual:@"00000"]) {
            success(dic);
        }
        else if ([dic[@"code"] isEqual:@"A00004"]) {
            //登录失效
            if (account.isLogin) {
              
                [account Kitout];
            }
            else{
                [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
            }
//            [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
        }
        else{
            [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"] block:failure];
        }
    }];
}

+ (void)putWithFormUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:30];
   
    request.HTTPMethod = @"PUT";
    NSError *error;

        request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
//    }
    [request setValue:account.accessToken forHTTPHeaderField:@"Authorization"];
    
 

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if ([dic[@"code"] isEqual:@"00000"]) {
            success(dic);
        }
        else if ([dic[@"code"] isEqual:@"A00004"]) {
            //登录失效
            if (account.isLogin) {
               
                [account Kitout];
            }
            else{
                [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
            }
//            [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
        }
        else{
            [self requestFailureWithMsg:dic[@"msg"] code:dic[@"code"]  block:failure];
        }
    }];
}
+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
      needExtraProcess:(BOOL)needExtraProcess
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:urlString httpMethod:httpMethod parameters:parameters needEncryption:NO needExtraProcess:needExtraProcess success:success failure:failure];
}

+ (void)requestWithUrl:(NSString *)urlString
            httpMethod:(HttpMethod)httpMethod
            parameters:(id _Nullable)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:urlString httpMethod:httpMethod parameters:parameters needExtraProcess:NO success:success failure:failure];
}
+ (void)getWithUrl:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:urlString httpMethod:HttpMethodGET parameters:parameters success:success failure:failure];
}
+ (void)deleteWithUrl:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:urlString httpMethod:HttpMethodDELETE parameters:parameters success:success failure:failure];
}
+ (void)putWithUrl:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:urlString httpMethod:HttpMethodPUT parameters:parameters success:success failure:failure];
}
+ (void)putWithJson:(NSString *)urlString
        parameters:(id _Nullable)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    NSURL *url = [NSURL URLWithString:urlString];
     
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     
    // 设置HTTP方法为PUT
    request.HTTPMethod = @"PUT";
     
    // 设置请求头为application/json
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:account.accessToken  forHTTPHeaderField:@"Authorization"];
    
    // 创建JSON数据
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
     
    // 处理错误
    if (error) {
        NSLog(@"Error creating JSON: %@", error);
        return;
    }
     
    // 设置请求体
    request.HTTPBody = jsonData;
     
    // 创建并发送异步请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 请求成功，处理响应数据
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            success(responseDictionary);
            if (!error) {
                NSLog(@"Response: %@", responseDictionary);
            } else {
                NSLog(@"Error parsing response: %@", error);
            }
        } else {
            // 请求出错
            NSLog(@"Error: %@", error);
        }
    }];
     
    [task resume];
}

+ (void)postWithJson:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure {
    NSURL *url = [NSURL URLWithString:urlString];
     
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     
    // 设置HTTP方法为POST
    request.HTTPMethod = @"POST";
     
    // 设置请求头为application/json
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (account.accessToken) {
        [request setValue:account.accessToken forHTTPHeaderField:@"Authorization"];
    }
    
    // 创建JSON数据
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
     
    // 处理错误
    if (error) {
        NSLog(@"Error creating JSON: %@", error);
        if (failure) {
            failure(error);
        }
        return;
    }
     
    // 设置请求体
    request.HTTPBody = jsonData;
     
    // 创建并发送异步请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 请求成功，处理响应数据
            NSError *parseError;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (!parseError) {
                // 检查响应中的 code 字段
                if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
                    NSString *code = responseDictionary[@"code"];
                    if ([code isEqualToString:@"00000"]) {
                        if (success) {
                            success(responseDictionary[@"data"] ?: responseDictionary);
                        }
                    } else {
                        NSString *msg = responseDictionary[@"msg"] ?: @"请求失败";
                        NSError *bitchError = [NSError errorWithDomain:@"NetWorkRequest" code:[code integerValue] userInfo:@{@"httpError": msg, @"code": code}];
                        if (failure) {
                            failure(bitchError);
                        }
                    }
                } else {
                    if (success) {
                        success(responseDictionary);
                    }
                }
            } else {
                NSLog(@"Error parsing response: %@", parseError);
                if (failure) {
                    failure(parseError);
                }
            }
        } else {
            // 请求出错
            NSLog(@"Error: %@", error);
            if (failure) {
                failure(error);
            }
        }
    }];
     
    [task resume];
}

+ (void)postWithUrl:(NSString *)urlString
         parameters:(id _Nullable)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:urlString httpMethod:HttpMethodPOST parameters:parameters success:success failure:failure];
}

+ (void)httpRequestWithUrl:(NSString *)urlString
                httpMethod:(HttpMethod)httpMethod
                httpHeader:(NSDictionary *)httpHeader
                  httpBody:(id _Nullable)httpBody
                  progress:(void (^)(NSProgress *))progress
                   success:(RequestSuccessBlock)success
                   failure:(RequestFailureBlock)failure {
    switch(httpMethod){
        case HttpMethodGET:
            [NetWorkCommon getWithUrl:urlString httpHeader:httpHeader httpBody:httpBody progress:progress success:success failure:failure];
            break;
        case HttpMethodPOST:
            [NetWorkCommon postWithUrl:urlString httpHeader:httpHeader httpBody:httpBody progress:progress success:success failure:failure];
            break;
        case HttpMethodDELETE:
            [NetWorkCommon deleteWithUrl:urlString httpHeader:httpHeader httpBody:httpBody progress:progress success:success failure:failure];
            break;
        case HttpMethodPUT:
            [NetWorkCommon putWithUrl:urlString httpHeader:httpHeader httpBody:httpBody progress:progress success:success failure:failure];
            break;
        default:
            break;
    }
}

+ (id)responseConfiguration:(id)responseObject encrypt:(BOOL)encrypt {
    if (!responseObject) return nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return responseObject;
    }else {
        if (encrypt) {
            return [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }else {
            return [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
    }
}

#pragma mark - 请求头、请求体的参数处理、加密及签名
/**
 * 生成HttpHeader参数
 * @return HttpHeader字典
 */
+ (NSDictionary *)builderHttpHeader {
    NSMutableDictionary *sysInfoDic = [[NSMutableDictionary alloc] init];
    [sysInfoDic setValue:account.accessToken forKey:@"Authorization"];
    return sysInfoDic;
}

/**
 * 生成HttpBody参数
 */
+ (NSDictionary *)parametersConfig:(NSDictionary *)parameters needEncryption:(BOOL)encryption {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];

   
//    param[@"uid"] = account.userId.length > 0 ? account.userId : @"-999";
//    param[@"token"] = account.accessToken.length > 0 ? account.accessToken : @"-999";
    return param;
}

#pragma mark - 取消网络请求
/**
 *  取消所有的网络请求
 */
+ (void)cancelAllRequest{
    [NetWorkCommon cancelAllRequest];
}

+ (void)cancelHttpRequestWithHttpMethod:(HttpMethod)httpMethod requestUrlString:(NSString *)urlString {
    NSString *requestType = [NSString string];
    switch (httpMethod) {
        case HttpMethodGET:
            requestType = @"GET";
            break;
        case HttpMethodPOST:
            requestType = @"POST";
            break;
    }
    [NetWorkCommon cancelHttpRequestWithHttpMethod:requestType requestUrlString:urlString];
}


+ (void)requestLogPrint:(NSString *)urlString httpHeader:(id _Nullable)httpHeader parameters:(NSDictionary *)parameters {
    NSLog(@"\ncurrent Thread: %@  \nRequest URL: %@  \nHttp Header: %@  \nparameters: %@", [NSThread currentThread], urlString, httpHeader, parameters);
}

+ (void)responseLogPrint:(NSString *)urlString responseData:(NSDictionary *)responseData {
    NSLog(@"\ncurrent Thread: %@  \nResponse URL: %@  \nResponse Data: %@", [NSThread currentThread], urlString, responseData);
}

+ (void)errorLogPrint:(NSError *)error {
    NSLog(@"\ncurrent Thread: %@  \nURL: %@  \nerror code: %zd  \ndescription: %@", [NSThread currentThread], error.userInfo[NSURLErrorFailingURLErrorKey], error.code, error.localizedDescription);
}

#pragma mark - 错误处理
+ (NSError *)errorInfoHandle:(NSError *)error {
    NSDictionary *userInfo = nil;
    NSInteger code = error.code;
    if (error.code == -1012 || error.code == 3840) {
        userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
    }
    if (error.code == -1011) {
        NSHTTPURLResponse * response = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        NSInteger codeNumber = response.statusCode;
        if (codeNumber == 404){
            
            userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
        }else if (codeNumber == 405){
            userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
        }else if (codeNumber == 401){
            userInfo = @{kHttpErrorReason : @"Authorization failed"};

        }else{
            userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
        }
        code = codeNumber;
    }
    if (error.code == -1009) {
        userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
    }
    if (error.code == -1004) {
        userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
    }
    if (error.code == -1001) {
        userInfo = @{kHttpErrorReason : @"ネットワークエラーが発生しました。ネットワーク接続を確認してください。"};
    }
    if (userInfo == nil) {
        userInfo = @{kHttpErrorReason : error.localizedDescription};
    }
    NSError *bitchError = [NSError errorWithDomain:@"Netneto" code:code userInfo:userInfo];
    return bitchError;
}

/**
 * 请求失败的信息转换为提示error
 */
+ (void)requestFailureWithMsg:(NSString *)msg code:(NSString *)code block:(void (^)(NSError *error))failure {
    if ([msg isKindOfClass:[NSNull class]]) {
        msg = nil;
    }
    NSError *error = [NSError errorWithDomain:@"seallive" code:[code integerValue] userInfo:@{kHttpErrorReason : msg ?: @"c",@"code":code}];
    if (![msg isEqual:@"Unauthorized"]) {
        if (failure) {
            failure(error);
        }
    }
    
}
@end
