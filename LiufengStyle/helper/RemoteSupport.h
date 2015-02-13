//
//  RemoteSupport.h
//  LiufengStyle
//
//  Created by lfs on 14-12-17.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RemoteSupport : NSObject

    //调用ws接口，返回字符串结果
+ (void)invokeWS:(NSString *)rurl andSoapMessage:(NSString *)soapMessage andNotificationName:(NSString *)postNotificationName ;

//下载一张图片
+(void) downloadAndShowImage:(NSString *)downloadImageURL andImage:(UIImageView *) imageView andFileName:(NSString *)fileName  andSaveDirectory:(NSString *) saveDirectory;

@end
