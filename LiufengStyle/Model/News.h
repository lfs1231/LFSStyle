//
//  News.h
//  LiufengStyle
//
//  Created by lfs on 15-1-26.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property  (copy,nonatomic) NSString * newsID;
@property int newsCTR;
@property  (copy,nonatomic) NSString *homePhotoURL;
@property  (copy,nonatomic) NSString *keywords;
@property  (copy,nonatomic) NSString *newsContent;
@property  (copy,nonatomic) NSString *newsTitle;
@property  (copy,nonatomic) NSDate *publishedTime;
@property  (copy,nonatomic) NSString *summary;

-(id)initWithParameters:(NSString *) newNewsID
             andNewsCTR:(int) newNewsCTR
            andKeywords:(NSString *)newKeywords
        andHomePhotoURL:(NSString *)newHomePhotoURL
         andNewsContent:(NSString *)newNewsContent
           andNewsTitle:(NSString *)newNewsTitle
       andPublishedTime:(NSDate *) newPublishedTime
             andSummary:(NSString *) newSummary;

-(id)initWithParameters:(NSString *) newNewsID
             andNewsCTR:(int) newNewsCTR
        andHomePhotoURL:(NSString *)newHomePhotoURL
           andNewsTitle:(NSString *)newNewsTitle
       andPublishedTime:(NSDate *) newPublishedTime
             andSummary:(NSString *) newSummary;




@end