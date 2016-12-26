//
//  NSString+HTMLStr.h
//  PurchaseSecretary
//
//  Created by 飞飞 on 16/5/5.
//  Copyright © 2016年 Shenzhen Cunhou Industrial Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLStr)
- (NSString *)stringByDecodingXMLEntities;
@end
