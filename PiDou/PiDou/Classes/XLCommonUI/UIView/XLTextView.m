//
//  XLTextView.m
//  TG
//
//  Created by kevin on 3/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLTextView.h"

@interface XLTextView ()



@end

@implementation XLTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置默认字体
        self.font = [UIFont xl_fontOfSize:14.f];
        self.textColor = XL_COLOR_BLACK;
        self.tintColor = XL_COLOR_BLACK;
        // 设置默认颜色
        self.placeholderColor = XL_COLOR_GRAY;

        if (self.isTextCenter) {
            self.layoutManager.allowsNonContiguousLayout = NO;
        }
        // 使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)notif {
    if (XLStringIsEmpty(self.text)) {
        [self setTextCenterWithDy:0];
    }
    // 会重新调用drawRect:方法
    [self setNeedsDisplay];
}


- (void)setTextCenterWithDy:(CGFloat)dy {
    if (self.isTextCenter) {
        self.contentOffset = CGPointMake(0, (self.contentSize.height - self.frame.size.height) * 0.5 - dy);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect {
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) return;
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 8;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
    [self setTextCenterWithDy:2];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)setTg_lineSpacing:(CGFloat)tg_lineSpacing {
    _tg_lineSpacing = tg_lineSpacing;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = _tg_lineSpacing;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    
    
}



- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    if (XLStringIsEmpty(self.text)) {
        return;
    }
    if (self.changeContentSizeBlock) {
        self.changeContentSizeBlock(@(contentSize));
    }
}



@end
