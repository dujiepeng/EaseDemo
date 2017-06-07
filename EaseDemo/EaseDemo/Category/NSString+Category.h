//
//  NSString+Category.h
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMMessage;

@interface NSString (Category)
+ (NSString *)dateFromTimestamp:(long long)aTimestamp;
@end
