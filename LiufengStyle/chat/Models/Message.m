//
//  Message.m
//  SOSimpleChatDemo
//
//  Created by Artur Mkrtchyan on 6/3/14.
//  Copyright (c) 2014 SocialOjbects Software. All rights reserved.
//

#import "Message.h"
#import "UserDefaultsHelper.h"

@implementation Message
@synthesize attributes,text,date,fromMe,media,thumbnail,type;
@synthesize fromXmppUser,toXmppUser;

- (id)init
{
    if (self = [super init]) {
        self.date = [NSDate date];
    }
    
    return self;
}

@end
