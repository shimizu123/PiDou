//
//  XLTextViewLimitView.m
//  TG
//
//  Created by kevin on 3/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLTextViewLimitView.h"


#define MaxLimit 300

@interface  XLTextViewLimitView() <UITextViewDelegate>

@property (nonatomic, strong) UILabel *limitL;

@end

@implementation XLTextViewLimitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.limitLableToRight = XL_LEFT_DISTANCE;
    self.maxLimit = MaxLimit;
    self.textView = [[XLTextView alloc] init];
    self.textView.backgroundColor = COLOR(0xF5F5F5);
    self.textView.placeholder = @"请输入";
    self.textView.delegate = self;
    self.textView.tintColor = XL_COLOR_BLACK;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self addSubview:self.textView];
    
    
    self.limitL = [[UILabel alloc] init];
    [self.limitL xl_setTextColor:XL_COLOR_GRAY fontSize:12.f];
    self.limitL.textAlignment = NSTextAlignmentRight;
    self.limitL.text = [NSString stringWithFormat:@"0/%d",self.maxLimit];
    [self addSubview:self.limitL];
    
    [self initLayout];
}

- (void)initLayout {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10 * kWidthRatio6s);
        make.top.equalTo(self.mas_top).offset(7 * kWidthRatio6s);
        make.right.equalTo(self.mas_right).offset(-10 * kWidthRatio6s);
        make.bottom.equalTo(self.limitL.mas_top).offset(-5);
    }];
    
    [self.limitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-self.limitLableToRight);
        make.bottom.equalTo(self.mas_bottom).offset(-XL_LEFT_DISTANCE);
    }];
}

- (void)setMaxLimit:(int)maxLimit {
    _maxLimit = maxLimit;
    self.limitL.text = [NSString stringWithFormat:@"0/%d",_maxLimit];
}

#pragma mark  - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.maxLimit && textView.markedTextRange == nil) {
        existTextNum = self.maxLimit;
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:self.maxLimit];
        
        [textView setText:s];
    }
    
    //不让显示负数
    self.limitL.text = [NSString stringWithFormat:@"%ld/%d",existTextNum,self.maxLimit];
    if (_delegate && [_delegate respondsToSelector:@selector(limitTextViewDidChange:)]) {
        [_delegate limitTextViewDidChange:textView];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {     //其实你可以加在这个代理方法中。当你将要编辑的时候。先执行这个代理方法的时候就可以改变间距了。这样之后输入的内容也就有了行间距。
    
    if (textView.text.length < 1) {
        textView.text = @"间距";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:textView.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    if ([textView.text isEqualToString:@"间距"]) {           //之所以加这个判断是因为再次编辑的时候还会进入这个代理方法，如果不加，会把你之前输入的内容清空。你也可以取消看看效果。
        textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];//主要是把“间距”两个字给去了。
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(limitTextViewDidEndEditing:)]) {
        [_delegate limitTextViewDidEndEditing:textView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(limitTextViewDidBeginEditing:)]) {
        [_delegate limitTextViewDidBeginEditing:textView];
    }
}
- (void)setTg_placeholder:(NSString *)tg_placeholder {
    _tg_placeholder = tg_placeholder;
    self.textView.placeholder = _tg_placeholder;
}

- (void)setLimitLableToRight:(CGFloat)limitLableToRight {
    _limitLableToRight = limitLableToRight;
    [self.limitL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-self.limitLableToRight);
    }];
}

@end
