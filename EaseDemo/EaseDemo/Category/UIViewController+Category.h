//
//  UIViewController+Category.h
//  EaseDemo
//
//  Created by 杜洁鹏 on 2017/5/24.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)
- (void)presentViewControllerWithStoryboardId:(NSString *)aId
                                     animated:(BOOL)animated
                                   completion:(void(^)())aComplation;

- (void)showAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage complation:(void(^)())aComplation;
@end
