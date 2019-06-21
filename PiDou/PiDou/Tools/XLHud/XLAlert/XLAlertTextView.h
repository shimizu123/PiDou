//
//  XLAlertTextView.h
//  CBNReporterVideo
//
//  Created by kevin on 10/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLAlertTextView : UITextView

/** 是否可以选择文字 */
@property (nonatomic, assign) BOOL canSelectText;

/** 计算frame */
- (CGRect)calculateFrameWithMaxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight originY:(CGFloat)originY superView:(UIView *)superView;

@end
