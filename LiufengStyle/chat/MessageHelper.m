//
//  MessageHelper.m
//  LiufengStyle
//
//  Created by lfs on 15-2-6.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import "MessageHelper.h"
#import "Message.h"
#import "SOMessageType.h"

@implementation MessageHelper


+ (MessageHelper *)sharedMessageHelper
{
    static MessageHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    
    return helper;
}

- (NSArray *)generateConversation
{
    NSMutableArray *result = [NSMutableArray new];
    NSArray *data = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Conversation" ofType:@"plist"]]];
    for (NSDictionary *msg in data) {
        Message *message = [[Message alloc] init];
        message.fromMe = [msg[@"fromMe"] boolValue];
        message.text = msg[@"message"];
        message.type = [self messageTypeFromString:msg[@"type"]];
        message.date = [NSDate date];
        
        int index = (int)[data indexOfObject:msg];
        if (index > 0) {
            Message *prevMesage = result.lastObject;
            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
        }
        
        if (message.type == SOMessageTypePhoto) {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
        } else if (message.type == SOMessageTypeVideo) {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
        }
        
        [result addObject:message];
    }
    
    return result;
}

- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }
    
    return SOMessageTypeOther;
}

@end
