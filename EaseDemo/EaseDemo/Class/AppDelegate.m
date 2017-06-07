//
//  AppDelegate.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//  最纯粹的sdk调用

#import "AppDelegate.h"
#import <Hyphenate/Hyphenate.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self registerEaseMob];
    [self registerApns];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 判断当前要显示那个页面，此处使用环信的自动登录来判断。
    if (![EMClient sharedClient].isAutoLogin) // 如果自动登录没有开启，则说明需要登录
    {
        [self jumpToLoginVC:nil];
    }
    
    else // 如果自动登录已经开启了，说明是之前登陆过的，直接跳转到应用内部。
    {
        [self jumpToMainVC:nil];
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)registerEaseMob {
    
    // 设置appkey，没有的话，去 https://console.easemob.com 注册
    EMOptions *options = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
    
    // 开启控制台日志，开启后，会输出环信的日志在控制台(默认是NO)。
    options.enableConsoleLog = YES;
    
    // 送达回执，开启后的效果是: 当我发送消息，只要对方收到了，我就会得到一个回调(默认值是NO)
    options.enableDeliveryAck = YES;
    
    // 是否自动同意群组邀请。 该设置打开后，如果你在线,对方邀请你进群，你会自动进入，不需要你去调用同意方法(默认值就是YES)。
    options.isAutoAcceptGroupInvitation = YES;
    
    // 离开群组时是否自动删除群组的会话,设置为yes后，该群组的Conversation和messages会被删除(默认值就是YES)。
    options.isDeleteMessagesWhenExitGroup = YES;
    
    // 是否自动同意好友申请。设置后，在线时如果有人申请加好友，会自动同意(默认值是NO)。
    options.isAutoAcceptFriendInvitation = YES;
    
    // 是否允许聊天室创建者离开聊天室(默认是YES)。
    options.isChatroomOwnerLeaveAllowed = YES;
    
    // 离开群组时是否自动删除聊天室会话,设置为yes后，该聊天室的Conversation和messages会被删除(默认值就是YES)。
    options.isDeleteMessagesWhenExitChatRoom = YES;
    
    // 初始化SDK
    [[EMClient sharedClient] initializeSDKWithOptions:options];
}

// 配置推送
- (void)registerApns {
    /* 如果想设置生效，
     *  1. 需要在苹果开发者中心设置app支持推送，可以参考http://www.imgeek.org/article/825308748
     *  2. 打开app的推送项目，以本APP为例，打开方式：在xcode里选中project -- target(EaseDemo) -- Capabilities 打开Push Notifications 的开关。
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}


// 推送配置出现变动后，会走该回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings{
    // 注册推送
    [application registerForRemoteNotifications];
}

#pragma mark - APNS
// 这里添加处理本地通知代码
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

// 此处处理远程推送的通知代码
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /*
     *  此处做个简单的说明。
     *  理论上来说，在环信的场景下，这个方法是永远不会执行的。主要原因
     *  1. 环信再长理解存在的时候，不会走向客户端发送apns，也就是说，当你的app在前台或者在后台存活的时候，环信不会给您发apns，所以这个方法不会走。
     *  2. 当app挂起或者进程被杀死的时候，程序中的代码是不会执行的，所以该方法也不会执行。
     *  
     *  那么此处代码何时会执行？
     *  这个是苹果的机制问题了，只有APP在前台且收到APNs推送的时候才会走。在环信的场景下这个情况是不存在的。
     */
}

#pragma mark - 环信声明周期
/*
 *  这以下两个方法一定要写，很重要，在APP进入后台的时候，加入这一句才能保证环信的长连接状态正常，并且唤醒的时候继续接收消息。
 *  做一个环信后台的简要说明：
 *  用户按Home键:  应用立刻进入后台，执行[[EMClient sharedClient] applicationDidEnterBackground:application]方法，环信长连接保持，有新消息的时候会调用环信收消息的回调。
 *  后台若干分钟后:  苹果不允许应用永久后台，在3~10分钟左右应用被系统挂起，所有的进程都进入休眠状态，环信长连接断开。此时有新消息，不会通过环信收消息回调，而是通过苹果的APNs通知客户端有新消息，同时该消息会作为离
 *                线消息，保存到环信的服务器。
 *  用户重新点开APP:  应用启动，进程会开始执行，此时通过环信的[[EMClient sharedClient] applicationWillEnterForeground:application]方法，唤醒环信，环信长连接重新建立，通过环信回调接收之前的离线消息。
 */

// 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// 程序从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)jumpToMainVC:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ToMainVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToLoginVC:) name:@"ToLoginVC" object:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.window.rootViewController = vc;
}

- (void)jumpToLoginVC:(NSNotification *)noti  {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ToLoginVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMainVC:) name:@"ToMainVC" object:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    self.window.rootViewController = vc;
}



@end
