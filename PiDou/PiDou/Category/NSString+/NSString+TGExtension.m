//
//  NSString+TGExtension.m
//  TG
//
//  Created by kevin on 4/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "NSString+TGExtension.h"

@implementation NSString (TGExtension)

- (NSString *)stringWithFormat:(NSString *)format formOtherFormat:(NSString *)otherFormat {
    NSDate *date = [NSDate dateFromString:self format:otherFormat];
    return [NSDate stringWithDate:date format:format];
}

- (NSString *)stringWithDianFormat {
    return [self stringWithFormat:@"yyyy.MM.dd" formOtherFormat:@"yyyy-MM-dd HH:mm:ss"];
}


#pragma mark - 获取label的高度
+ (CGRect)getRectWithText:(NSString *)text width:(CGFloat)width gap:(CGFloat)gap size:(CGFloat)size {
    
    UIFont *fnt = [UIFont systemFontOfSize:size];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (gap > 0) {
        [paragraphStyle setLineSpacing:gap];
    }
    
    CGRect labelRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil];
    return labelRect;
}

#pragma mark - 获取label的宽度
+ (CGRect)getRectWithText:(NSString *)text height:(CGFloat)height gap:(CGFloat)gap size:(CGFloat)size {
    
    UIFont *fnt = [UIFont systemFontOfSize:size];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (gap > 0) {
        [paragraphStyle setLineSpacing:gap];
    }
    
    CGRect labelRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil] context:nil];
    return labelRect;
}

+ (NSString *)tg_stringWithLineString:(NSString *)time {
    NSDate *date = [NSDate dateWithLineFromString:time];
    NSString *str = @"";
    if (date.isToday) {
        NSInteger h = [NSDate numHourFromDate:date toDate:[NSDate date]];
        NSInteger m = [NSDate numMinuteFromDate:date toDate:[NSDate date]];
        NSInteger s = [NSDate numSecondFromDate:date toDate:[NSDate date]];
        
        if (h > 0) {
            str = [NSString stringWithFormat:@"%ld小时前",h];
        } else if (m > 0) {
            str = [NSString stringWithFormat:@"%ld分钟前",m];
        } else if (s > 0) {
            str = [NSString stringWithFormat:@"%ld秒前",s];
        } else {
            str = [NSString stringWithFormat:@"1秒前"];
        }
    } else if (date.isYesterday) {
        str = [NSString stringWithFormat:@"%@",[time stringWithFormat:@"昨天  HH:mm" formOtherFormat:@"yyyy-MM-dd HH:mm:ss"]];
    } else if (date.isThisYear) {
        str = [NSString stringWithFormat:@"%@",[time stringWithFormat:@"MM-dd  HH:mm" formOtherFormat:@"yyyy-MM-dd HH:mm:ss"]];
    } else {
        str = [NSString stringWithFormat:@"%@",[time stringWithFormat:@"yyyy-MM-dd  HH:mm" formOtherFormat:@"yyyy-MM-dd HH:mm:ss"]];
    }
    return str;
}

@end
