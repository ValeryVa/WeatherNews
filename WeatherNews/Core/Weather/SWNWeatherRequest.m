//
//  SWNWeatherRequest.m
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "SWNWeatherRequest.h"

@interface SWNWeatherRequest()

@property (nonatomic, readwrite) SWNWeatherRequestType requestType;
@property (nonatomic, strong, readwrite) SWNLocation* location;

@end

@implementation SWNWeatherRequest

+ (instancetype)locationsWithQueryText:(NSString*)text
{
    SWNWeatherRequest* request = [[self alloc] init];
    request.requestType = SWNWeatherRequestTypeLocations;
    
    SWNLocation* location = [[SWNLocation alloc] init];
    location.locationName = text;
    request.location = location;
    
    return request;

}

+ (instancetype)locationsWithLatitude:(double)latitude
                            longitude:(double)longitude
{
    SWNWeatherRequest* request = [[self alloc] init];
    request.requestType = SWNWeatherRequestTypeLocations;
    
    SWNLocation* location = [[SWNLocation alloc] init];
    location.latitude = latitude;
    location.longitude = longitude;
    
    request.location = location;
    
    return request;
}

+ (instancetype)forecastWithLocation:(SWNLocation*)location;
{
    SWNWeatherRequest* request = [[self alloc] init];
    request.location = location;
    request.requestType = SWNWeatherRequestTypeForecast;
    
    return request;
}

@end
