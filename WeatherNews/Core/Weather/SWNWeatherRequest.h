//
//  SWNWeatherRequest.h
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

@import Foundation;

#import "SWNLocation.h"

typedef NS_ENUM(NSInteger, SWNWeatherRequestType)
{
    SWNWeatherRequestTypeLocations,
    SWNWeatherRequestTypeForecast
};

@interface SWNWeatherRequest : NSObject

@property (nonatomic, readonly) SWNWeatherRequestType requestType;
@property (nonatomic, strong, readonly) SWNLocation* location;

+ (instancetype)locationsWithQueryText:(NSString*)text;
+ (instancetype)locationsWithLatitude:(double)latitude
                            longitude:(double)longitude;
+ (instancetype)forecastWithLocation:(SWNLocation*)location;

@end
