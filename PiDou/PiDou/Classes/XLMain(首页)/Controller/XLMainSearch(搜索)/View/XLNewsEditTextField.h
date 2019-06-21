//
//  XLNewsEditTextField.h
//  CBNReporterVideo
//
//  Created by kevin on 8/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLNewsEditTextField;
@protocol XLNewsEditTextFieldProtocol <NSObject>

- (void)XLTextFieldDeleteBackward:(XLNewsEditTextField *)textField;


@end

@interface XLNewsEditTextField : UITextField

@property (nonatomic, weak) id <XLNewsEditTextFieldProtocol> tfProtocol;


@end
