//
//  Mp3EncodeClient.h
//  Mp3EncodeDemo
//
//  Created by hejinlai on 13-6-24.
//  Copyright (c) 2013年 yunzhisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"
#import "Mp3EncodeOperation.h"

@interface Mp3EncodeClient : NSObject
{
    Recorder *recorder;
    NSMutableArray *recordingQueue;
    Mp3EncodeOperation *mp3EncodeOperation;
    NSOperationQueue *opetaionQueue;
}
@property (nonatomic, copy) NSString *audioPath; ////得到录制的音频文件路径

- (void)start;

- (void)stop;


@end
