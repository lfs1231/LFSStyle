//
//  NewsListView.m
//  LiufengStyle
//
//  Created by lfs on 15-1-26.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "NewsListView.h"
#import "NewsViewCell.h"
#import "NODataCell.h"
#import "NewsDetailView.h"
#import "Tool.h"

@interface NewsListView ()

@end

@implementation NewsListView
@synthesize pullTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    
//    CGRect newFrame=CGRectMake(0, 0,
//                               [QHSliderViewController sharedSliderController].view.frame.size.width, [QHSliderViewController sharedSliderController].view.frame.size.height);
//    self.view.frame=newFrame;
//    self.pullTableView.frame=newFrame;
//
//    NSLog(@"===pulltable width1: %f",self.view.frame.size.width);
//    NSLog(@"===pulltable width2: %f",self.pullTableView.frame.size.width);
    
    UINib *cellNib = [UINib nibWithNibName:@"NewsViewCell" bundle:nil];
    [self.pullTableView registerNib:cellNib forCellReuseIdentifier:NoticeCellIdentifier];
    
    UINib *noCellNib = [UINib nibWithNibName:@"NODataCell" bundle:nil];
    [self.pullTableView registerNib:noCellNib forCellReuseIdentifier:NoCellIdentifier];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNoticeNotification:) name:News_List object:nil];
    
    self.pullTableView.tableFooterView=[[UIView alloc]init];
    
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    
}

- (void)handleNoticeNotification:(NSNotification *)notification
{
    if (notification.object) {
        NSString* returnStr=(NSString *)notification.object ;
        //NSLog(@"get return : %@",returnStr);
        [self parseNewsByStr:returnStr];
    }
    
    [self.pullTableView reloadData];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1.0f];
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
    
    
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
    
    //初始化
    [self clear];
    [self turnPage:1 andPagerows:[PAGE_ROW_NUMBER intValue]];
    
}

