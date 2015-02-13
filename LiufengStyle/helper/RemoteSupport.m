//
//  RemoteSupport.m
//  LiufengStyle
//
//  Created by lfs on 14-12-17.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "RemoteSupport.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RemoteSupport


+ (void) invokeWS:(NSString *)rurl andSoapMessage:(NSString *)soapMessage andNotificationName:(NSString *)postNotificationName
{
    NSString *soapLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:rurl parameters:nil];
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        //获取数据，异步通知界面更新
        [[NSNotificationCenter defaultCenter] postNotificationName:postNotificationName object:[NSString stringWithFormat:@"%@", response]];
        
        // NSLog(@"%@, %@", operation, response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:postNotificationName object:[NSString stringWithFormat:@"%@", @"error"]];
        NSLog(@"%@, %@", operation, error);
    }];
    [manager.operationQueue addOperation:operation];
    
    
}

//下载一张图片
+(void) downloadAndShowImage:(NSString *)downloadImageURL andImage:(UIImageView *) imageView andFileName:(NSString *)fileName  andSaveDirectory:(NSString *) saveDirectory
{
 
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:downloadImageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSFileManager *fileManager= [NSFileManager defaultManager];
        
        // 拼接一个文件夹路径
        NSURL *documentsDirectoryURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSString * filePath= [NSString stringWithFormat: @"%@%@", [documentsDirectoryURL absoluteString], saveDirectory ];
        
               if(![fileManager fileExistsAtPath:filePath])
        {//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
            [Tool createUserDirectory:saveDirectory];
        }
        
       
        
        NSString * relativeFilePath= [NSString stringWithFormat:@"%@/%@.%@", saveDirectory, [Tool getMd5_32Bit_String:[Tool getFileName:fileName]] , [Tool getFileType:fileName]];
        
              // 根据网址信息拼接成一个完整的文件存储路径并返回给block
        return [documentsDirectoryURL URLByAppendingPathComponent:relativeFilePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
       // NSLog(@"File downloaded to: %@", [filePath path ]);
        
        NSData *dd = [NSData dataWithContentsOfFile:[filePath path]];
        
        imageView.image=[UIImage imageWithData:dd];
    }];
    [downloadTask resume];
    
    /*
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        _imageView.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    [NSOperationQueue mainQueue] addOperation:posterOperation];
    [posterOperation start];*/
}



+(void) uploadTask
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
}

+(void) uploadTaskMultiPart
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    
    [uploadTask resume];
}

@end

