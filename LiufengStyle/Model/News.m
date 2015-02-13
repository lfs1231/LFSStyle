//
//  News.m
//  LiufengStyle
//
//  Created by lfs on 15-1-26.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "News.h"

@implementation News

@synthesize newsID;
@synthesize newsCTR;
@synthesize keywords;
@synthesize homePhotoURL;
@synthesize newsContent;
@synthesize newsTitle;
@synthesize publishedTime;
@synthesize summary;

-(id)initWithParameters:(NSString *) newNewsID
             andNewsCTR:(int) newNewsCTR
            andKeywords:(NSString *)newKeywords
        andHomePhotoURL:(NSString *)newHomePhotoURL
         andNewsContent:(NSString *)newNewsContent
           andNewsTitle:(NSString *)newNewsTitle
       andPublishedTime:(NSDate *) newPublishedTime
             andSummary:(NSString *) newSummary
{
    News *news=[[News alloc] init];
    news.newsID=newNewsID;
    news.newsCTR=newNewsCTR;
    news.keywords=newKeywords;
    news.homePhotoURL=newHomePhotoURL;
    news.newsContent=newNewsContent;
    news.newsTitle=newNewsTitle;
    news.publishedTime=newPublishedTime;
    news.summary=newSummary;
    
    return news;
}

-(id)initWithParameters:(NSString *) newNewsID
             andNewsCTR:(int) newNewsCTR
        andHomePhotoURL:(NSString *)newHomePhotoURL
           andNewsTitle:(NSString *)newNewsTitle
       andPublishedTime:(NSDate *) newPublishedTime
             andSummary:(NSString *) newSummary;
{
    News *news=[[News alloc] init];
    news.newsID=newNewsID;
    news.newsCTR=newNewsCTR;
    news.homePhotoURL=newHomePhotoURL;
    news.newsTitle=newNewsTitle;
    news.publishedTime=newPublishedTime;
    news.summary=newSummary;
    
    return news;

}

@end
