//
//  NoticeDetailViewController.m
//  LiufengStyle
//
//  Created by lfs on 14-12-30.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "NoticeDetailViewController.h"


@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController
@synthesize noticeTitleLabel;
@synthesize publishedTimeLabel;
@synthesize noticeCTRLabel;
@synthesize noticeContentWebView;

@synthesize noticeID;
@synthesize noticeTitleStr;
@synthesize noticeCTRStr;
@synthesize publishedTimeStr;

@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.noticeTitleLabel.text=noticeTitleStr;
    self.publishedTimeLabel.text=publishedTimeStr;
    self.noticeCTRLabel.text=noticeCTRStr;
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNoticeDetailNotification:) name:Notification_Detail object:nil];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在加载..." andView:self.view andHUD:self.hud];
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.1f];
    
    [Tool clearWebViewBackground:self.noticeContentWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
     [self.noticeContentWebView stopLoading];
    
}

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
       //初始化
    [self getNotice:self.noticeID];
    
}


#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    if ([request.URL.absoluteString isEqualToString:@"about:blank"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)handleNoticeDetailNotification:(NSNotification *)notification
{
     [hud hide:YES];
    if (notification.object) {
        NSString* returnStr=(NSString *)notification.object ;
        //NSLog(@"=======get return : %@",returnStr);
        Notice *notice=[self parseNoticeDetailByStr:returnStr];
        [self.noticeContentWebView loadHTMLString:notice.noticeContent  baseURL:nil];
        
      
        
    }
    
}



-(void)getNotice:(NSString *)newNoticeID
{
    NSString *rurl =[NSString stringWithFormat:@"%@/%@",WS_BASIC_URL,@"services/NotifyWebService"];
    
    NSString *soapMessage=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:com=\"http://com.ibm.yncmcc.mobile\"><soapenv:Header/><soapenv:Body><com:getNotice><arg0>%@</arg0></com:getNotice></soapenv:Body></soapenv:Envelope>",newNoticeID];
    
    [RemoteSupport invokeWS:rurl andSoapMessage:soapMessage andNotificationName:Notification_Detail];
}

//解析XML，构造notice对象（多个）
-(Notice *) parseNoticeDetailByStr:(NSString *)str
{
    NSError *error;
    GDataXMLDocument *gdataXML=[[GDataXMLDocument alloc]initWithXMLString:str options:0 error:&error];
    NSArray *array=[gdataXML nodesForXPath:@"/soap:Envelope/soap:Body" error:&error];
    
    for (GDataXMLElement* itemEle in array) {
        NSArray *array1=[itemEle elementsForName:@"ns2:getNoticeResponse"];
        for (GDataXMLElement* itemEle1 in array1) {
            NSArray *array2=[itemEle1 elementsForName:@"YNCMCCReturn"];
            for (GDataXMLElement* itemEle2 in array2) {
                
                GDataXMLElement* idEle =  [[itemEle2 elementsForName:@"id"] objectAtIndex:0];
                GDataXMLElement* noticeTitle =  [[itemEle2 elementsForName:@"noticeTitle"] objectAtIndex:0];
                GDataXMLElement* noticeCTR = [[itemEle2 elementsForName:@"noticeCTR"] objectAtIndex:0];
                GDataXMLElement* noticeContent = [[itemEle2 elementsForName:@"noticeContent"] objectAtIndex:0];
                
                NSString *noticeCTRStr=noticeCTR.stringValue;
                
                Notice *newNotice= [[Notice alloc] initWithParameters:idEle.stringValue andNoticeCTR:[noticeCTRStr intValue] andTitle:noticeTitle.stringValue andnoticeContent:noticeContent.stringValue];
                
                
                return newNotice;
                
            }
            
        }
        
    }
    return nil;
    
}

- (IBAction)returnMain:(id)sender {
    [[[QHSliderViewController sharedSliderController] navigationController] popViewControllerAnimated:YES];

}

- (void)webViewDidFinishLoad:(UIWebView *)wb
{
    //方法1
    CGFloat documentWidth = [[wb stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
    CGFloat documentHeight = [[wb stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
    
    //方法2
    CGRect frame = wb.frame;
    frame.size.width = 768;
    frame.size.height = 1;
    
    //  wb.scrollView.scrollEnabled = NO;
    wb.frame = frame;
    
    frame.size.height = wb.scrollView.contentSize.height;
    
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    wb.frame = frame;
}
@end
