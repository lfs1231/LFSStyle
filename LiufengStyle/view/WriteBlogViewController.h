//
//  WriteBlogViewController.h
//  LiufengStyle
//
//  Created by lfs on 15-2-3.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface WriteBlogViewController : UIViewController<FXFormControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

@end
