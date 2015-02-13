//
//  NoticeViewController.m
//  LiufengStyle
//
//  Created by lfs on 14-12-24.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeDetailViewController.h"


@interface NoticeViewController ()

@end


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation NoticeViewController
@synthesize pullTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.pullTableView = [[PullTableView alloc] init];
    self.pullTableView.dataSource = self;
    self.pullTableView.delegate=self;
    self.pullTableView.pullDelegate = self;
    
    
    [self.view addSubview:pullTableView];
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    
    UINib *cellNib = [UINib nibWithNibName:@"NoticeViewCell" bundle:nil];
    [self.pullTableView registerNib:cellNib forCellReuseIdentifier:NoticeCellIdentifier];
    self.prototypeCell  = [self.pullTableView dequeueReusableCellWithIdentifier:NoticeCellIdentifier];
    
    NoticeViewCell *c = [[[NSBundle mainBundle] loadNibNamed:@"NoticeViewCell" owner:self options:nil] objectAtIndex:0];
    
    CGSize size = [c.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"h1=%f", size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNoticeNotification:) name:Notification_List object:nil];
    
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)handleNoticeNotification:(NSNotification *)notification
{
    if (notification.object) {
        NSString* returnStr=(NSString *)notification.object ;
        //NSLog(@"get return : %@",returnStr);
        [self parseNoticeByStr:returnStr];
    }
    
    [self.pullTableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
    }
}

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
  
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
    
    //初始化
    [self clear];
    [self turnPage:1 andPagerows:[PAGE_ROW_NUMBER intValue]];
    
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    self.pullTableView.pullTableIsLoadingMore = NO;
    pageNumber++;
    [self turnPage:pageNumber andPagerows:[PAGE_ROW_NUMBER intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notices count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *cellIdentifier = @"Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if(!cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
     cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row];
     */
    
    NSLog(@"cell===");
    if([notices count] >0)
    {
        
        NoticeViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NoticeCellIdentifier];
        
        if(!cell){
            cell= [[[NSBundle mainBundle] loadNibNamed:@"NoticeViewCell" owner:self options:nil] objectAtIndex:0];
        }
       
        
       // UIFont *font= [UIFont fontWithName:@"Arial" size:12];
        cell.noticeTitle.font=[UIFont boldSystemFontOfSize:15.0];
        cell.noticeTitle.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
        Notice *notice=[notices objectAtIndex:[indexPath row]];
        cell.noticeTitle.text=notice.noticeTitle;
       // cell.keyword.text=notice.keyword;
        //cell.noticeCTR.font=font;
        //cell.publishedTime.font=font;
        cell.noticeCTR.text=[NSString stringWithFormat:@"点击数%d",notice.noticeCTR];
        cell.publishedTime.text=[DateUtil formatDate:notice.publishedTime];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
//        CGSize size = [cell.noticeTitle.text sizeWithFont:cell.noticeTitle.font constrainedToSize:CGSizeMake(cell.noticeTitle.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        //根据计算结果重新设置UILabel的尺寸
//        [cell.noticeTitle setFrame:CGRectMake(0, 10, cell.noticeTitle.frame.size.width, size.height)];
//    
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   // NoticeViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NoticeCellIdentifier];
    
    Notice *notice=[notices objectAtIndex:[indexPath row]];
       NSLog(@"dsfsdf: %@",notice.noticeTitle);
    
    NoticeViewCell *cell = (NoticeViewCell *)self.prototypeCell;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.noticeTitle.translatesAutoresizingMaskIntoConstraints = NO;
    cell.noticeTitle.translatesAutoresizingMaskIntoConstraints = NO;
    cell.noticeTitle.text=notice.noticeTitle;
    
    cell.noticeCTR.translatesAutoresizingMaskIntoConstraints = NO;
    cell.noticeCTR.translatesAutoresizingMaskIntoConstraints = NO;

    cell.publishedTime.translatesAutoresizingMaskIntoConstraints = NO;
    cell.publishedTime.translatesAutoresizingMaskIntoConstraints = NO;
    
    cell.noticeCTR.text=[NSString stringWithFormat:@"点击数%d",notice.noticeCTR];
    cell.publishedTime.text=[DateUtil formatDate:notice.publishedTime];
   
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"h2=%f", size.height + 1);
    return 100  + size.height;
       
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 C1 *cell = (C1 *)self.prototypeCell;
 cell.t.text = [self.tableData objectAtIndex:indexPath.row];
 CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
 NSLog(@"h=%f", size.height + 1);
 return 1  + size.height;
 }
 */
