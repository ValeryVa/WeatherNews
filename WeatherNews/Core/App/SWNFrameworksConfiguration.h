//
//  SWNFrameworksConfiguration.h
//  WeatherNews
//
//  Created by ValeryV on 2/27/15.
//
//

#import <Foundation/Foundation.h>

@interface SWNFrameworksConfiguration : NSObject

+ (void)applicationDidFinishLaunching:(UIApplication*)application
                              options:(NSDictionary*)options;

+ (void)applicationDidBecomeActive:(UIApplication*)application;
+ (void)applicationWillResignActive:(UIApplication*)application;

@end
