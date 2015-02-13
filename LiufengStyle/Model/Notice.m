//
//  Notice.m
//  LiufengStyle
//
//  Created by lfs on 14-12-17.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "Notice.h"

@implementation Notice

@synthesize noticeID;
@synthesize noticeCTR;
@synthesize keyword;
@synthesize noticeTitle;
@synthesize publishedTime;
@synthesize disabledTime;
@synthesize summary;
@synthesize noticeContent;

- (id)initWithParameters:(NSString *)newNoticeID
            andNoticeCTR:(int)newNoticeCTR
              andKeyword:(NSString *)newKeyword
                andTitle:(NSString *)newNoticeTitle
        andPublishedTime:(NSDate *)newPublishedTime
         andDisabledTime:(NSDate *)newDisabledTime
              andSummary:(NSString *)newSummary
{
    Notice *n=[[Notice alloc] init];
    n.noticeID=newNoticeID;
    n.noticeCTR=newNoticeCTR;
    n.keyword=newKeyword;
    n.noticeTitle=newNoticeTitle;
    n.publishedTime=newPublishedTime;
    n.disabledTime=newDisabledTime;
    n.summary=newSummary;
    
    return n;
}

- (id)initWithParameters:(NSString *)newNoticeID
            andNoticeCTR:(int)newNoticeCTR
                andTitle:(NSString *)newNoticeTitle
        andnoticeContent:(NSString *)newNoticeContent
{
    Notice *n=[[Notice alloc] init];
    n.noticeID=newNoticeID;
    n.noticeCTR=newNoticeCTR;
    n.noticeTitle=newNoticeTitle;
    n.noticeContent=newNoticeContent;
    return n;
}

@end
