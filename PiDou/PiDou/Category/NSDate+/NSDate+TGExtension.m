//
//  NSDate+TGExtension.m
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "NSDate+TGExtension.h"


@implementation NSDate (TGExtension)

- (NSString *)stringFormat:(NSString *)format {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}


+ (NSDate *)dateWithMilliSecondsSince1970:(NSTimeInterval)milliseconds {
    return [[NSDate alloc] initWithTimeIntervalSince1970:milliseconds / 1000];
}
+ (NSDate *)dateWithSecondsSince1970:(NSTimeInterval)seconds {
    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

+ (NSDate *)dateFromString:(NSString *)str format:(NSString *)format {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:str];
}

/**时间转日期yyyy-MM-dd HH:mm:ss*/
+ (NSDate *)dateWithLineFromString:(NSString *)str {
    return [self dateFromString:str format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithLineFromDate:(NSDate *)date {
    return [NSDate stringWithDate:date format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)stringWithSimpleLineFormDate:(NSDate *)date {
    return [NSDate stringWithDate:date format:@"yyyy-MM-dd"];
}

+ (NSString *)stringWithLineFromTimestamp:(NSString *)time {
    NSDate* date = [NSDate dateWithMilliSecondsSince1970:[time doubleValue]];
    return [self stringWithLineFromDate:date];
}

+ (NSString *)stringWithSimpleLineFromTimestamp:(NSString *)time {
    NSDate* date = [NSDate dateWithMilliSecondsSince1970:[time doubleValue]];
    return [self stringWithSimpleLineFormDate:date];
}

+ (NSString *)timeSecondsSince1970 {
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
}
/**获得时间戳13位*/
+ (NSString *)timeMilliSecondsSince1970 {
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970] * 1000];
}

+ (NSInteger)numYearFromDate:(NSDate *)sDate toDate:(NSDate *)eDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear fromDate:sDate toDate:eDate options:0];
    return [comps year];
}

+ (NSInteger)numMonthFromDate:(NSDate *)sDate toDate:(NSDate *)eDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitMonth fromDate:sDate toDate:eDate options:0];
    return [comps month];
}

+ (NSInteger)numDayFromDate:(NSDate *)sDate toDate:(NSDate *)eDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay fromDate:sDate toDate:eDate options:0];
    return [comps day];
}

+ (NSInteger)numHourFromDate:(NSDate *)sDate toDate:(NSDate *)eDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitHour fromDate:sDate toDate:eDate options:0];
    return [comps hour];
}

+ (NSInteger)numMinuteFromDate:(NSDate *)sDate toDate:(NSDate *)eDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitMinute fromDate:sDate toDate:eDate options:0];
    return [comps minute];
}

+ (NSInteger)numSecondFromDate:(NSDate *)sDate toDate:(NSDate *)eDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitSecond fromDate:sDate toDate:eDate options:0];
    return [comps second];
}

+ (NSCalendar *)currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

+ (NSDate *)monthAgoDate:(NSDate *)date {
    return [date dateByAddingMonths:-1];
}

+ (NSDate *)aDayAgoDate:(NSDate *)date {
    return [date dateByAddingDays:-1];
}

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}
- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}
- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}
- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}
- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}
- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}



+ (BOOL)isSameDayFromDate:(NSDate *)fdate toDate:(NSDate *)tdate {
    return
    (fdate.year == tdate.year) &&
    (fdate.month == tdate.month) &&
    (fdate.day == tdate.day);
}

/**是否为闰年*/
- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}
/**是否为昨天*/
- (BOOL)isYesterday {
    NSDate *yesterday = [NSDate aDayAgoDate:[NSDate date]];
    return [NSDate isSameDayFromDate:self toDate:yesterday];
}
/**是否为今年*/
- (BOOL)isThisYear {
    NSInteger thisYear = [NSDate date].year;
    return thisYear == self.year;
}


/**几年以后*/
- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**几月以后*/
- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**几周以后*/
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
/**几天以后*/
- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/**几小时以后*/
- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/**几分钟以后*/
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
/**几秒以后*/
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSString *)messageTimeWithMilliSecondsSince1970:(NSTimeInterval)milliseconds {
    NSDate *date = [NSDate dateWithSecondsSince1970:milliseconds];
    NSString *formatter = @"HH:mm";
    if (date.isToday) {
        formatter = @"HH:mm";
    } else if (date.isThisYear) {
        formatter = @"MM-dd";
    } else {
        formatter = @"yyyy-MM-dd";
    }
    return [NSDate stringWithDate:date format:formatter];
}

@end
