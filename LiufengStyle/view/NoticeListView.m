//
//  NoticeListView.m
//  LiufengStyle
//
//  Created by lfs on 15-1-8.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "NoticeListView.h"
#import "NoticeDetailViewController.h"
#import "NODataCell.h"

@interface NoticeListView ()

@end

@implementation NoticeListView
@synthesize pullTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.width) style:UITableViewStyleGrouped];
    //
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    
    //  self.pullTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // [self.pullTableView layoutSubviews];
    
    //self.pullTableView.rowHeight = 44.0f;
    
    //    self.pullTableView.
    //    frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-300);
    
    //self.pullTableView.contentSize=CGSizeMake(0,self.pullTableView.frame.size.height-300);
    
    
    
    UINib *cellNib = [UINib nibWithNibName:@"NoticeViewCell" bundle:nil];
    [self.pullTableView registerNib:cellNib forCellReuseIdentifier:NoticeCellIdentifier];
    
    UINib *noCellNib = [UINib nibWithNibName:@"NODataCell" bundle:nil];
    [self.pullTableView registerNib:noCellNib forCellReuseIdentifier:NoCellIdentifier];
    
    //   NoticeViewCell *c = [[[NSBundle mainBundle] loadNibNamed:@"NoticeViewCell" owner:self options:nil] objectAtIndex:0];
    // CGSize size = [c.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    // NSLog(@"h1=%f", size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNoticeNotification:) name:Notification_List object:nil];
    
    self.pullTableView.tableFooterView=[[UIView alloc]init];
    
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
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
    if([notices count]==0){
        return 1;
    }
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
    
    
    if([notices count] >0)
    {
        // NSLog(@"====log row: %d",indexPath.row);
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
    }else {
        NODataCell *nocell=[tableView dequeueReusableCellWithIdentifier:NoCellIdentifier];
        
        if(!nocell){
            nocell= [[[NSBundle mainBundle] loadNibNamed:@"NODataCell" owner:self options:nil] objectAtIndex:0];
        }
        return nocell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NoticeCellIdentifier];
    /*
     Notice *notice=[notices objectAtIndex:[indexPath row]];
     // NoticeViewCell *cell = (NoticeViewCell *)self.prototypeCell;
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
     */
    CGFloat height=cell.frame.size.height;
    if([notices count]>0) {
        NSInteger row=[indexPath row];
        
        if((row+1)==[notices count] && row >= 5) {
            height+=30;
        }
    }else {
        height=44;
    }
 
    return height;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([notices count] >0) {
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
    
}




#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    NSLog(@"下拉操作  获取历史的的已读的但当前页面未显示的信息......");
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
    NSLog(@"上拉操作  获取最新的未读的信息......");
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:1.0f];
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
