//
//  NSMutableAttributedString+TGExtension.m
//  TG
//
//  Created by kevin on 28/7/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "NSMutableAttributedString+TGExtension.h"

@implementation NSMutableAttributedString (TGExtension)

+ (NSMutableAttributedString *)getPlaceholderWithString:(NSString *)str color:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:str];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, str.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:font
                        range:NSMakeRange(0, str.length)];
    return placeholder;
}


+ (NSMutableAttributedString *)attributedStringReplyColorWithName:(NSString *)name sname:(NSString *)sname text:(NSString *)text {
    NSString *content = [NSString string];
    content = [NSMutableString stringWithFormat:@"%@回复%@: %@",name,sname,text];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:content];
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_BLACK range:NSMakeRange(0, content.length)];
    NSRange nameRange = NSMakeRange([[mString string] rangeOfString:name].location, [[mString string] rangeOfString:name].length);
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_GRAY range:nameRange];
    
    NSString *ssname = [NSString stringWithFormat:@"%@:",sname];
    NSRange snameRange = NSMakeRange([[mString string] rangeOfString:ssname].location, [[mString string] rangeOfString:ssname].length);
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_GRAY range:snameRange];
    
    
    return mString;
}

+ (NSMutableAttributedString *)attributedStringReplyColorWithName:(NSString *)name sname:(NSString *)sname text:(NSString *)text gap:(CGFloat)gap {
    NSString *content = [NSString string];
    content = [NSMutableString stringWithFormat:@"%@回复%@: %@",name,sname,text];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:content];
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_BLACK range:NSMakeRange(0, content.length)];
    NSRange nameRange = NSMakeRange([[mString string] rangeOfString:name].location, [[mString string] rangeOfString:name].length);
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_GRAY range:nameRange];
    
    NSString *ssname = [NSString stringWithFormat:@"%@:",sname];
    NSRange snameRange = NSMakeRange([[mString string] rangeOfString:ssname].location, [[mString string] rangeOfString:ssname].length - 1);
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_GRAY range:snameRange];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:gap];
    [mString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    
    return mString;
}

+ (NSMutableAttributedString *)attributedStringReplyColorWithName:(NSString *)name text:(NSString *)text {
    if (XLStringIsEmpty(text)) {
        text = @" ";
    }
    NSString *content = [NSString string];
    content = [NSMutableString stringWithFormat:@"%@: %@",name,text];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:content];
    [mString addAttribute:NSForegroundColorAttributeName value:XL_COLOR_BLACK range:NSMakeRange(0, content.length)];
    NSRange nameRange = NSMakeRange([[mString string] rangeOfString:name].location, [[mString string] rangeOfString:name].length);
    [mString addAttribute:NSForegroundColorAttributeName value:COLOR(0x497ECC) range:nameRange];
    
    
    
    return mString;
}

@end
