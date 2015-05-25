//
//  LBLocalPushHelper.m
//  LocationPush
//
//  Created by 乐播 on 13-9-12.
//  Copyright (c) 2013年 乐播. All rights reserved.
//

#import "LocalPushHelper.h"

@implementation LocalPushHelper

// 创建本地推送

+ (void)setLocationPushAtTimeWithHour:(int)hour minute:(int)minute second:(int)second pushMessage:(NSString *)pushMessage PushRepeatInterval:(PushRepeatInterval)pushRepeatInterval{
    // 先移除本地推送
    [LocalPushHelper removeLocalPush];
    
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    [components setHour:hour - components.hour];
    [components setMinute:minute - components.minute];
    [components setSecond:second - components.second];
    
    NSDate *pushDate = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    //    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    if (notification) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        if (pushRepeatInterval == CalendarUnitEra) {
            notification.repeatInterval = kCFCalendarUnitEra;
        }else if (pushRepeatInterval ==CalendarUnitYear ){
            notification.repeatInterval = kCFCalendarUnitYear;
        }else if (pushRepeatInterval == CalendarUnitMonth){
            notification.repeatInterval = kCFCalendarUnitMonth;
        }else if (pushRepeatInterval == CalendarUnitDay){
            notification.repeatInterval = kCFCalendarUnitDay;
        }else if (pushRepeatInterval == CalendarUnitHour){
            notification.repeatInterval = kCFCalendarUnitHour;
        }else if (pushRepeatInterval == CalendarUnitMinute){
            notification.repeatInterval = kCFCalendarUnitMinute;
        }else if (pushRepeatInterval == CalendarUnitSecond){
            notification.repeatInterval = kCFCalendarUnitSecond;
        }else if (pushRepeatInterval == CalendarUnitWeek){
            notification.repeatInterval = kCFCalendarUnitWeek;
        }else if (pushRepeatInterval == CalendarUnitWeekday){
            notification.repeatInterval = kCFCalendarUnitWeekday;
        }else if (pushRepeatInterval == CalendarUnitWeekdayOrdinal){
            notification.repeatInterval = kCFCalendarUnitWeekdayOrdinal;
        }else if (pushRepeatInterval == CalendarUnitQuarter){
            notification.repeatInterval = kCFCalendarUnitQuarter;
        }else if (pushRepeatInterval == CalendarUnitWeekOfMonth){
            notification.repeatInterval = kCFCalendarUnitWeekOfMonth;
        }else if (pushRepeatInterval == CalendarUnitWeekOfYear){
            notification.repeatInterval = kCFCalendarUnitWeekOfYear;
        }else if (pushRepeatInterval == CalendarUnitYearForWeekOfYear){
            notification.repeatInterval = kCFCalendarUnitYearForWeekOfYear;
        }
       
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = pushMessage;
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber ++;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"dailyTen"forKey:@"key1"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}


+ (void)setLocationPush{
    // 先移除本地推送
    [LocalPushHelper removeLocalPush];
    
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置10秒之后
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    [components setHour:19];
    [components setMinute: 0];
    [components setSecond: 0];
    
    NSDate *pushDate = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    //    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    if (notification) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitWeek;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容
        notification.alertBody = LocalPushMessage;
        //显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber ++;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"dailyTen"forKey:@"key1"];
        notification.userInfo = info;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
}

+ (BOOL)checkLocalPush{
    BOOL mm = NO;
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    UILocalNotification *localNotification = nil;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key1"];
                if ([inKey isEqualToString:@"dailyTen"]) {
                    if (localNotification){
                        localNotification = nil;
                    }
                    localNotification = noti;
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNotification) {
            mm = YES;
        }else{
            mm = NO;
        }
    }
        return mm;
}


//  第二步：解除本地推送
+ (void)removeLocalPush{
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    UILocalNotification *localNotification = nil;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key1"];
                if ([inKey isEqualToString:@"dailyTen"]) {
                    if (localNotification){
                        localNotification = nil;
                    }
                    localNotification = noti;
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (!localNotification) {
            //不存在初始化
//            localNotification = [[UILocalNotification alloc] init];
        }
        
        if (localNotification) {
            //不推送 取消推送
            [app cancelLocalNotification:localNotification];
            return;
        }
    }
    
}
@end
