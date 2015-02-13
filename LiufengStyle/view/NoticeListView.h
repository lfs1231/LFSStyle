//
//  NoticeListView.h
//  LiufengStyle
//
//  Created by lfs on 15-1-8.
//  Copyright (c) 2015年 lfs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Notice.h"
#import "NoticeViewCell.h"
#import "PullTableView.h"
#import "RemoteSupport.h"
#import "MBProgressHUD.h"
#import "DateUtil.h"
#import "GDataXMLNode.h"


@interface NoticeListView : UIViewController <UITableViewDataSource, PullTableViewDelegate>{
    NSMutableArray * notices;
    int pageNumber;
    
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    PullTableView *pullTableView;
    
    
    BOOL _reloading;

}


@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;


//加载第几页的数据
-(void) turnPage:(int)currentPageNumber  andPagerows:(int)pagerows;

//清空
- (void)clear;


@end
