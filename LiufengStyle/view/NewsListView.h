//
//  NewsListView.h
//  LiufengStyle
//
//  Created by lfs on 15-1-26.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "RemoteSupport.h"
#import "MBProgressHUD.h"
#import "DateUtil.h"
#import "GDataXMLNode.h"
#import "News.h"

@interface NewsListView : UIViewController <UITableViewDataSource, PullTableViewDelegate> {
    NSMutableArray * newsArray;
    int pageNumber;
    PullTableView *pullTableView;
}


@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;


//加载第几页的数据
-(void) turnPage:(int)currentPageNumber  andPagerows:(int)pagerows;

@end
