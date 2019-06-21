//
//  XLTextViewLimitView.h
//  TG
//
//  Created by kevin on 3/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTextView.h"

@protocol XLTextViewLimitViewDelegate <NSObject>

@optional;
- (void)limitTextViewDidEndEditing:(UITextView *)textView;
- (void)limitTextViewDidBeginEditing:(UITextView *)textView;
- (void)limitTextViewDidChange:(UITextView *)textView;

@end

@interface XLTextViewLimitView : UIView

@property (nonatomic, assign) int maxLimit;
@property (nonatomic, copy) NSString *tg_placeholder;
@property (nonatomic, strong) XLTextView *textView;
/**字数限制距离右边间距*/
@property (nonatomic, assign) CGFloat limitLableToRight;

@property (nonatomic, weak) id <XLTextViewLimitViewDelegate> delegate;

@end
