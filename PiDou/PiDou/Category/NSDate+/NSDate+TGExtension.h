//
//  NSDate+TGExtension.h
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TGExtension)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
@property (nonatomic, readonly) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSInteger weekOfYear;
@property (nonatomic, readonly) BOOL isToday;
@property (nonatomic, readonly) BOOL isYesterday;
@property (nonatomic, readonly) BOOL isThisYear;
@property (nonatomic, readonly) BOOL isLeapYear; // 闰年

/**日期转时间*/
- (NSString *)stringFormat:(NSString *)format;

/**时间戳转日期*/
+ (NSDate *)dateWithMilliSecondsSince1970:(NSTimeInterval)milliseconds;
+ (NSDate *)dateWithSecondsSince1970:(NSTimeInterval)seconds;
/**时间转日期*/
+ (NSDate *)dateFromString:(NSString *)str format:(NSString *)format;
/**时间转日期yyyy-MM-dd HH:mm:ss*/
+ (NSDate *)dateWithLineFromString:(NSString *)str;

/**日期 - format - 转时间*/
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/**日期转时间 yyyy-MM-dd HH:mm:ss*/
+ (NSString *)stringWithLineFromDate:(NSDate *)date;
/**日期转时间 yyyy-MM-dd*/
+ (NSString *)stringWithSimpleLineFormDate:(NSDate *)date;

/**时间戳转时间 yyyy-MM-dd HH:mm:ss*/
+ (NSString *)stringWithLineFromTimestamp:(NSString *)time;
/**时间戳转时间 yyyy-MM-dd*/
+ (NSString *)stringWithSimpleLineFromTimestamp:(NSString *)time;

/**获得时间戳10位*/
+ (NSString *)timeSecondsSince1970;
/**获得时间戳13位*/
+ (NSString *)timeMilliSecondsSince1970;


/**相差几年*/
+ (NSInteger)numYearFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;
/**相差几月*/
+ (NSInteger)numMonthFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;
/**相差几日*/
+ (NSInteger)numDayFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;
/**相差几小时*/
+ (NSInteger)numHourFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;
/**相差几分*/
+ (NSInteger)numMinuteFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;
/**相差几秒*/
+ (NSInteger)numSecondFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;

/**当前日历*/
+ (NSCalendar *)currentCalendar;

/**一个月前的日期*/
+ (NSDate *)monthAgoDate:(NSDate *)date;
/**一天前的日期*/
+ (NSDate *)aDayAgoDate:(NSDate *)date;
/**是否是同一天*/
+ (BOOL)isSameDayFromDate:(NSDate *)fdate toDate:(NSDate *)tdate;

/**几年以后*/
- (NSDate *)dateByAddingYears:(NSInteger)years;
/**几月以后*/
- (NSDate *)dateByAddingMonths:(NSInteger)months;
/**几周以后*/
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
/**几天以后*/
- (NSDate *)dateByAddingDays:(NSInteger)days;
/**几小时以后*/
- (NSDate *)dateByAddingHours:(NSInteger)hours;
/**几分钟以后*/
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
/**几秒以后*/
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;


+ (NSString *)messageTimeWithMilliSecondsSince1970:(NSTimeInterval)milliseconds;

@end
