//
//  HttpTool.m
//  Text1234
//
//  Created by linmingzhi on 15/4/29.
//  Copyright (c) 2015年 linmingzhi. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool


+(NSURLSessionDataTask *)get:(NSString *)urlstr
                      params:(NSDictionary *)tmpParams
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure
                       Array:(NSMutableArray *)array
                           JudgeURL:(BOOL)sameURL
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tmpParams];
    
    //判断是否同个接口，是就中断重新加载
    if(sameURL == YES){
        for (NSURLSessionDataTask *task in array) {
            if ([[task.currentRequest.URL absoluteString] isEqualToString:urlstr]) {
                [task cancel];
                [array removeObject:task];
                break;
            }
        }
    }
    
    NSMutableString *mutableUrl = [urlstr mutableCopy];
    NSArray *keys = [params allKeys];
    for (int i = 0; i < keys.count;i++) {
        if (i == 0) {
            [mutableUrl appendFormat:@"?%@=%@",keys[i],params[keys[i]]];
        }else{
            [mutableUrl appendFormat:@"&%@=%@",keys[i],params[keys[i]]];
        }
        
    }
    NSLog(@"Get:%@,%@",mutableUrl,params);
    NSString *utf8Str = [mutableUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:utf8Str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPBody:data];
    [request setHTTPMethod:@"GET"];
    
    AFHTTPResponseSerializer *respond = [AFHTTPResponseSerializer serializer];
    respond.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/javascript" ,nil];
    manager.responseSerializer = respond;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingAllowFragments error:nil] ;
            NSLog(@"JSON: %@", dic);
            if (success) {
                success(dic);
            }
        }
    }];
    [dataTask resume];
    
    return dataTask;
}


+(NSURLSessionDataTask *)post:(NSString *)urlstr
                       params:(NSDictionary *)params
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure
                        Array:(NSMutableArray *)array
                        JudgeURL:(BOOL)sameURL
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tmpparams];
    NSMutableString *mutableUrl = [urlstr mutableCopy];
    NSArray *keys = [params allKeys];
    for (int i = 0; i < keys.count;i++) {
        [mutableUrl appendFormat:@"&%@=%@",keys[i],params[keys[i]]];
    }

    NSLog(@"Post %@,%@",urlstr,params);
    //判断是否同个接口，是就中断重新加载
    if(sameURL == YES){
        for (NSURLSessionDataTask *task in array) {
            
            if ([[task.currentRequest.URL absoluteString] isEqualToString:urlstr]) {
                [task cancel];
                [array removeObject:task];
                break;
            }
        }
    }
    
     NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSData*paramData=[mutableUrl dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paramData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFHTTPResponseSerializer *respond = [AFHTTPResponseSerializer serializer];
    respond.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/javascript" ,nil];
    manager.responseSerializer = respond;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingAllowFragments error:nil] ;
            NSLog(@"JSON: %@", dic);
            if (success) {
                success(dic);
            }
        }
    }];
    [dataTask resume];
    
    return dataTask;
}

