//
//  XMPPHelper.h
//  LiufengStyle
//
//  Created by lfs on 15-2-10.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"

@interface XMPPHelper : NSObject <XMPPRosterDelegate>
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    NSString *password;
    
    BOOL customCertEvaluation;
    
    BOOL isXmppConnected;
    
    NSString *username;
    NSString *xmppDomain;

}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *xmppDomain;

@property (nonatomic) BOOL isXmppConnected;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;

//发送消息
- (void)sendMessage:(NSString *) newmessage toUser:(NSString *) user ;
/** 发送二进制文件 */
- (void)sendMessageWithData:(NSData *)data andMessageType:msgType toUser:(NSString *) touser;

+ (XMPPHelper *)sharedInstance;


//+(XMPPHelper *)initWithUser:(NSString *)_username andPasswd:(NSString *)_password andDomain:(NSString *)domain;

@end
