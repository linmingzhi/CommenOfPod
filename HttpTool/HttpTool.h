//
//  HttpTool.h
//  Text1234
//
//  Created by linmingzhi on 15/4/29.
//  Copyright (c) 2015年 linmingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSURLSessionDataTask;

@interface HttpTool : NSObject

/**
 *  发送一个POST请求
 *   url     请求路径
 *   params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param array 请求的集合
 *  @param sameURL 判断是否相同的接口
 **/
+(NSURLSessionDataTask *)get:(NSString *)urlstr
                      params:(NSDictionary *)tmpParams
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure
                       Array:(NSMutableArray *)array
                    JudgeURL:(BOOL)sameURL;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param array 请求的集合
 *  @param sameURL 判断是否相同的接口
 **/
+(NSURLSessionDataTask *)post:(NSString *)url
                       params:(NSDictionary *)params
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure
                        Array:(NSMutableArray *)array
                        JudgeURL:(BOOL)sameURL;

#pragma mark 图像base64上传
//+ (NSMutableURLRequest *)uploadingImageBase64:(UIImage *)image URL:(NSString *)url params:(NSDictionary *)tmpparams success:(void (^)(id))success failure:(void (^)(NSError *))failure Array:(NSMutableArray *)array;

@end
