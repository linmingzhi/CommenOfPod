//
//  AppDelegate+JPush.m
//  PurchaseVegetable
//
//  Created by 悦厚 on 12/12/16.
//  Copyright © 2016年 Shenzhen Cunhou Industrial Co.Ltd. All rights reserved.
//

#import "AppDelegate+JPush.h"
//极光推送

#import <UserNotifications/UserNotifications.h>

#import "UIAlertView+Blocks.h"

#import "MessageCenterViewController.h"

@implementation AppDelegate (JPush)

- (void)_registerJPushWithLaunchOption:(NSDictionary*)launchOptions
{
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"8e6f95fb6ed68d819d1d63d8"
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
}//注册极光推送

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [JPUSHService setBadge:0];
    
    
}// 开始活跃

#pragma mark - Remote Notification
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}//注册远程通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"888888888888888888888888888%@",userInfo);
    
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSLog(@"%@",alert);
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                            message:alert
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }else{
        NSLog(@"程序在后台收到的推送消息%@",userInfo);
//        NSString *str=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
       
            MessageCenterViewController * VC = [[MessageCenterViewController alloc]init];
        VC.isRoot=YES;
        NSNotificationCenter *cen=[NSNotificationCenter defaultCenter];
        [cen postNotificationName:@"message" object:nil];
            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
            [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        
       
        
    }
    
    
    // Required,For systems with less than or equal to iOS6
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    
}//接受远程通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {  //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
        
        
    }else {
        NSLog(@"程序在后台收到的推送消息%@",userInfo);
//        NSString *str=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
       
            MessageCenterViewController * VC = [[MessageCenterViewController alloc]init];
        VC.isRoot=YES;
        NSNotificationCenter *cen=[NSNotificationCenter defaultCenter];
        [cen postNotificationName:@"message" object:nil];
            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
            [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        
            }
    
    

    
    
    
    // IOS 7 Support Required
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSLog(@"UUUUUU%@",userInfo);
    UIApplication *application=[UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
//        NSString *str=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
            UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:nil message:@"您有新的提醒发货" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            [alertView showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    MessageCenterViewController * VC = [[MessageCenterViewController alloc]init];
                    VC.isRoot=YES;
                    NSNotificationCenter *cen=[NSNotificationCenter defaultCenter];
                    [cen postNotificationName:@"message" object:nil];
                    UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];
//                    VC.isPush=1;
                    [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
                    
                }
            }];
            [alertView show];
    }else{
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
        MessageCenterViewController *VC = [[MessageCenterViewController alloc]init];
        VC.isRoot=YES;
        NSNotificationCenter *cen=[NSNotificationCenter defaultCenter];
        [cen postNotificationName:@"message" object:nil];
        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];

    
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); // 系统要求执行这个方法
//    NSLog(@"IOS10UUUUUU%@",userInfo);
    UIApplication *application=[UIApplication sharedApplication];
    if (application.applicationState == UIApplicationStateActive) {
    }else{
        
            MessageCenterViewController *VC = [[MessageCenterViewController alloc]init];
            UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
            VC.isRoot=YES;
        NSNotificationCenter *cen=[NSNotificationCenter defaultCenter];
        [cen postNotificationName:@"message" object:nil];
        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
        }
    
        
    
    
}



@end
