//
//  UIViewController+Category.m
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)
- (void)presentViewControllerWithStoryboardId:(NSString *)aId animated:(BOOL)animated completion:(void(^)())aComplation {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:aId];
    [self presentViewController:vc animated:animated completion:aComplation];
}

- (void)showAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage complation:(void(^)())aComplation{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:aComplation];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
