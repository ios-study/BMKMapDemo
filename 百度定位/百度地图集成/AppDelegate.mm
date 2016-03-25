//
//  AppDelegate.m
//  百度地图集成
//
//  Created by xiaomage on 15/8/24.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI/BMapKit.h>
#import "BNCoreServices.h"


#define kKey @"qzdZ9km3kzVmUb7dna7Gtm0E"

@interface AppDelegate ()

/** <#注释#> */
@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate


-(BMKMapManager *)mapManager
{
    if (!_mapManager) {
        _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        BOOL ret = [_mapManager start:kKey generalDelegate:nil];
        if (!ret) {
            NSLog(@"manager start failed!");
        }else
        {
            NSLog(@"成功");
        }
        
        
        [BNCoreServices_Instance initServices:kKey];
        [BNCoreServices_Instance startServicesAsyn:^{
            NSLog(@"成功!");
        } fail:^{
            NSLog(@"失败");
        }];
        
    }
    return _mapManager;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self mapManager];
    
    // Override point for customization after application launch.
    return YES;
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
