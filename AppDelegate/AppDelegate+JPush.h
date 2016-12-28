//
//  AppDelegate+JPush.h
//  PurchaseVegetable
//
//  Created by 悦厚 on 12/12/16.
//  Copyright © 2016年 Shenzhen Cunhou Industrial Co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

- (void)_registerJPushWithLaunchOption:(NSDictionary*)launchOptions;

@end
