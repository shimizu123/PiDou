//
//  XLAddkeywordView.m
//  XLReporterVideo
//
//  Created by kevin on 17/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLAddkeywordView.h"
#import "XLNewsEditTextField.h"
#import "XLKeywordButton.h"
#import "XLAlertView.h"

#define LEFT 15 * kWidthRatio6s
#define TOP  15 * kWidthRatio6s

@interface XLAddkeywordView () <UITextFieldDelegate, XLNewsEditTextFieldProtocol> {
    CGFloat _tagHeight;
    UIFont *_fontInput;
    CGFloat _viewMaxHeight;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLNewsEditTextField *tfInput;
@property (nonatomic, strong) NSMutableArray *tagButtons;


@property (nonatomic, assign) NSInteger numberOfLines; //default 0;
@property (nonatomic, copy) NSString *placeholder;

/**选中的标签*/
@property (nonatomic, copy) NSString *selectedTag;
@property (nonatomic, strong, readwrite) NSMutableArray *tagStrings;

@end

@implementation XLAddkeywordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self initConfig];
    [self initUI];
}

- (void)initConfig {
    _tagHeight = 32 * kWidthRatio6s;
    _fontInput = [UIFont xl_fontOfSize:14.f];
    _viewMaxHeight = self.xl_h;
}

