//
//  NoticeDetailViewController.h
//  LiufengStyle
//
//  Created by lfs on 14-12-30.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteSupport.h"
#import "GDataXMLNode.h"
#import "Notice.h"
#import "Tool.h"


@interface NoticeDetailViewController : UIViewController<UIWebViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeCTRLabel;

@property (weak, nonatomic) IBOutlet UIWebView *noticeContentWebView;

@property (copy,nonatomic) NSString *noticeID;
@property (copy,nonatomic) NSString *noticeTitleStr;
@property (copy,nonatomic) NSString *noticeCTRStr;
@property (copy,nonatomic) NSString *publishedTimeStr;

- (IBAction)returnMain:(id)sender;

@property(strong, nonatomic) MBProgressHUD *hud ;


@end
