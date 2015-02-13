//
//  Notice.h
//  LiufengStyle
//
//  Created by lfs on 14-12-17.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

@property  (copy,nonatomic) NSString * noticeID;
@property int noticeCTR;
@property (copy,nonatomic) NSString * keyword;
@property (copy,nonatomic) NSString * noticeTitle;
@property (copy,nonatomic) NSDate * publishedTime;
@property (copy,nonatomic) NSDate * disabledTime;
@property (copy,nonatomic) NSString * summary;
@property (copy,nonatomic) NSString * noticeContent;

- (id)initWithParameters:(NSString *)newNoticeID
            andNoticeCTR:(int)newNoticeCTR
              andKeyword:(NSString *)newKeyword
                andTitle:(NSString *)newNoticeTitle
        andPublishedTime:(NSDate *)newPublishedTime
         andDisabledTime:(NSDate *)newDisabledTime
              andSummary:(NSString *)newSummary;


- (id)initWithParameters:(NSString *)newNoticeID
            andNoticeCTR:(int)newNoticeCTR
                andTitle:(NSString *)newNoticeTitle
        andnoticeContent:(NSString *)newNoticeContent;

@end
