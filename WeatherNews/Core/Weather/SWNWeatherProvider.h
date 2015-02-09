//
//  SWNWeatherService.h
//  WeatherNews
//
//  Created by valery voskobovich on 2/6/15.
//
//

@import Foundation;

@class SWNWeatherRequest;

@protocol SWNWeatherProvider <NSObject>

@property (nonatomic, readonly) NSString* apiKey;
@property (nonatomic, readonly) NSString* serviceName;

+ (instancetype)providerWithAPIKey:(NSString*)key;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAPIKey:(NSString*)key;

- (NSURLRequest*)requestForWeatherRequest:(SWNWeatherRequest*)request;
- (Class)responseSerializerClassForWeatherRequest:(SWNWeatherRequest*)request;


@end
