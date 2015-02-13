//
//  Message.h
//  SOSimpleChatDemo
//
//  Created by Artur Mkrtchyan on 6/3/14.
//  Copyright (c) 2014 SocialOjbects Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMessage.h"
#import "XMPPMessage.h"
#import "XMPPUserCoreDataStorageObject.h"

@interface Message : NSObject <SOMessage>

@property (nonatomic, strong) NSString *fromXmppUser;
@property (nonatomic, strong) NSString *toXmppUser;

@end
