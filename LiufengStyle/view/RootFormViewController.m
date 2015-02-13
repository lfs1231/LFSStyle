//
//  RootFormViewController.m
//  BasicExample
//
//  Created by Nick Lockwood on 25/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "RootFormViewController.h"
#import "RegistrationForm.h"
#import "WriteBlogForm.h"
#import "Tool.h"

@implementation RootFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.navigationItem.backBarButtonItem = cancelButton;}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //reload the table
    [self.tableView reloadData];
}


//these are action methods for our forms
//the methods escalate through the responder chain until
//they reach the AppDelegate

- (void)submitLoginForm
{
    //now we can display a form value in our alert
//    [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
   // [Tool showError:self andTitle:@"保存错误" andSubTitle:@"系统错误，请稍后重试"];
    [Tool showSuccess:self andSuccessTitle:@"成功" andSubtitle:@"保存成功" andActionBlock:^{
        NSLog(@"=====sucessfully =====");
    }];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    RegistrationForm *form = cell.field.form;
    
    //we can then perform validation, etc
    if (form.agreedToTerms)
    {
        [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"User Error" message:@"Please agree to the terms and conditions before proceeding" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes Sir!", nil] show];
    }
}

@end
