//
//  XLNewsEditTextField.m
//  CBNReporterVideo
//
//  Created by kevin on 8/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLNewsEditTextField.h"

@interface XLNewsEditTextField ()
@end

@implementation XLNewsEditTextField

- (void)deleteBackward {
    if ([self.text length] == 0) {
        if (_tfProtocol && [_tfProtocol respondsToSelector:@selector(XLTextFieldDeleteBackward:)]) {
            [_tfProtocol XLTextFieldDeleteBackward:self];
        }
    }
    [super deleteBackward];
}

// 在iOS8.0到iOS8.2的系统中你会发现，deleteBackward方法不响应的解决方案
- (BOOL)keyboardInputShouldDelete:(UITextField *)textField {
    BOOL shouldDelete = YES;
    
    if ([UITextField instancesRespondToSelector:_cmd]) {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];
        
        if (keyboardInputShouldDelete) {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }
    
    BOOL isIos8 = ([[[UIDevice currentDevice] systemVersion] intValue] == 8);
    BOOL isLessThanIos8_3 = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.3f);
    
    if (![textField.text length] && isIos8 && isLessThanIos8_3) {
        [self deleteBackward];
    }
    
    return shouldDelete;
}


@end
