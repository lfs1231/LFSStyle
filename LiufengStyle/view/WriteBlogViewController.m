//
//  WriteBlogViewController.m
//  LiufengStyle
//
//  Created by lfs on 15-2-3.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "WriteBlogViewController.h"
#import "WriteBlogForm.h"

@interface WriteBlogViewController ()

@end

@implementation WriteBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:writeBlogController];

    
    // Do any additional setup after loading the view from its nib.
    //set up form and form controller
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[WriteBlogForm alloc] init];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      
                                      initWithTitle:@"刷新"
                                      
                                      style:UIBarButtonItemStylePlain
                                      
                                      target:self
                                      
                                      action:nil];
    
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     
                                     initWithTitle:@"撤退"
                                     
                                     style:UIBarButtonItemStylePlain
                                     
                                     target:self
                                     
                                     action:nil];
    
    self.navigationItem.backBarButtonItem = cancelButton;
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //reload the table
    [self.tableView reloadData];
}

- (void)submitBlogForm
{
    //now we can display a form value in our alert
    [[[UIAlertView alloc] initWithTitle:@"Blog Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

@end
