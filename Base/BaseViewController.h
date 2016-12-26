//
//  BaseViewController.h
//  CalfManagerCar
//
//  Created by lin on 15/11/9.
//  Copyright © 2015年 一手活. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSURLSessionDataTask;

@interface BaseViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *requestOperationArray;


#pragma mark 网格请求get
-(NSURLSessionDataTask *)get:(NSString *)url
                      params:(NSDictionary *)params
                         HUD:(BOOL)b
                    JudgeURL:(BOOL)sameURL
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure;
#pragma mark 网格请求Post
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                           HUD:(BOOL)b
                      JudgeURL:(BOOL)sameURL
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure
                          ;


@end
