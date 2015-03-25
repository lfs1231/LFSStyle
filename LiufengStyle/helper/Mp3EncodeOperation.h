//
//  Mp3EncodeOperation.h
//  Mp3EncodeDemo
//
//  Created by hejinlai on 13-6-24.
//  Copyright (c) 2013年 yunzhisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mp3EncodeOperation : NSOperation{
    
}

@property (nonatomic, assign) BOOL setToStopped;
@property (nonatomic, assign) NSMutableArray *recordQueue;
@property (nonatomic, copy) NSString *audioPath; //返回录音文件的路径



@end
