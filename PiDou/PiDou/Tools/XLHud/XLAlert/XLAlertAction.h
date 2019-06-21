//
//  XLAlertAction.h
//  CBNReporterVideo
//
//  Created by kevin on 10/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    /**
     * 默认样式
     * plain默认系统蓝色
     * 其它样式默认黑色字体 RGB都为51
     */
    XLAlertActionStyleDefault,
    
    /** 红色字体 */
    XLAlertActionStyleDestructive,
    
    /** 灰色字体 RGB都为153 */
    XLAlertActionStyleCancel,
    
} XLAlertActionStyle;
@interface XLAlertAction : NSObject


/** attributedTitle */
@property (nonatomic, strong, readonly) NSAttributedString *attributedTitle;

/** title */
@property (nonatomic, copy, readonly) NSString *title;

/** handler */
@property (nonatomic, copy, readonly) void (^handler)(XLAlertAction *action);

/** normalImage */
@property (nonatomic, strong) UIImage *normalImage;

/** hightlightedImage */
@property (nonatomic, strong) UIImage *hightlightedImage;

/**
 * 是否是空的action
 * 以上5个属性都为nil时即为空的action
 * 空action在非plain样式以外，点击将没有任何反应
 */
@property (nonatomic, assign, readonly) BOOL isEmpty;

/** 样式 */
@property (nonatomic, assign, readonly) XLAlertActionStyle alertActionStyle;

/** actionSheet样式cell高度 */
@property (nonatomic, assign, readonly) CGFloat rowHeight;

/** 是否隐藏分隔线 */
@property (nonatomic, assign) BOOL separatorLineHidden;

/** titleColor 默认nil */
@property (nonatomic, strong) UIColor *titleColor;

/** 设置titleColor 默认nil */
@property (nonatomic, copy, readonly) XLAlertAction *(^setTitleColor)(UIColor *color);

/** titleFont 默认nil  */
@property (nonatomic, strong) UIFont *titleFont;

/** 设置titleFont 默认nil */
@property (nonatomic, copy, readonly) XLAlertAction *(^setTitleFont)(UIFont *font);

/**
 * 自定义的view
 * 注意要自己计算好frame
 * action.customView将会自动适应宽度，所以frame给出高度即可
 * actionSheet样式的行高rowHeight将取决于action.customView的高度
 * 自定义时请将action.customView视为一个容器view
 * 推荐使用自动布局在action.customView约束子控件
 */
@property (nonatomic, strong) UIView *customView;

/**
 * 设置自定义的view
 * 注意要自己计算好frame
 * action.customView将会自动适应宽度，所以frame给出高度即可
 * actionSheet样式的行高rowHeight将取决于action.customView的高度
 * 自定义时请将action.customView视为一个容器view
 * 推荐使用自动布局在action.customView约束子控件
 */
@property (nonatomic, copy, readonly) XLAlertAction *(^setCustomView)(UIView *(^customView)(void));

/** 设置普通状态图片 */
@property (nonatomic, copy, readonly) XLAlertAction *(^setNormalImage)(UIImage *image);

/** 设置高亮状态图片 */
@property (nonatomic, copy, readonly) XLAlertAction *(^setHightlightedImage)(UIImage *image);

/** 设置是否隐藏分隔线 */
@property (nonatomic, copy, readonly) XLAlertAction *(^setSeparatorLineHidden)(BOOL hidden);

/**
 * 实例化action
 * title: 标题
 * style: 样式
 * handler: 点击的操作
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(XLAlertActionStyle)style handler:(void(^)(XLAlertAction *action))handler;

/**
 * 链式实例化action
 * title: 标题
 * style: 样式
 * handler: 点击的操作
 */
+ (XLAlertAction *(^)(NSString *title, XLAlertActionStyle style, void(^handler)(XLAlertAction *action)))action;

/**
 * 实例化action
 * attributedTitle: 富文本标题
 * style: 样式
 * handler: 点击的操作
 */
+ (instancetype)actionWithAttributedTitle:(NSAttributedString *)attributedTitle handler:(void(^)(XLAlertAction *action))handler;

/**
 * 链式实例化action
 * attributedTitle: 富文本标题
 * style: 样式
 * handler: 点击的操作
 */
+ (XLAlertAction *(^)(NSAttributedString *attributedTitle, void(^handler)(XLAlertAction *action)))actionAttributed;

@end
