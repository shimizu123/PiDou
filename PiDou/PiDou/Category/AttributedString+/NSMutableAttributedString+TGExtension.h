//
//  NSMutableAttributedString+TGExtension.h
//  TG
//
//  Created by kevin on 28/7/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (TGExtension)

+ (NSMutableAttributedString *)getPlaceholderWithString:(NSString *)str color:(UIColor *)color font:(UIFont *)font;


/**
 回复

 @param name 回复的人
 @param sname 对谁回复
 @param text 回复内容
 @return 回复富文本
 */
+ (NSMutableAttributedString *)attributedStringReplyColorWithName:(NSString *)name sname:(NSString *)sname text:(NSString *)text;

+ (NSMutableAttributedString *)attributedStringReplyColorWithName:(NSString *)name sname:(NSString *)sname text:(NSString *)text gap:(CGFloat)gap;

+ (NSMutableAttributedString *)attributedStringReplyColorWithName:(NSString *)name text:(NSString *)text;


@end
