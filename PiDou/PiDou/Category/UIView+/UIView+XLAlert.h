//
//  UIView+XLAlert.h
//  TG
//
//  Created by kevin on 27/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickAlertHandler)(UIAlertAction *confirmAction);
@interface UIView (XLAlert)



- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(clickAlertHandler)confirm cancleHandle:(clickAlertHandler)cancle;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmHandle:(clickAlertHandler)confirm;

@end
