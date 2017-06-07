//
//  ConversationListViewController.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ConversationCell.h"
#import "NSString+Category.h"
#import "ConversationsManager.h"
#import <Hyphenate/Hyphenate.h>


@interface ConversationListViewController () <EMChatManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *datasource;
@end

@implementation ConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerEaseDelegate];
    self.tableView.tableFooterView = [UIView new];
    
    // 因为是单独定义的cell，且使用了xib，所以此处需要先注册。
    UINib *cellNib = [UINib nibWithNibName:@"ConversationCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ConversationCell"];
    
    [self reloadAllConversations];
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    
    return _datasource;
}

- (void)reloadAllConversations {
    // 获取所有会话，转化成model并排序，之后添加到datasource中
    [self.datasource removeAllObjects];
    // [[EMClient sharedClient].chatManager getAllConversations] 获取所有已存在的会话。
    [self.datasource addObjectsFromArray:[ConversationsManager conversationModelsWithConversations:[[EMClient sharedClient].chatManager getAllConversations]]];
    [self.tableView reloadData];
}

// 环信Chat相关的回调，就靠它了
- (void)registerEaseDelegate {
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

#pragma - mark EMChatManagerDelegate
// 收消息回调,因为前面做了 [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil]; 所以收消息的时候会走这个环信的回调。
- (void)messagesDidReceive:(NSArray *)aMessages {
    [self reloadAllConversations];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell"];
    cell.model = self.datasource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// cell 侧滑显示的item
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationModel *model = self.datasource[indexPath.row];
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [model removeComplation:^{
            [self reloadAllConversations];
        }];
    }];
    
    rowAction.backgroundColor = [UIColor redColor];
    
    NSString *topStr = model.isTop? @"取消置顶" : @"置顶";
    UITableViewRowAction *rowaction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:topStr handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [model setIsTop:!model.isTop];
        [self reloadAllConversations];
    }];
    rowaction.backgroundColor = [UIColor blueColor];
    return @[rowAction,rowaction];
}

@end
