//
//  NoticeViewCell.h
//  LiufengStyle
//
//  Created by lfs on 14-12-27.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
@property (weak, nonatomic) IBOutlet UILabel *keyword;
@property (weak, nonatomic) IBOutlet UILabel *noticeCTR;

@property (weak, nonatomic) IBOutlet UILabel *publishedTime;

@end
