//
//  Tool.h
//  LiufengStyle
//
//  Created by lfs on 14-12-31.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

//WebView的背景颜色去除
+ (void)clearWebViewBackground:(UIWebView *)webView; 

+ (NSString *)transformString:(NSString *)originalStr;

///显示进度条
+(void)showHUD:(NSString *)text andView:(UIView *)view andHUD:(MBProgressHUD *)hud;


//正则表达式替换
+(NSString*)replaceStr:(NSString*)regexPattern withReplacedStr:(NSString*)str withPlaceStr:(NSString*)pstr;

//URLEncode
+(NSString*)encodeString:(NSString*)unencodedString;



//URLDEcode
-(NSString *)decodeString:(NSString*)encodedString;

//创建目录
+(void) createUserDirectory:(NSString *)createDirectory;

//MD5加密字符串
+(NSString *)getMd5_32Bit_String:(NSString *)srcString;

//Sha加密
+(NSString *)getSha1String:(NSString *)srcString;


//得到文件名完整路径
+(NSString *) getDocFullFilePath:(NSString *)fileName andFileType:(NSString *)fileType andSaveDirectory:(NSString *) saveDirectory;

//获取文件名
+(NSString *) getFileName:(NSString *)filePath;

//获取文件类型
+(NSString *) getFileType:(NSString *)filePath;

//错误提示框
+(void)showError:(id)invokeView andTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

+(void)showSuccess:(id)invokeView andSuccessTitle:(NSString *)SuccessTitle andSubtitle:(NSString *)kSubtitle andActionBlock:(void (^)())sucessActionBlock;

//得到系统版本
+(float) getIOSVersion;

//得到当前时间戳
+(NSString *) getCurrentSystemDateStr;

@end