- (void)initUI {
    UIScrollView* sv = [[UIScrollView alloc] initWithFrame:self.bounds];
    sv.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    sv.contentSize = sv.frame.size;
    sv.contentSize = CGSizeMake(sv.frame.size.width, sv.frame.size.height);
    sv.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    sv.showsVerticalScrollIndicator = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [self addSubview:sv];
    self.scrollView = sv;
    
    XLNewsEditTextField *tf = [[XLNewsEditTextField alloc] initWithFrame:CGRectMake(0, 0, 0, _tagHeight)];
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    [tf addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    tf.delegate = self;
    tf.tfProtocol = self;
    tf.placeholder= self.placeholder;
    tf.returnKeyType = UIReturnKeyDone;
    [self.scrollView addSubview:tf];
    self.tfInput = tf;
    self.tfInput.hidden = YES;
    
    [self layoutTagviews];
    [self.tfInput becomeFirstResponder];
}

#pragma mark - 布局
- (void)layoutTagviews {
    float oldContentHeight = self.scrollView.contentSize.height;
    float offsetX = LEFT;
    float offsetY = TOP;

    BOOL needLayoutAgain = NO;// just for too large text
    BOOL shouldFinishLayout = NO;//just for break line
    int currentLine = 0;
    for (int i = 0; i<_tagButtons.count; i++) {
        XLKeywordButton* tagButton = _tagButtons[i];
        tagButton.tag = 1000 + i;
        tagButton.hidden = NO;
        if (shouldFinishLayout) {
            tagButton.hidden = YES;
            continue;
        }
        CGRect frame = tagButton.frame;
        
        if (tagButton.frame.size.width > self.scrollView.contentSize.width) {
            NSLog(@"!!!  tagButton width tooooooooo large");
            [tagButton removeFromSuperview];
            [_tagButtons removeObjectAtIndex:i];
            [_tagStrings removeObjectAtIndex:i];
            needLayoutAgain = YES;
            break;
        } else {
            //button
            if ((offsetX + tagButton.frame.size.width) <= self.scrollView.contentSize.width - LEFT) {
                frame.origin.x = offsetX;
                frame.origin.y = offsetY;
                offsetX += (tagButton.frame.size.width + XL_LEFT_DISTANCE);
            } else {//break line
                currentLine++;
                if (_numberOfLines != 0 && _numberOfLines <= currentLine) {
                    shouldFinishLayout = YES;
                    
                    tagButton.hidden = YES;
                    continue;
                }
                
                offsetX = XL_LEFT_DISTANCE;
                offsetY += (_tagHeight + XL_LEFT_DISTANCE);
                
                frame.origin.x = offsetX;
                frame.origin.y = offsetY;
                offsetX += (tagButton.frame.size.width + XL_LEFT_DISTANCE);
            }
            tagButton.frame = frame;
            //arrow
        }
    }
    if (needLayoutAgain) {
        [self layoutTagviews];
        return;
    }
    //input view

    if (YES) {
        _tfInput.textColor = XL_COLOR_BLACK;
        _tfInput.font = _fontInput;
        _tfInput.placeholder = self.placeholder;
        {
            CGRect frame=_tfInput.frame;
            frame.size.width = [_tfInput.text sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + _tagHeight;
            //place holde width
            frame.size.width = MAX(frame.size.width, [self.placeholder sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + _tagHeight);
            frame.size.width = MIN(frame.size.width, self.xl_w - 2 * LEFT);
            _tfInput.frame = frame;
        }
        
        if (_tfInput.frame.size.width>_scrollView.contentSize.width) {
            NSLog(@"!!!  _tfInput width tooooooooo large");
            
        }else{
            CGRect frame=_tfInput.frame;
            if ((offsetX+_tfInput.frame.size.width)
                <=_scrollView.contentSize.width) {
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=_tfInput.frame.size.width;
            }else{
                offsetX = XL_LEFT_DISTANCE;
                offsetY += (_tagHeight + XL_LEFT_DISTANCE);
                
                frame.origin.x=offsetX;
                frame.origin.y=offsetY;
                offsetX+=_tfInput.frame.size.width;
            }
            _tfInput.frame=frame;
            
        }
        
    }
    
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width, offsetY+_tagHeight);
    {
        CGRect frame=_scrollView.frame;
        frame.size.height=_scrollView.contentSize.height;
        frame.size.height=MIN(frame.size.height, _viewMaxHeight);
        self.scrollView.frame=frame;
    }

    
    if (oldContentHeight != self.scrollView.contentSize.height) {
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
}

- (void)addTags:(NSArray *)tags {
    if (XLArrayIsEmpty(tags)) {
        while (self.tagStrings.count) {
            [self removeTag:[self.tagStrings firstObject]];
        }
    }
    for (NSString *tag in tags) {
        [self addLastTag:tag];
    }
}

#pragma mark - 添加标签到最后一个位置
- (void)addLastTag:(NSString *)tag {
    NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
    if (result.count == 0) {
        [self.tagStrings addObject:tag];
        
        XLKeywordButton *button = [self tagButtonWithTag:tag];
        [self.scrollView addSubview:button];
        [self.tagButtons addObject:button];
    } else {
        //[HUDController hideHUDWithText:@"关键字重复"];
    }
    [self layoutTagviews];
}

#pragma mark - 删除标签
- (void)removeTag:(NSString *)tag {
    NSArray *result = [self.tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", tag]];
    if (result)
    {
        NSInteger index=[self.tagStrings indexOfObject:tag];
        [self.tagStrings removeObjectAtIndex:index];
        [self.tagButtons[index] removeFromSuperview];
        [self.tagButtons removeObjectAtIndex:index];
    }
    [self layoutTagviews];
}

- (XLKeywordButton *)tagButtonWithTag:(NSString *)tag {
    XLKeywordButton *button = [XLKeywordButton buttonWithType:(UIButtonTypeCustom)];
    button.selected = NO;
    [button setTitle:tag forState:(UIControlStateNormal)];
    CGRect btnFrame;
    btnFrame.size.height = _tagHeight;
    button.layer.cornerRadius = btnFrame.size.height * 0.5f;
    
    btnFrame.size.width = [tag sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + (_tagHeight);
    btnFrame.size.width = MIN(btnFrame.size.width, self.xl_w - 2 * LEFT);
    button.frame = btnFrame;
    [button addTarget:self action:@selector(handlerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleEdgeInsets:(UIEdgeInsetsMake(0, 14 * kWidthRatio6s, 0, 14 * kWidthRatio6s))];
    
    return button;
}

#pragma mark - 点击标签
- (void)handlerButtonAction:(XLKeywordButton *)tagButton {
    if (_delegate && [_delegate respondsToSelector:@selector(addkeywordView:didSelectedAtIndex:)]) {
        [_delegate addkeywordView:self didSelectedAtIndex:tagButton.tag - 1000];
    }
    return;
    if (tagButton.selected) {
        tagButton.selected = NO;
        self.tfInput.hidden = NO;
        self.selectedTag = nil;
    } else {
        self.tfInput.hidden = YES;
        for (XLKeywordButton *button in self.tagButtons) {
            button.selected = NO;
        }
        tagButton.selected = YES;
        self.selectedTag = [tagButton titleForState:(UIControlStateNormal)];
    }
    self.tfInput.text = nil;
}

#pragma mark - 点击空白删除
- (void)clickWhiteDelete {
    if (self.selectedTag) {
        [self removeTag:self.selectedTag];
        self.selectedTag = nil;
        self.tfInput.hidden = NO;
        self.tfInput.text = nil;
    } else if (self.tfInput.text.length == 0 && self.tagButtons.count > 0) {
        // 点亮最后一个标签
        [self handlerButtonAction:[self.tagButtons lastObject]];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    if (!textField.text
        || [textField.text isEqualToString:@""] || textField.hidden) {
        textField.text = nil;
        return NO;
    }
    [self addLastTag:textField.text];
    textField.text = nil;
    [self layoutTagviews];
    return NO;
}



- (void)textFieldDidChange:(UITextField*)textField {
    if (textField.hidden) {
        textField.text = nil;
    } else {
        [self layoutTagviews];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
//    NSString* sting2 = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    CGRect frame=_tfInput.frame;
//    frame.size.width = [sting2 sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + _tagHeight;
//    frame.size.width = MAX(frame.size.width, [self.placeholder sizeWithAttributes:@{NSFontAttributeName:_fontInput}].width + _tagHeight);
//
//    if (frame.size.width > self.scrollView.contentSize.width - 2 * LEFT) {
//        NSLog(@"!!!  _tfInput width tooooooooo large");
//        return NO;
//    } else {
//        return YES;
//    }
}

#pragma mark - XLNewsEditTextFieldProtocol
- (void)XLTextFieldDeleteBackward:(XLNewsEditTextField *)textField {
    // 点击空白删除按钮
    [self clickWhiteDelete];
}


#pragma mark - lazy load
- (NSMutableArray *)tagButtons {
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (NSMutableArray *)tagStrings {
    if (!_tagStrings) {
        _tagStrings = [NSMutableArray array];
    }
    return _tagStrings;
}

- (NSString *)placeholder {
    return XLArrayIsEmpty(self.tagButtons) ? @"录入关键字，请以回车键分隔" : @"关键字";
}

- (NSMutableArray *)tagsArr {
    NSMutableArray *arr = self.tagStrings;
    NSString *text = self.tfInput.text;
    if (!XLStringIsEmpty(text) && ![arr containsObject:text]) {
        [arr addObject:self.tfInput.text];
    }
    return arr;
}


@end
