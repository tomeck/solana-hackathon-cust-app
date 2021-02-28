//
//  AppDelegate.m
//  Circle Consumer Wallet
//
//  Created by Tom Eck on 2/22/21.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //TODO JTE - move these into Info.plist
    self.CIRCLE_API_KEY = @"QVBJX0tFWTpmNTE0ZDU5MWM5YTE4MjI4NGViZGMxNmYwNmQ4ZGVhMjpiOWFlZmEwODU2ZTA4ZDVhODgxNjY2MzQ3NGQ4ODA5Nw";
    self.CIRCLE_API_BASE_URL = @"https://api-sandbox.circle.com/v1";
    self.CONSUMER_WALLET_ID = @"1000066046";
    

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