- (void) loadMoreDataToTable
{
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
      if([newsArray count]==0){
        return 1;
    }
    return [newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([newsArray count] >0)
    {
        
        NewsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
        
        if(!cell){
            cell= [[[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil] objectAtIndex:0];
            
//            NSLog(@"===WIDTH: %f",self.parentViewController.view.frame.size.width);
//            CGRect newFrame=CGRectMake(0, 0, self.parentViewController.view.frame.size.width, 100);
//            cell.frame=newFrame;
           
        }
       
        
        // UIFont *font= [UIFont fontWithName:@"Arial" size:12];
        cell.newsTitle.font=[UIFont boldSystemFontOfSize:15.0];
        cell.newsTitle.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
        News *news=[newsArray objectAtIndex:[indexPath row]];
        cell.newsTitle.text=news.newsTitle;
        cell.newsCTR.text=[NSString stringWithFormat:@"点击数:%d",news.newsCTR];
        cell.publishedTime.text=[DateUtil formatDate:news.publishedTime];
        cell.summary.text=news.summary;
        
        //处理图片
        NSString *baicURL=FILE_SHOW_URL;
        NSString *fileName=[Tool encodeString:news.homePhotoURL];
        NSString *paramURL=[@"?fileType=newsHome&size=small&imagePath=" stringByAppendingString:fileName];
  
        NSString *url=[baicURL stringByAppendingString:paramURL];
        
        
        NSFileManager *fileManager= [NSFileManager defaultManager];
        
        NSString *fullPath=[Tool getDocFullFilePath:[Tool getFileName:news.homePhotoURL] andFileType:[Tool getFileType:news.homePhotoURL]  andSaveDirectory:@"Liufeng"];
   
        if([fileManager fileExistsAtPath:fullPath]){
          
            cell.homePhotoURL.image=[UIImage imageWithContentsOfFile:fullPath];
        }else {
           
            [RemoteSupport downloadAndShowImage:url andImage:cell.homePhotoURL andFileName:news.homePhotoURL andSaveDirectory:@"Liufeng"];
            
        }
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
       
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
    NewsViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    
    
    [cell layoutSubviews];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
     //NSLog(@"===cell width2=%f",cell.frame.size.width);
    //CGFloat height=cell.frame.size.height;
     // NSLog(@"h2=%f", height);
    if([newsArray count]>0) {
        NSInteger row=[indexPath row];
        
        if((row+1)==[newsArray count] && row >= 5) {
            height+=30;
        }
        
    }else {
        height=44;
    }
    
    
    
    
    return height+100;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([newsArray count] >0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        int row = [indexPath row];
        News *n = [newsArray objectAtIndex:row];
        
        if (n)
        {
            
            NewsDetailView  *newsDetailView = [[NewsDetailView alloc] initWithNibName:@"NewsDetailView" bundle:nil];
            
            
            
            [ [[QHSliderViewController sharedSliderController] navigationController] pushViewController:newsDetailView animated:YES];
            
        }
    }
    
}




#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:1.0f];
}

- (void)clear
{
    pageNumber=1; //从第1页开始
    [newsArray removeAllObjects];
    
}

//加载第几页的数据
-(void) turnPage:(int)currentPageNumber  andPagerows:(int)pagerows
{
    
    NSString *rurl =[NSString stringWithFormat:@"%@/%@",WS_BASIC_URL,@"services/NewsWebService"];
    
    NSString *soapMessage=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:com=\"http://com.ibm.yncmcc.mobile\"><soapenv:Header/><soapenv:Body><com:findLatestNews><com:arg0>%d</com:arg0><com:arg1>%d</com:arg1></com:findLatestNews></soapenv:Body></soapenv:Envelope>",pagerows,currentPageNumber];
    
    //第一页
    if(currentPageNumber==1) {
        newsArray = [[NSMutableArray alloc] initWithCapacity:[PAGE_ROW_NUMBER intValue]];
    }
    
    [RemoteSupport invokeWS:rurl andSoapMessage:soapMessage andNotificationName:News_List];
}


//解析XML，构造news对象（多个）
-(void) parseNewsByStr:(NSString *)str
{
    NSError *error;
    GDataXMLDocument *gdataXML=[[GDataXMLDocument alloc]initWithXMLString:str options:0 error:&error];
    
    GDataXMLElement* rootElement = [gdataXML rootElement];
    
    GDataXMLElement* soapBody =  [[rootElement elementsForName:@"soap:Body"] objectAtIndex:0];
    GDataXMLElement* findLatestNewsResponse =  [[soapBody elementsForName:@"ns2:findLatestNewsResponse"] objectAtIndex:0];
    
    NSArray *array=[findLatestNewsResponse elementsForName:@"YNCMCCReturn"];
   
    for (GDataXMLElement* itemEle2 in array) {
        GDataXMLElement* homePhotoURL =  [[itemEle2 elementsForName:@"homePhotoURL"] objectAtIndex:0];
        GDataXMLElement* keywords =  [[itemEle2 elementsForName:@"keywords"] objectAtIndex:0];
        GDataXMLElement* newsCTR = [[itemEle2 elementsForName:@"newsCTR"] objectAtIndex:0];
        GDataXMLElement* newsTitle = [[itemEle2 elementsForName:@"newsTitle"] objectAtIndex:0];
        
        GDataXMLElement* newsID = [[itemEle2 elementsForName:@"newsID"] objectAtIndex:0];
        GDataXMLElement* publishedTime = [[itemEle2 elementsForName:@"publishedTime"] objectAtIndex:0];
        GDataXMLElement* publisher = [[itemEle2 elementsForName:@"publisher"] objectAtIndex:0];
        GDataXMLElement* summary = [[itemEle2 elementsForName:@"summary"] objectAtIndex:0];
        
        
        NSString *newsCTRStr=newsCTR.stringValue;
        News *news=[[News alloc] initWithParameters:newsID.stringValue andNewsCTR:[newsCTRStr intValue] andHomePhotoURL:homePhotoURL.stringValue andNewsTitle:newsTitle.stringValue andPublishedTime:[DateUtil parseDate:publishedTime.stringValue] andSummary:summary.stringValue];
        
        
        [newsArray addObject:news];
        
    }
    NSLog(@"news: %lu",(unsigned long)[newsArray count]);
    
}

@end
