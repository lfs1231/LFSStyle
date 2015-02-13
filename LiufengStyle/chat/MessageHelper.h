//
//  MessageHelper.h
//  LiufengStyle
//
//  Created by lfs on 15-2-6.
//  Copyright (c) 2015年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject

+ (MessageHelper *)sharedMessageHelper;
- (NSArray *)generateConversation;
@end
