//
//  HomePageViewController.h
//  IMApp
//
//  Created by chen on 14/7/20.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPPHelper.h"


@interface MainTabViewController : QHBasicViewController

@property (nonatomic, strong) XMPPHelper *xmppHelper;

+ (MainTabViewController *)getMain;

@end
