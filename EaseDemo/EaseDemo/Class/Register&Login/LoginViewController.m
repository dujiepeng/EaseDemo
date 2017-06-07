//
//  LoginViewController.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Category.h"
#import <Hyphenate/Hyphenate.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *emPwdTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 点击注册按钮，跳到注册页面
- (IBAction)registBtnAction:(id)sender {
    [self presentViewControllerWithStoryboardId:@"RegisterNavigationController" animated:YES completion:nil];
}

- (IBAction)loginBtnAction:(id)sender {
    [[EMClient sharedClient] loginWithUsername:self.emIdTextField.text
                                      password:self.emPwdTextField.text
                                    completion:^(NSString *aUsername, EMError *aError)
     {
         if (aError) {
             [self showAlertWithTitle:@"登录失败" message:aError.errorDescription complation:nil];
         } else {
             [self showAlertWithTitle:@"登录成功" message:@"设置自动登录并跳转到APP内部" complation:^{
                 [EMClient sharedClient].options.isAutoLogin = YES;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ToMainVC" object:nil];
             }];
         }
     }];
}


@end
