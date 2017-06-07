//
//  EaseMessageHelper.h
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/25.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
// 将环信的message包装了一层，目的是：如果有环信的message是带有ext的，这样会方便二次加工，比如红包消息，ext:{@"RedPack":@YES},我可以向MessageType里加一个红包
typedef enum : NSUInteger {
    Txt,
    Img,
    Loc,
    Voice,
    Video,
    File,
    RedPackage
} MessageType;

@class EMMessage;
@class EMTextMessageBody;

@interface EaseMessageHelper : NSObject
+ (MessageType)typeFromMessage:(EMMessage *)msg;

+ (NSString *)txtWithTxtBody:(EMTextMessageBody *)body;

@end
