//
//  ConversationsManager.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "ConversationsManager.h"
#import <Hyphenate/Hyphenate.h>
#import "EaseMessageHelper.h"

@interface ConversationModel ()
{
    NSString *_nick;
    NSString *_avatarPath;
    NSString *_unreadCountStr;
    NSString *_latestMsgTimeStr;
    NSString *_msgInfo;
}

@end

@implementation ConversationModel

- (NSString *)nick {
    return _nick?:_conversation.conversationId;
}

- (NSString *)avatarPath {
    return _avatarPath?:@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/f2deb48f8c5494ee230b853d2ff5e0fe99257eed.jpg";
}

- (NSString *)unreadCountStr {
    return _conversation.unreadMessagesCount > 99 ? @"99" : [NSString stringWithFormat:@"%d",_conversation.unreadMessagesCount];
}

- (NSString *)latestMsgTimeStr {
    return @"2017/5/25";
}

- (NSString *)msgInfo {

    return [self strFromLatestMsg];
}

- (NSString *)strFromLatestMsg {
    EMMessage *latestMsg = _conversation.latestMessage;
    MessageType type = [EaseMessageHelper typeFromMessage:latestMsg];
    switch (type) {
        case Txt:
        {
            /*
             *  此处直接返回了文本消息内容，如果是要做类似[有人@你]xxxxxx这样的效果，也可以自己实现。思路是：
             *  加入这消息是@的消息，可以把要@的人放到message.ext中，然后这里把它取出来，判断和当前登陆的账号是否一样，如果一样，在返回的信息中就加上[有人@你]这样的字样。
             *  如果需要使用红色字样显示，就需要修改成NSMutableString来处理。
             */
            return [EaseMessageHelper txtWithTxtBody:(EMTextMessageBody *)latestMsg.body];
        }
            break;
        case Img:{
            return @"[图片]";
        }
            break;
        case Loc:{
            return @"[位置]";
        }
            break;
        case Voice:{
            return @"[音频]";
        }
            break;
        case Video:{
            return @"[视频]";
        }
            break;
        case File:{
            return @"[文件]";
        }
            break;
        case RedPackage:{
            return @"[红包]"; // 只是举例，并不打算实现
        }
            break;
    }
}

- (BOOL)isTop {
    return [self.conversation.ext[@"isTop"] boolValue];
}

- (void)setIsTop:(BOOL)isTop {
    NSMutableDictionary *dic = [self.conversation.ext mutableCopy];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    dic[@"isTop"] = isTop ? @YES : @NO;
    self.conversation.ext = dic;
}

- (void)removeComplation:(void(^)())aComplation {
    [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        if (aComplation) {
            aComplation();
        }
    }];
}
@end

@implementation ConversationsManager

// 这里可以做一些你需要的排序，比如置顶消息之类的操作，思路就是如果置顶的conversation，可以修改它的conversation.ext。之后先把这些跳出来做一次排序并添加到数组中，然后剩下的再次排序，然后也添加到数组中，这样就做到了排序。
+ (NSArray *)conversationModelsWithConversations:(NSArray *)conversations {
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           if(obj1.latestMessage.timestamp > obj2.latestMessage.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];

    NSMutableArray *tmpAry = [NSMutableArray array];
    NSMutableArray *topAry = [NSMutableArray array];
    NSMutableArray *ret = [NSMutableArray array];
    
    for (EMConversation *conversation in sorted) {
        ConversationModel *model = [[ConversationModel alloc] init];
        model.conversation = conversation;
        // 如果conversationModel有其他信息，也可以在此处处理。
        if (model.isTop) {
            [topAry addObject:model];
        }else {
            [tmpAry addObject:model];
        }
    }
    
    [ret addObjectsFromArray:topAry];
    [ret addObjectsFromArray:tmpAry];
 
    return ret;
}

@end

