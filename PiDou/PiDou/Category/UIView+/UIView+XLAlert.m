//
//  UIView+XLAlert.m
//  TG
//
//  Created by kevin on 27/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "UIView+XLAlert.h"
#import <objc/runtime.h>

@implementation UIView (XLAlert)


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(clickAlertHandler)confirm cancleHandle:(clickAlertHandler)cancle {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancle];
    UIAlertAction *confirmlAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirm];
    [self showAlertWithTitle:title message:message cancelAction:cancelAction confirmAction:confirmlAction];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(clickAlertHandler)confirm {
    UIAlertAction *confirmlAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirm];
    [self showAlertWithTitle:title message:message cancelAction:nil confirmAction:confirmlAction];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelAction:(UIAlertAction *)cancelAction confirmAction:(UIAlertAction *)confirmAction {
    
    if (cancelAction == nil && confirmAction == nil) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    cancelAction != nil ? [alertController addAction:cancelAction] : nil;
    confirmAction != nil ? [alertController addAction:confirmAction] : nil;
    [self.parentController presentViewController:alertController animated:YES completion:nil];
}




@end
