//
//  DateUtil.h
//  LiufengStyle
//
//  Created by lfs on 14-12-29.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateUtil : NSObject

//格式化日期
+(NSString*) formatDate:(NSDate *)inputDate;

//解析字符串为日期
+(NSDate*) parseDate:(NSString *)dateStr;

@end
