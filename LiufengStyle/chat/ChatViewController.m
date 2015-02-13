//
//  ChatViewController.m
//  LiufengStyle
//
//  Created by lfs on 15-2-6.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "MessageHelper.h"
#import "UserDefaultsHelper.h"
#import "QQViewController.h"
#import "DDLog.h"
#import "XMPPMessage.h"
#import "XMPPHelper.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface ChatViewController ()
@property (nonatomic,copy)NSString *fromUser;
@property (nonatomic,copy)NSString *toUser;

@end

@implementation ChatViewController
@synthesize fromUser,toUser;

- (void)buildConversation:(NSString *)newFromUser andToUser:(NSString *)newToUser
{
    fromUser=newFromUser;
    toUser=newToUser;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view.
    
    self.myImage      = [UIImage imageNamed:@"arturdev.jpg"];
    self.partnerImage = [UIImage imageNamed:@"jobs.jpg"];
    
    //[self loadMessages];
    self.dataSource =[[NSMutableArray alloc] initWithCapacity:100];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReceiveMessage:) name:RevXMPPMsgNotification object:nil];
    
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadMessages
{
    self.dataSource = [[[MessageHelper sharedMessageHelper]generateConversation] mutableCopy];
}

#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
    return 2 * 24 * 3600;
}



- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.dataSource[index];
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    } else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width/2;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
}

- (CGFloat)messageMaxWidth
{
    return 140;
}

- (CGSize)userImageSize
{
    return CGSizeMake(40, 40);
}

- (CGFloat)messageMinHeight
{
    return 0;
}
#pragma mark - SOMessaging delegate
- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    NSLog(@"===send message :%@",message);
    [[XMPPHelper sharedInstance] sendMessage:message toUser:toUser ];
    [self sendMessage:msg];
}


/*
 * 发送信息
 */
- (void)didSendTextAction:(ZBMessageTextView *)messageInputTextView{
    /*
    ZBMessage *message = [[ZBMessage alloc]initWithText:messageInputTextView.text sender:nil timestamp:[NSDate date]];
    [self sendMessage:message]; */
    NSString *message=messageInputTextView.text;
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    [self sendMessage:msg];
    NSLog(@"===send message :%@",message);
    [[XMPPHelper sharedInstance] sendMessage:message toUser:toUser ];
    
    
    [messageInputTextView setText:nil];
    [self inputTextViewDidChange:messageInputTextView];
}


- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}




- (void)handleReceiveMessage:(NSNotification *)notification
{
    NSLog(@"===handleReceiveMessage=====");
    if (notification.object) {
        Message * somMessage=(Message *)notification.object ;
        //NSLog(@"get return : %@",returnStr);
        
        [self receiveMessage:somMessage];
    }
    
}

@end
