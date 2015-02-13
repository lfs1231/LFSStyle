//
//  DateUtil.m
//  LiufengStyle
//
//  Created by lfs on 14-12-29.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

//格式化日期
+(NSString*) formatDate:(NSDate *)inputDate{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                                         
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return[outputFormatter stringFromDate:inputDate];
}

//解析字符串为日期
+(NSDate*) parseDate:(NSString *)dateStr{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[NSLocale currentLocale]];

    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [inputFormatter dateFromString:dateStr];
}

@end
