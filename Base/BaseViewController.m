//
//  BaseViewController.m
//  CalfManagerCar
//
//  Created by lin on 15/11/9.
//  Copyright © 2015年 一手活. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"
#import "HttpTool.h"

@interface BaseViewController()



@end

@implementation BaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _requestOperationArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
//    self.navigationController.navigationBar.barTintColor = KBackColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName: @"Helvetica" size: 20.0],NSFontAttributeName, nil]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

- (void) backBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.view endEditing:YES];
    
    [self clearRequest];

}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear: animated];
    
    [self clearRequest];
}

#pragma mark 清除请求
- (void)clearRequest{
    for (NSURLSessionDataTask *request in _requestOperationArray) {
        [request cancel];
    }
    [_requestOperationArray removeAllObjects];
}


#pragma mark 网格请求get
-(NSURLSessionDataTask *)get:(NSString *)url
                      params:(NSDictionary *)params
                         HUD:(BOOL)b
                    JudgeURL:(BOOL)sameURL
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure
{
    if (b) {
//        [UIKitUtility showMBProgessHUDWithView:self.view animated:YES];
    }
    
    return [HttpTool get:url params:params success:success failure:failure Array:_requestOperationArray JudgeURL:sameURL];
}
#pragma mark 网格请求Post
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(NSDictionary *)params
                           HUD:(BOOL)b
                      JudgeURL:(BOOL)sameURL
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure
{
    if (b) {
//        [UIKitUtility showMBProgessHUDWithView:self.view animated:YES];
    }
    
    return [HttpTool post:url params:params success:success failure:failure Array:_requestOperationArray JudgeURL:sameURL];
}


@end
