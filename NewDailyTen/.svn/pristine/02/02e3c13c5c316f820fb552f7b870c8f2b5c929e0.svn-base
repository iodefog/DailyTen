//
//  LBLocalPushHelper.h
//  LocationPush
//
//  Created by 乐播 on 13-9-12.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CalendarUnitEra ,
    CalendarUnitYear,
    CalendarUnitMonth,
    CalendarUnitDay,
    CalendarUnitHour,
    CalendarUnitMinute,
    CalendarUnitSecond,
    CalendarUnitWeek ,
    CalendarUnitWeekday ,
    CalendarUnitWeekdayOrdinal,
    CalendarUnitQuarter ,
    CalendarUnitWeekOfMonth ,
    CalendarUnitWeekOfYear ,
    CalendarUnitYearForWeekOfYear,
}PushRepeatInterval;

@interface LocalPushHelper : NSObject
//  创建本地推送
+ (void)setLocationPush;
//  检查是否有推送
+ (BOOL)checkLocalPush;
//  定时推送
+ (void)setLocationPushAtTimeWithHour:(int)hour minute:(int)minute second:(int)second pushMessage:(NSString *)pushMessage PushRepeatInterval:(PushRepeatInterval)pushRepeatInterval;
//  第二步：解除本地推送
+ (void)removeLocalPush;

@end
