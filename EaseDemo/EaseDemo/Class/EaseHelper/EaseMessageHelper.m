//
//  EaseMessageHelper.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/25.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "EaseMessageHelper.h"
#import <Hyphenate/Hyphenate.h>

@implementation EaseMessageHelper
+ (MessageType)typeFromMessage:(EMMessage *)msg {
    // 解析是否有红包扩展，如果有，返回自定义的红包类型。
    if ([[msg.ext objectForKey:@"RedPack"] boolValue]) {
        return RedPackage;
    }
    
    EMMessageBody *body = msg.body;
    switch (body.type) {
        case EMMessageBodyTypeText:
            return Txt;
            break;
        case EMMessageBodyTypeImage:
            return Img;
            break;
        case EMMessageBodyTypeLocation:
            return Loc;
            break;
        case EMMessageBodyTypeVoice:
            return Voice;
            break;
        case EMMessageBodyTypeVideo:
            return Voice;
            break;
        case EMMessageBodyTypeFile:
            return File;
            break;
        default:
            return Txt;
            break;
    }
}

+ (NSString *)txtWithTxtBody:(EMTextMessageBody *)body {
    return body.text;
}

@end
