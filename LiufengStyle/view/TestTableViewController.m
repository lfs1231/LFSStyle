//
//  TestTableViewController.m
//  LiufengStyle
//
//  Created by lfs on 14-12-31.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "TestTableViewController.h"
#import "C1.h"
#import "RootFormViewController.h"

@interface TestTableViewController ()

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.tableData = @[@"1\n2\n3\n4\n5\n6", @"123456789012345678901234567890", @"1\n2", @"1\n2\n3", @"1"];
    
    UINib *cellNib = [UINib nibWithNibName:@"C1" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"C1"];
    self.prototypeCell  = [self.tableView dequeueReusableCellWithIdentifier:@"C1"];
    
    C1 *c = [[[NSBundle mainBundle] loadNibNamed:@"C1" owner:self options:nil] objectAtIndex:0];
    
    CGSize size = [c.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
   // NSLog(@"h=%f", size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    C1 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"C1"];
    cell.t.text = [self.tableData objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    C1 *cell = (C1 *)self.prototypeCell;
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.t.translatesAutoresizingMaskIntoConstraints = NO;
    cell.i.translatesAutoresizingMaskIntoConstraints = NO;
    cell.t.text = [self.tableData objectAtIndex:indexPath.row];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    //NSLog(@"h=%f", size.height + 1);
    return 1  + size.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RootFormViewController * writeBlogController=[[RootFormViewController alloc] init];
 
   // [self.navigationController pushViewController:writeBlogController animated:YES];
    
  //  NSLog(@"=====self=2%@",self.navigationController);
//     self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RootFormViewController alloc] init]];
    //[self addChildViewController:navController];
      [[QHSliderViewController sharedSliderController] navigationController].navigationBarHidden=NO;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"注销";
    [[QHSliderViewController sharedSliderController] navigationController].navigationItem.backBarButtonItem = backItem;
    
    
 [ [[QHSliderViewController sharedSliderController] navigationController] pushViewController:writeBlogController animated:YES];
    
}
@end
