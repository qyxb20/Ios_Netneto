//
//  UploadElement.m
//  Netneto
//
//  Created by SHOKEN ITO on 2024/9/29.
//

#import "UploadElement.h"

@implementation UploadElement



#pragma mark - 上传图片
+ (void)UploadElementWithImage:(UIImage *)img name:(NSString *)name progress:(UploadProgressBlock)upProgress success:(void (^)(id responseObject))success{
    NSURL *url = [NSURL URLWithString:RequestURL(@"/p/file/upload/element")];
     
    // 确定图片的NSData表示
    NSData *imageData = UIImageJPEGRepresentation(img, 1); // 0.5是压缩质量，可以根据需要调整

    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
     
    // 设置multipart/form-data的头部
    NSString *boundary = @"----WebkitGormBoundaryTRAWVBN7QpyLT30J";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    request.allHTTPHeaderFields = @{ @"Content-Type": contentType };
    [request setValue:account.accessToken  forHTTPHeaderField:@"Authorization"];
    
    // 创建数据流来拼接表单数据
    NSMutableData *body = [NSMutableData data];
     
    // 添加图片数据
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"phone.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     
    // 结束数据
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
    // 设置请求体
    request.HTTPBody = body;
     
    // 创建并执行请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            success(responseDictionary);
            
        }
    }];
    [task resume];
}


+ (void)UploadElementWithPdf:(NSData *)imageData name:(NSString *)name progress:(UploadProgressStrBlock)upProgressm success:(void (^)(id responseObject))success{
    NSURL *url = [NSURL URLWithString:RequestURL(@"/p/file/upload/element")];
     
    // 确定图片的NSData表示
//    NSData *imageData = UIImageJPEGRepresentation(img, 1); // 0.5是压缩质量，可以根据需要调整

    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
     
    // 设置multipart/form-data的头部
    NSString *boundary = @"----WebkitGormBoundaryTRAWVBN7QpyLT30J";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    request.allHTTPHeaderFields = @{ @"Content-Type": contentType };
    [request setValue:account.accessToken  forHTTPHeaderField:@"Authorization"];
    
    // 创建数据流来拼接表单数据
    NSMutableData *body = [NSMutableData data];
     
    // 添加图片数据
    NSString *sr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",name];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[sr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/pdf\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     
    // 结束数据
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
    // 设置请求体
    request.HTTPBody = body;
    ;
     
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:RequestURL(@"/p/file/upload/element") parameters:@{} headers:@{@"Authorization":account.accessToken} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        [formData appendPartWithFileData:imageData name:@"file" fileName:name mimeType:@"image/jpg/png/jpeg"];
     
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度：%@********%@",uploadProgress.localizedDescription,uploadProgress.localizedAdditionalDescription);
        upProgressm([uploadProgress.localizedDescription substringToIndex:uploadProgress.localizedDescription.length - 2]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //        NSError * _Nonnull error;
//                    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
                    success(responseObject);
                    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
           
          
//    // 创建并执行请求
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//            success(responseDictionary);
//            
//        }
//    }];
//    [task resume];
}
+ (void)UploadElementWithImageArr:(NSArray *)img name:(NSString *)name progress:(UploadProgressStrBlock)upProgressm success:(void (^)(id responseObject))success{
    NSURL *url = [NSURL URLWithString:RequestURL(@"/p/file/upload/element")];
     
    // 确定图片的NSData表示
//    NSData *imageData = UIImageJPEGRepresentation(img, 1); // 0.5是压缩质量，可以根据需要调整

    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
     
    // 设置multipart/form-data的头部
    NSString *boundary = @"----WebkitGormBoundaryTRAWVBN7QpyLT30J";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    request.allHTTPHeaderFields = @{ @"Content-Type": contentType };
    [request setValue:account.accessToken  forHTTPHeaderField:@"Authorization"];
    
    // 创建数据流来拼接表单数据
    NSMutableData *body = [NSMutableData data];
     
    // 添加图片数据
    for (int i = 0; i < [img count]; i++) {
        NSData *imageData = img[i];

               NSString *imageStr = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
               NSString *keyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n"];
               NSString *typeStr = [NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"];
               
               [body appendData:[imageStr dataUsingEncoding:NSUTF8StringEncoding]];
               [body appendData:[keyStr dataUsingEncoding:NSUTF8StringEncoding]];
               [body appendData:[typeStr dataUsingEncoding:NSUTF8StringEncoding]];
               [body appendData:imageData];
    }
    
    
      
    // 结束数据
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
       [body appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
       
    // 设置请求体
    request.HTTPBody = body;
     
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:RequestURL(@"/p/file/upload/element") parameters:@{} headers:@{@"Authorization":account.accessToken} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        for (int i = 0; i < [img count]; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            NSData *imageData = img[i];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度：%@********%@",uploadProgress.localizedDescription,uploadProgress.localizedAdditionalDescription);
        upProgressm([uploadProgress.localizedDescription substringToIndex:uploadProgress.localizedDescription.length - 2]);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {


                    success(responseObject);
                    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
           

}

+(void)imageShibieClass:(UIImage *)img name:(NSString *)name progress:(UploadProgressBlock)upProgress success:(void (^)(id responseObject))success{
    NSURL *url = [NSURL URLWithString:RequestURL(@"/p/irt/productCategory")];
     
    // 确定图片的NSData表示
    NSData *imageData = UIImageJPEGRepresentation(img, 1); // 0.5是压缩质量，可以根据需要调整
     
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
     
    // 设置multipart/form-data的头部
    NSString *boundary = @"----WebkitGormBoundaryTRAWVBN7QpyLT30J";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    request.allHTTPHeaderFields = @{ @"Content-Type": contentType };
    [request setValue:account.accessToken  forHTTPHeaderField:@"Authorization"];
    
    // 创建数据流来拼接表单数据
    NSMutableData *body = [NSMutableData data];
     
    // 添加图片数据
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"phone.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     
    // 结束数据
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
    // 设置请求体
    request.HTTPBody = body;
     
    // 创建并执行请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            success(responseDictionary);
            
        }
    }];
    [task resume];
}
+(NSData *)getDataWithString:(NSString *)string{
      
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
      
    return data;
      
}
@end