/*
 - (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return [NSString stringWithFormat:@"Section %i begins here!", section];
 }
 
 - (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
 {
 return [NSString stringWithFormat:@"Section %i ends here!", section];
 
 }*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    Notice *n = [notices objectAtIndex:row];
    
    if (n)
    {
        
        NoticeDetailViewController *noticeDetailController = [[NoticeDetailViewController alloc] initWithNibName:@"NoticeDetailViewController" bundle:nil];
        
      
        noticeDetailController.noticeID=n.noticeID;
        noticeDetailController.noticeTitleStr= n.noticeTitle;
        noticeDetailController.noticeCTRStr=[NSString stringWithFormat:@"%d",n.noticeCTR];
        noticeDetailController.publishedTimeStr=[DateUtil formatDate:n.publishedTime];
        
       [ [[QHSliderViewController sharedSliderController] navigationController] pushViewController:noticeDetailController animated:YES];
        
    }
    
}




#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    NSLog(@"下拉操作  获取历史的的已读的但当前页面未显示的信息......");
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
    NSLog(@"上拉操作  获取最新的未读的信息......");
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

- (void)clear
{
    pageNumber=1; //从第1页开始
    [notices removeAllObjects];
    isLoadOver=NO;
}

//加载第几页的数据
-(void) turnPage:(int)currentPageNumber  andPagerows:(int)pagerows
{
    
    NSString *rurl =[NSString stringWithFormat:@"%@/%@",WS_BASIC_URL,@"services/NotifyWebService"];
    
    NSString *soapMessage=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:com=\"http://com.ibm.yncmcc.mobile\"><soapenv:Header/><soapenv:Body><com:findLatestNotices><com:arg0>%d</com:arg0><com:arg1>%d</com:arg1></com:findLatestNotices></soapenv:Body></soapenv:Envelope>",pagerows,currentPageNumber];
    
    //第一页
    if(currentPageNumber==1) {
        notices = [[NSMutableArray alloc] initWithCapacity:[PAGE_ROW_NUMBER intValue]];
    }
    
    [RemoteSupport invokeWS:rurl andSoapMessage:soapMessage andNotificationName:Notification_List];
}


//解析XML，构造notice对象（多个）
-(void) parseNoticeByStr:(NSString *)str
{
    NSError *error;
    GDataXMLDocument *gdataXML=[[GDataXMLDocument alloc]initWithXMLString:str options:0 error:&error];
    NSArray *array=[gdataXML nodesForXPath:@"/soap:Envelope/soap:Body" error:&error];
    
    for (GDataXMLElement* itemEle in array) {
        NSArray *array1=[itemEle elementsForName:@"ns2:findLatestNoticesResponse"];
        for (GDataXMLElement* itemEle1 in array1) {
            NSArray *array2=[itemEle1 elementsForName:@"YNCMCCReturn"];
            for (GDataXMLElement* itemEle2 in array2) {
                
                GDataXMLElement* idEle =  [[itemEle2 elementsForName:@"id"] objectAtIndex:0];
                GDataXMLElement* keywork =  [[itemEle2 elementsForName:@"keywork"] objectAtIndex:0];
                GDataXMLElement* noticeCTR = [[itemEle2 elementsForName:@"noticeCTR"] objectAtIndex:0];
                
                GDataXMLElement* noticeTitle = [[itemEle2 elementsForName:@"noticeTitle"] objectAtIndex:0];
                GDataXMLElement* publishedTime = [[itemEle2 elementsForName:@"publishedTime"] objectAtIndex:0];
                GDataXMLElement* disabledTime = [[itemEle2 elementsForName:@"disabledTime"] objectAtIndex:0];
                GDataXMLElement* summary = [[itemEle2 elementsForName:@"summary"] objectAtIndex:0];
                
                NSString *noticeCTRStr=noticeCTR.stringValue;
                
                Notice *notice= [[Notice alloc] initWithParameters:idEle.stringValue andNoticeCTR:[noticeCTRStr intValue] andKeyword:keywork.stringValue andTitle:noticeTitle.stringValue andPublishedTime:[DateUtil parseDate:publishedTime.stringValue] andDisabledTime:[DateUtil parseDate:disabledTime.stringValue] andSummary:summary.stringValue];
                
                [notices addObject:notice];
                
            }
            
        }
        
    }
    NSLog(@"notices: %lu",(unsigned long)[notices count]);
    
}


@end
