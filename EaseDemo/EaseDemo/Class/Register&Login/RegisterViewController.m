//
//  RegisterViewController.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+Category.h"
#import <Hyphenate/Hyphenate.h>

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *emPwdTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)registerBtnAction:(id)sender {
    // 环信id的规则是：a~z大小写字母/数字/下划线/横线/英文句号； 另外，环信不区分大小写，所以对环信来说，DU001和du001是一样的。
    [[EMClient sharedClient] registerWithUsername:self.emIdTextField.text
                                         password:self.emPwdTextField.text
                                       completion:^(NSString *aUsername, EMError *aError)
     {
         
         if (!aError) {
             // 注册成功了
             [self showAlertWithTitle:@"注册成功" message:@"可以用账号密码登录了！" complation:^{
                 [self dismissViewControllerAnimated:YES completion:nil];
             }];
         }else{
             // 注册失败
             [self showAlertWithTitle:@"注册失败" message:aError.errorDescription complation:nil];
         }
     }];
}

- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
