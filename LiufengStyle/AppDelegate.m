//
//  AppDelegate.m
//  LiufengStyle
//
//  Created by lfs on 14-12-2.
//  Copyright (c) 2014年 lfs. All rights reserved.
//

#import "AppDelegate.h"
#import "MainAppViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "WriteBlogViewController.h"
#import "RootFormViewController.h"
#import "Tool.h"
#import  "MLBlackTransition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //推送的形式：标记，声音，提示
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    
  
    //判断程序是不是由推送服务完成的
    if (launchOptions) {
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        //获取推送详情
        NSString *pushInfoStr = [NSString stringWithFormat:@"%@",[pushInfo  objectForKey:@"aps"]];
    
    }
    
    
    // iOS8注册本地通知
    float version=[Tool getIOSVersion];
    if (version >=8.0) {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
            
        {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
            
        }

    }
    
    
                              //设置 UserAgent
    //    [ASIHTTPRequest setDefaultUserAgentString:[NSString stringWithFormat:@"%@/%@", [Tool getOSVersion], [Config Instance].getIOSGuid]];
    //
    //显示系统托盘
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //检查网络是否存在 如果不存在 则弹出提示
    //    [Config Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    //
    //    NSLog(@"isNetworkRunning: %s", [Config Instance].isNetworkRunning ? "TRUE":"FALSE" );
    //
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
     [MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypePan];
    
    LeftViewController *leftVC = [[LeftViewController alloc] init];
    [leftVC.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.75, [UIScreen mainScreen].bounds.size.height)];
    [QHSliderViewController sharedSliderController].LeftVC = leftVC;
    RightViewController *rightVC = [[RightViewController alloc] init];
    [QHSliderViewController sharedSliderController].RightVC = rightVC;
    [QHSliderViewController sharedSliderController].finishShowRight = ^()
    {
        [rightVC headPhotoAnimation];
    };
    [QHSliderViewController sharedSliderController].MainVC = [[MainAppViewController alloc] init];
    
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:[QHSliderViewController sharedSliderController]];
    naviC.navigationBarHidden=YES;
    
    self.window.rootViewController = naviC;
    
    //    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RootFormViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
    
    
    
}

- (void)application:(UIApplication*)application

didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken

{
    
    NSLog(@"设备令牌: %@", deviceToken);
    
    NSString *tokeStr = [NSString stringWithFormat:@"%@",deviceToken];
    
    if ([tokeStr length] == 0) {
        
        return;
        
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\<\>"];
    
    tokeStr = [tokeStr stringByTrimmingCharactersInSet:set];
    
  //  tokeStr = [tokeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //保存只服务器
    
}

- (void)application:(UIApplication*)application

didFailToRegisterForRemoteNotificationsWithError:(NSError*)error

{
    
    NSLog(@"获得令牌失败: %@", error);
    
}



                              //app已经运行（或者被切换至后台），则在方法didReceiveRemoteNotification中进行调用。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    // 处理推送消息
    
    NSLog(@"userinfo:%@",userInfo);
    
    
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
