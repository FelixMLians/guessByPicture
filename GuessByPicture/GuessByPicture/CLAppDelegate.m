//
//  CLAppDelegate.m
//  GuessByPicture
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 Felix M Lannister. All rights reserved.
//
#define kAppKey @"801515573"
#define kAppSecret @"e8620b6d72e116afd9d20f290816367c"
#define kRedirectURI @"http://www.qq.com"

#import "CLAppDelegate.h"
#import "CLIntroViewController.h"

@implementation CLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    CLIntroViewController *intro=[[CLIntroViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:intro];
    
    self.window.rootViewController=nav;
    nav.navigationBar.translucent=NO;
    
    //腾讯微博注册
    if(self->wbapi == nil)
    {
        self->wbapi = [[WeiboApi alloc]initWithAppKey:kAppKey andSecret:kAppSecret andRedirectUri:kRedirectURI andAuthModeFlag:0 andCachePolicy:0] ;
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - sso
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.wbapi handleOpenURL:url];
}

//Available in iOS 4.2 and later.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.wbapi handleOpenURL:url];
}

@end
