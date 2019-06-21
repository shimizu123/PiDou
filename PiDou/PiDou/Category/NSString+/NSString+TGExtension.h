//
//  NSString+TGExtension.h
//  TG
//
//  Created by kevin on 4/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TGExtension)

- (NSString *)stringWithFormat:(NSString *)format formOtherFormat:(NSString *)otherFormat;

/**yyyy-MM-dd HH:mm:ss -> yyyy.MM.dd*/
- (NSString *)stringWithDianFormat;


/**
 *  根据文本计算高度
 *
 *  @param text  内容
 *  @param width 固定宽度
 *  @param gap   文字间间距
 *  @param size  字体大小
 *
 *  @return rect
 */
+ (CGRect)getRectWithText:(NSString *)text width:(CGFloat)width gap:(CGFloat)gap size:(CGFloat)size;

/**
 *  根据文本计算宽度
 *
 *  @param text  内容
 *  @param height 固定高度
 *  @param gap   文字间间距
 *  @param size  字体大小
 *
 *  @return rect
 */
+ (CGRect)getRectWithText:(NSString *)text height:(CGFloat)height gap:(CGFloat)gap size:(CGFloat)size;

+ (NSString *)tg_stringWithLineString:(NSString *)time;

@end
