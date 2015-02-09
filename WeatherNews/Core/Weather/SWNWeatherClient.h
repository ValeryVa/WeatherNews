//
//  SWNWeatherServiceLocator.h
//  WeatherNews
//
//  Created by valery voskobovich on 2/6/15.
//
//

#import <Foundation/Foundation.h>
#import "SWNWeatherProvider.h"

typedef void(^SWNWeatherManagerRequestCallback)(NSArray* results, NSError* error);

typedef NSString* SWNWeatherRequestID;

@interface SWNWeatherClient : NSObject

+ (instancetype)instance;
+ (void)registerService:(id<SWNWeatherProvider>)service;
+ (id<SWNWeatherProvider>)serviceForName:(NSString*)serviceName;

- (SWNWeatherRequestID)performRequest:(SWNWeatherRequest*)weatherRequest
                             callback:(SWNWeatherManagerRequestCallback)callback;
- (void)cancelRequestWithID:(SWNWeatherRequestID)operationID;

@end
