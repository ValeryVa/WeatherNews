//
//  SWNFrameworksConfiguration.m
//  WeatherNews
//
//  Created by ValeryV on 2/27/15.
//
//

#import "SWNFrameworksConfiguration.h"

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation SWNFrameworksConfiguration

+ (void)applicationDidFinishLaunching:(UIApplication*)application
                              options:(NSDictionary*)options
{
    // Setup Crashlytics here...
    // Setup Flurry here...
    // Setup Parse here...
    // etc.
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

+ (void)applicationDidBecomeActive:(UIApplication*)application
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)applicationWillResignActive:(UIApplication*)application
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
