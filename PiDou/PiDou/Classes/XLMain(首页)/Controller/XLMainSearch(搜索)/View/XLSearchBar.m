//
//  XLSearchBar.m
//  CBNReporterVideo
//
//  Created by kevin on 9/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLSearchBar.h"
#import "UIImage+TGExtension.h"
// icon宽度
static CGFloat const searchIconW = 14.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 5.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 14.0;

@interface XLSearchBar () <UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end

@implementation XLSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置背景图片
    UIImage *backImage = [UIImage imageWithColor:COLOR(0xf8f8f8)];
    [self setBackgroundImage:backImage];
    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            // 重设field的frame
            field.frame = CGRectMake(5.0, 6, self.frame.size.width-10.0, self.frame.size.height-12.0);
            [field setBackgroundColor:[UIColor whiteColor]];
            field.textColor = XL_COLOR_BLACK;
            
            field.borderStyle = UITextBorderStyleNone;
            field.layer.cornerRadius = 2.0f;
            field.layer.masksToBounds = YES;
            
            // 设置占位文字字体颜色
            [field setValue:XL_COLOR_GRAY forKeyPath:@"_placeholderLabel.textColor"];
            [field setValue:[UIFont xl_fontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
            
            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
                [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}


@end
