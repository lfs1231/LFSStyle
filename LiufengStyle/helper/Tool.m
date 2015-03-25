//
//  Tool.m
//  LiufengStyle
//
//  Created by lfs on 14-12-31.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "Tool.h"
#import "RegexKitLite.h"
#import <CommonCrypto/CommonDigest.h>
#import "SCLAlertView.h"

@implementation Tool


+ (void)clearWebViewBackground:(UIWebView *)webView
{
    UIWebView *web = webView;
    for (id v in web.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            [v setBounces:NO];
        }
    }
}


+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    
    //解析http://短链接
    NSString *regex_http =@"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    
    if ([array_http count]) {
        for (NSString *str in  array_http) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length)withString:funUrlStr];
        }
    }
    
    //解析@
    NSString *regex_at =@"@[\\u4e00-\\u9fa5\\w\\-]+";//@的正则表达式
    NSArray *array_at = [text componentsMatchedByRegex:regex_at];
    if ([array_at count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc]init];
        for (NSString *str in array_at) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            }
        }
        
    }
    
    
    //解析&
    NSString *regex_dot =@"\\$\\*?[\u4e00-\u9fa5|a-zA-Z|\\d]{2,8}(\\((SH|SZ)?\\d+\\))?";//&的正则表达式
    NSArray *array_dot = [text componentsMatchedByRegex:regex_dot];
    if ([array_dot count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc]init];
        for (NSString *str in array_dot) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            }
        }
        
    }
    
    //解析话题
    NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [text componentsMatchedByRegex:regex_pound];
    
    if ([array_pound count]) {
        for (NSString *str in array_pound) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=%@>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length])withString:funUrlStr];
        }
    }
    
    //解析表情
    NSString *regex_emoji =@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\]";//表情的正则表达式
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    NSString *filePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"emotionImage.plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    // NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                //NSString *imageHtml = [NSString stringWithFormat:@"<img src = 'file://%@/%@' width='12' height='12'>", path, i_transCharacter];
                NSString *imageHtml = [NSString stringWithFormat:@"<img src =%@>",  i_transCharacter];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
            }
        }
    }
    
    //返回转义后的字符串
    return text;
}

///显示进度条
+(void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud
{
    
    [view addSubview:hud];
    hud.labelText = text;
    //hud.dimBackground = YES;
    hud.square = YES;
    [hud show:YES];
    
}



//正则表达式替换
+(NSString*)replaceStr:(NSString*)regexPattern withReplacedStr:(NSString*)str withPlaceStr:(NSString*)pstr
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:nil];
    NSMutableString *mstr = [NSMutableString stringWithString:str];
    [regex replaceMatchesInString:mstr options:0 range:NSMakeRange(0, [mstr length]) withTemplate:pstr];
    return mstr;
}


//URLEncode
+(NSString*)encodeString:(NSString*)unencodedString
{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+(void) createUserDirectory:(NSString *)createDirectory
{
     NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 拼接一个文件夹路径
    NSURL *documentsDirectoryURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSString * filePath= [NSString stringWithFormat: @"%@%@", [documentsDirectoryURL absoluteString], createDirectory ];
    
    if(![fileManager fileExistsAtPath:filePath])
    {//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        // NSArray *paths = NSSearchPathForDerictoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        
        NSString *directryPath = [path stringByAppendingPathComponent:createDirectory];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];

    }
    

 }

//MD5加密字符串
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    
    const char *cStr = [srcString UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [result appendFormat:@"%02x", digest[i]];
    
    
    return result;
    
}

//Sha加密
+ (NSString *)getSha1String:(NSString *)srcString
{
    
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    CC_SHA1(data.bytes, data.length, digest);
    
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        
        [result appendFormat:@"%02x", digest[i]];
        
    }
    
    
    return result;
    
}

//得到文件名完整路径
+(NSString *) getDocFullFilePath:(NSString *)fileName andFileType:(NSString *)fileType andSaveDirectory:(NSString *) saveDirectory
{
   
    // 拼接一个文件夹路径
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSLog(@"保存路径:%@",documentsDirectoryPath);
    
    NSString * fullfilePath= [NSString stringWithFormat: @"%@/%@/%@.%@", documentsDirectoryPath, saveDirectory,[Tool getMd5_32Bit_String:fileName],fileType ];
    
   
    return fullfilePath;
}

//获取文件名
+(NSString *) getFileName:(NSString *)filePath
{
    // 从路径中获得完整的文件名（带后缀）
    NSString *exestr = [filePath lastPathComponent];
    
    //NSLog(@"%@",exestr);
    
    // 获得文件名（不带后缀）
    exestr = [exestr stringByDeletingPathExtension];
    
    return  exestr;
}

//获取文件类型
+(NSString *) getFileType:(NSString *)filePath
{
  return  [filePath pathExtension];
}


+(void)showSuccess:(id)invokeView andSuccessTitle:(NSString *)SuccessTitle andSubtitle:(NSString *)kSubtitle andActionBlock:(void (^)())sucessActionBlock
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
   
    [alert alertIsDismissed:sucessActionBlock];
    
    alert.soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/right_answer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    [alert showSuccess:invokeView title:SuccessTitle subTitle:kSubtitle closeButtonTitle:@"确认" duration:0.0f];
}

+(void)showError:(id)invokeView andTitle:(NSString *)title andSubTitle:(NSString *)subTitle
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert showError:invokeView title:title
            subTitle:subTitle
    closeButtonTitle:@"确认" duration:0.0f];
}

+(float) getIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version;
    
}

+(NSString *) getCurrentSystemDateStr
{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
    
    return timeString;
}


@end
