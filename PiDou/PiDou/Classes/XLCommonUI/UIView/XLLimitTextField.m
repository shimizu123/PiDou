//
//  XLLimitTextField.m
//  TG
//
//  Created by kevin on 9/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLLimitTextField.h"
#import "NSMutableAttributedString+TGExtension.h"


#define FONT_SIZE 14.0f

@interface XLLimitTextField () <UITextFieldDelegate>

@end

@implementation XLLimitTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.font = [UIFont xl_fontOfSize:FONT_SIZE];
    self.tintColor = XL_COLOR_BLACK;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
}


- (void)textFieldDidChange:(UITextField *)textField {
    if (self.maxNumLimit > 0) {
        if (textField.text.length > self.maxNumLimit && textField.markedTextRange == nil) {
            textField.text = [textField.text substringToIndex:self.maxNumLimit];
        }
    }
    if (self.textFieldDidChange) {
        self.textFieldDidChange(textField.text);
    }
}

- (void)textFieldDidBegin:(UITextField *)textField {
    if (self.textFieldBeginEdit) {
        self.textFieldBeginEdit(textField.text);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIScrollView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            CGPoint offset = view.contentOffset;
            if (offset.y != 0) {
                offset.y = 0;
                view.contentOffset = offset;
            }
            break;
        }
    }
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, self.leftSpacing ?  [self.leftSpacing floatValue] : XL_LEFT_DISTANCE, (self.xl_h - self.font.lineHeight) * 0.5 - 1);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, self.leftSpacing ?  [self.leftSpacing floatValue] : XL_LEFT_DISTANCE, (self.xl_h - self.font.lineHeight) * 0.5 - 1);
}

- (void)setXl_placeholder:(NSString *)xl_placeholder {
    _xl_placeholder = xl_placeholder;
    self.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:_xl_placeholder color:COLOR(0xCCCCCC) font:self.font];
}

@end
