//
//  ChatViewController.h
//  LiufengStyle
//
//  Created by lfs on 15-2-6.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMessagingViewController.h"
#import "XMPPHelper.h"

@interface ChatViewController : SOMessagingViewController


@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;


- (void)buildConversation:(NSString *)newFromUser andToUser:(NSString *)newToUser;


@end
