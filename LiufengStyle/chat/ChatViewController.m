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
#import "Mp3EncodeClient.h"
#import "QHSliderViewController.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface ChatViewController()
{
    Mp3EncodeClient *mp3EncodeClient;
    
}
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendAudioMessage:) name:SendAudioMsgNotification object:nil];
    
    
    mp3EncodeClient = [[Mp3EncodeClient alloc] init];
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

//deprecated delete
- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    NSLog(@"===send  213123123 messageInputView message :%@",message);
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
    
    NSLog(@"===send text=====");
    [self buildTextMessage:message];

    
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


#pragma mark - ZBMessageInputViewDelegate Delegate

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction
{
    NSLog(@"start recording =====");
    [mp3EncodeClient start];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction
{
    NSLog(@"stop recording =====");
    [mp3EncodeClient stop];
    
    
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction
{
    NSLog(@"stop recording ==2===");
    //[mp3EncodeClient stop];
    
}



-(void) sendAudioMessage:(NSNotification *)notification
{
    
    if (notification.object) {
        NSString * audioFilePath=(NSString *)notification.object ;
        
        NSLog(@"===send audio message file path:%@",audioFilePath);
        //构造信息
        Message *message = [self buildMediaMessage:YES andFile:audioFilePath  andMsgType:@"SOMessageTypeAudio"];
        
        [self sendMessage:message];
        NSLog(@"===send sendAudioMessage message :%@",message);
    }
    
}

#pragma end



#pragma mark - ZBMessageShareMenuView Delegate
- (void)didSelecteShareMenuItem:(ZBMessageShareMenuItem *)shareMenuItem atIndex:(NSInteger)index
{
    if (self.imagePicker == nil)
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        // self.imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = YES;
        
    }
    
    
    if(index==0)
    {
        
        //设置图片源(相簿)
        UIImagePickerController * newimagePicker = [[UIImagePickerController alloc] init];
        newimagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        newimagePicker.allowsEditing = YES;
        newimagePicker.delegate = self;
        
        
        //打开拾取器界面
        [[[QHSliderViewController sharedSliderController] navigationController]  presentViewController:newimagePicker   animated:YES completion:^{
            
            newimagePicker.delegate = self;
            NSLog(@"_imagePicker.delegate2 = %@",newimagePicker.delegate);
        }];
        
        
    }else if(index == 1)
    {
        
        // Make sure camera is available
        if ([UIImagePickerController
             isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Camera Unavailable"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
            self.imagePicker.delegate = self;
        }];
        
    } else {
        NSLog(@"==System can't support the selection===");
    }
    
}

//完成选择图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self buildPhotoMessage:image];
    
}



- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}




#pragma end


- (Message *) buildMediaMessage:(BOOL) isFromMe andFile:(NSString *)filepath andMsgType:(NSString *)msgType
{
    Message *message = [[Message alloc] init];
    message.fromMe = isFromMe ;
    message.type =[self messageTypeFromString:msgType];
    message.date = [NSDate date];
    
    if (message.type == SOMessageTypePhoto) {
        message.media = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:filepath], 1);
    } else if (message.type == SOMessageTypeVideo) {
        message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filepath ofType:@"mp4"]];
        message.thumbnail = [UIImage imageNamed:@"lion"];
    }else if (message.type == SOMessageTypeAudio) {
        message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filepath ofType:@"mp3"]];
        message.type = SOMessageTypeVideo;
        message.thumbnail = [UIImage imageNamed:@"lion"];
    }
    
    return message;
}

- (Message *) buildTextMessage: (NSString *) txmessage
{
    
    Message *message = [[Message alloc] init];
    message.type=SOMessageTypeText;
    message.text = txmessage;
    message.fromMe = YES;
    message.fromXmppUser=self.fromUser;
    message.toXmppUser=self.toUser;
    
    [self sendMessage:message];
     NSLog(@"===send didSendTextAction message :%@",txmessage);
    
    [[XMPPHelper sharedInstance] sendMessage:txmessage toUser:toUser ];
    
    return message;
}

- (Message *) buildPhotoMessage: (UIImage *) image
{
    Message *message = [[Message alloc] init];
    message.fromMe = YES ;
    message.type = SOMessageTypePhoto;
    message.date = [NSDate date];
    message.media = UIImageJPEGRepresentation(image, 1);
    message.fromXmppUser=self.fromUser;
    message.toXmppUser=self.toUser;
    
   [self sendMessage:message];
    
    NSLog(@"===send didSendTextAction message :%@",message);
    [[XMPPHelper sharedInstance] sendMessageWithData:message.media andMessageType:@"SOMessageTypePhoto" toUser:message.toXmppUser];
   
    return message;
}

- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }else if ([string isEqualToString:@"SOMessageTypeAudio"]) {
        return SOMessageTypeAudio;
    }
    
    return SOMessageTypeOther;
}

@end