//#pragma mark 图像文件上传
//+ (AFHTTPRequestOperation *)uploadingFileImage:(UIImage *)image URL:(NSString *)url params:(NSDictionary *)tmpparams success:(void (^)(id))success failure:(void (^)(NSError *))failure Array:(NSMutableArray *)array {
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tmpparams];
//    
//    NSLog(@"Post %@,%@",url,params);
//    //判断是否同个接口，是就中断重新加载
//    for (AFHTTPRequestOperation *operation in array) {
//        
//        if ([[operation.request.URL absoluteString] isEqualToString:url]) {
//            [operation cancel];
//            [array removeObject:operation];
//            break;
//        }
//    }
//    
//    
//    NSData *data = UIImagePNGRepresentation(image);
//    
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSArray *keys = params[@"headers"];
//    for (int i = 0; i < keys.count;i++) {
//        [serializer setValue:params[keys[i]] forHTTPHeaderField:keys[i]];
//    }
//    
//    //
//    //    NSDictionary *dic = @{@"pUserID":[DELEGATE.afterLoginInfor objectForKey:@"UserID"]};
//    
//    NSMutableURLRequest *request =
//    [serializer multipartFormRequestWithMethod:@"POST"
//                                     URLString:url
//                                    parameters:@{}
//                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                         [formData appendPartWithFileData:data
//                                                     name:@"file"
//                                                 fileName:@"myimage.jpg"
//                                                 mimeType:@"image/jpeg"];
//                     } error:nil];
////    [serializer multipartFormRequestWithMethod:@"POST"
////                                     URLString:url
////                                    parameters:@{}
////                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////                         [formData appendPartWithFileData:data
////                                                     name:@"file"
////                                                 fileName:@"myimage.jpg"
////                                                 mimeType:@"image/jpeg"];
////                     }];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
////    __weak __typeof(self)weakSelf = self;
//    AFHTTPRequestOperation *operation =
//    [manager HTTPRequestOperationWithRequest:request
//                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
////                                         NSError *error;
//                                         NSString *str =  [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
//                                         if ([str isEqualToString:@"0000"]) {
//                                             
//                                         }else{
//                                             
//                                         }
//                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                         
//                                         
//                                     }];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten,
//                                        long long totalBytesWritten,
//                                        long long totalBytesExpectedToWrite) {
//        
//        
//        
//    }];
//    [operation start];
//    return operation;
//    
//}
//
//
//#pragma mark 图像base64上传
//+ (AFHTTPRequestOperation *)uploadingImageBase64:(UIImage *)image URL:(NSString *)url params:(NSDictionary *)tmpparams success:(void (^)(id))success failure:(void (^)(NSError *))failure Array:(NSMutableArray *)array {
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:tmpparams];
//    
//    NSLog(@"Post %@,%@",url,params);
//    //判断是否同个接口，是就中断重新加载
//    for (AFHTTPRequestOperation *operation in array) {
//        
//        if ([[operation.request.URL absoluteString] isEqualToString:url]) {
//            [operation cancel];
//            [array removeObject:operation];
//            break;
//        }
//    }
//    
//    NSData *data = UIImagePNGRepresentation(image);
//    
//    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//    // 要解决此问题，
//    // 可以在上传时使用当前的系统事件作为文件名
//    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    //    // 设置时间格式
//    //    formatter.dateFormat = @"yyyyMMddHHmmss";
//    //    NSString *str = [formatter stringFromDate:[NSDate date]];
//    //    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//    /*
//     32          此方法参数
//     33          1. 要上传的[二进制数据]
//     34          2. 对应网站上[upload.php中]处理文件的[字段"file"]
//     35          3. 要保存在服务器上的[文件名]
//     36          4. 上传文件的[mimeType]
//     37          */
//    //    [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
//    
//    
//    
//    
//    
//    
//    
//    
//    NSString *userImageBase64Binary = [Base64 stringByEncodingData:data];
//    [params setObject:@"测试" forKey:@"photo_desc"];
//    [params setObject:userImageBase64Binary forKey:@"f_base64"];
//    [params setObject:@"" forKey:@"_order_id"];
//    
//    //    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
//    //                                                                                       URLString:url
//    //                                                                                      parameters:params
//    //                                                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    //                                                                       } error:nil];
//    //
//    //
//    //
//    //    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    //    operation.responseSerializer = [AFJSONResponseSerializer serializer];//响应
//    //    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/javascript" ,nil];
//    //
//    //    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    //
//    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    //
//    //    }];
//    //    [operation start];
//    //    return operation;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    //        manager.requestSerializer = requestSerializer;//请求/
//    //        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    //响应
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",@"text/javascript" ,nil];
//    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy = securityPolicy;
//    AFHTTPRequestOperation *operation =
//    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingAllowFragments error:nil] ;
//        NSLog(@"JSON: %@", dic);
//        if (success) {
//            success(dic);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten,
//                                        long long totalBytesWritten,
//                                        long long totalBytesExpectedToWrite) {
//        
//    }];
//    [operation start];
//    return operation;
//}


@end
