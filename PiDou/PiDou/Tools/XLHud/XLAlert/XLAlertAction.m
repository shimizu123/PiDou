//
//  XLAlertAction.m
//  CBNReporterVideo
//
//  Created by kevin on 10/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLAlertAction.h"

@interface XLAlertAction () {
    CGFloat _rowHeight;
}

@end

@implementation XLAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(XLAlertActionStyle)style handler:(void(^)(XLAlertAction *action))handler {
    
    XLAlertAction *action = [[XLAlertAction alloc] init];
    
    action->_title = [title copy];
    action->_handler = handler;
    action->_alertActionStyle = style;
    
    return action;
}

/**
 * 链式实例化action
 * title: 标题
 * style: 样式
 * handler: 点击的操作
 */
+ (XLAlertAction *(^)(NSString *title, XLAlertActionStyle style, void(^handler)(XLAlertAction *action)))action {
    
    return ^(NSString *title, XLAlertActionStyle style, void(^handler)(XLAlertAction *action)){
        
        return [XLAlertAction actionWithTitle:title style:style handler:handler];
    };
}

+ (instancetype)actionWithAttributedTitle:(NSAttributedString *)attributedTitle handler:(void(^)(XLAlertAction *action))handler {
    
    XLAlertAction *action = [[XLAlertAction alloc] init];
    
    action->_attributedTitle = attributedTitle;
    action->_handler = handler;
    action->_alertActionStyle = XLAlertActionStyleDefault;
    
    return action;
}

/**
 * 链式实例化action
 * attributedTitle: 富文本标题
 * style: 样式
 * handler: 点击的操作
 */
+ (XLAlertAction *(^)(NSAttributedString *attributedTitle, void(^handler)(XLAlertAction *action)))actionAttributed {
    
    return ^(NSAttributedString *attributedTitle, void(^handler)(XLAlertAction *action)){
        
        return [XLAlertAction actionWithAttributedTitle:attributedTitle handler:handler];
    };
}

- (instancetype)init{
    if (self = [super init]) {
        
        [self initialization];
    }
    return self;
}

- (void)initialization{
    
    _rowHeight = -1;
    _separatorLineHidden = NO;
}

- (XLAlertAction *(^)(UIColor *color))setTitleColor {
    
    return ^(UIColor *color){
        
        self.titleColor = color;
        
        return self;
    };
}

- (XLAlertAction *(^)(UIFont *font))setTitleFont {
    
    return ^(UIFont *font){
        
        self.titleFont = font;
        
        return self;
    };
}

- (XLAlertAction *(^)(UIImage *image))setNormalImage {
    
    return ^(UIImage *image){
        
        self.normalImage = image;
        
        return self;
    };
}

- (XLAlertAction *(^)(UIImage *image))setHightlightedImage {
    
    return ^(UIImage *image){
        
        self.hightlightedImage = image;
        
        return self;
    };
}

/** 设置是否隐藏分隔线 */
- (XLAlertAction *(^)(BOOL hidden))setSeparatorLineHidden {
    
    return ^(BOOL hidden){
        
        self.separatorLineHidden = hidden;
        
        return self;
    };
}

/**
 * 设置自定义的view
 * 注意要自己计算好frame
 * action.customView将会自动适应宽度，所以frame给出高度即可
 * actionSheet样式的行高rowHeight将取决于action.customView的高度
 * 自定义时请将action.customView视为一个容器view
 * 推荐使用自动布局在action.customView约束子控件
 */
- (XLAlertAction *(^)(UIView *(^customView)(void)))setCustomView {
    
    return ^(UIView *(^customView)(void)){
        
        self.customView = !customView ? nil : customView();
        
        return self;
    };
}

- (BOOL)isEmpty {
    
    return self.title == nil &&
    self.attributedTitle == nil &&
    self.handler == nil &&
    self.normalImage == nil &&
    self.hightlightedImage == nil;
}

- (CGFloat)rowHeight {
    
    if (_rowHeight < 0) {
        
        _rowHeight = self.customView ? self.customView.frame.size.height : (([UIScreen mainScreen].bounds.size.width > 321) ? 53 : 46);
    }
    return _rowHeight;
}

@end
