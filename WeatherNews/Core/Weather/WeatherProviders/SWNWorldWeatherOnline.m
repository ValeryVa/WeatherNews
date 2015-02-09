//
//  SWNWWOProvider.m
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "SWNWorldWeatherOnline.h"
#import <AFNetworking/AFNetworking.h>
#import "SWNWeatherRequest.h"
#import "SWNWWOLocationsSerializer.h"
#import "SWNWWOForecastSerializer.h"

#import "SWNAutoLocation.h"

@interface SWNWorldWeatherOnline()

@property (nonatomic, strong, readonly) AFHTTPRequestSerializer* requestSerializer;

@end

@implementation SWNWorldWeatherOnline

static NSString* kWWOBaseURL = @"https://api.worldweatheronline.com/free/v2/";
static NSString* kWWOSearchPath = @"search.ashx";
static NSString* kWWOWeatherPath = @"weather.ashx";

static NSString* kWWOFormatKey = @"format";
static NSString* kWWOQueryKey = @"q";
static NSString* kWWOAPIKey = @"key";
static NSString* kWWOJSONKey = @"json";
static NSString* kWWONumOfForecastDaysKey = @"num_of_days";
static NSString* kWWOForecastTimePeriodKey = @"tp";

static NSInteger kWWODefaultForecastNumOfDays = 1;
static NSInteger kWWOFullForecastNumOfDays = 7;
static NSInteger kWWODefaultForecastTimePeriod = 24;

@synthesize apiKey = _apiKey;
@synthesize requestSerializer = _requestSerializer;

+ (instancetype)providerWithAPIKey:(NSString *)key
{
    return [[self alloc] initWithAPIKey:key];
}

- (instancetype)initWithAPIKey:(NSString *)key
{
    self = [super init];
    if (self)
    {
        if (key == nil)
            return nil;
        
        _apiKey = key;
    }
    
    return self;
}

#pragma mark -
#pragma mark SWNWeatherProvider

+ (NSString*)URLWithPath:(NSString*)path
{
    return [kWWOBaseURL stringByAppendingPathComponent:path];
}

- (NSString *)serviceName
{
    return @"WorldWeatherOnline";
}

- (AFHTTPRequestSerializer *)requestSerializer
{
    if (_requestSerializer == nil)
    {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _requestSerializer;
}

- (NSURLRequest *)requestForWeatherRequest:(SWNWeatherRequest *)request
{
    if (_apiKey.length == 0)
        return nil;
    
    SWNLocation* location = [request location];
    NSString* requestMethod = nil;
    NSString* requestURL = nil;
    NSDictionary* parameters = nil;
    
    if (request.requestType == SWNWeatherRequestTypeLocations)
    {
        NSString* q = (location.locationName.length > 0) ? location.locationName : [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
        
        requestMethod = @"GET";
        requestURL = [SWNWorldWeatherOnline URLWithPath:kWWOSearchPath];
        parameters = @{kWWOQueryKey:q,
                       kWWOFormatKey:kWWOJSONKey,
                       kWWOAPIKey:_apiKey};
    }else if (request.requestType == SWNWeatherRequestTypeForecast)
    {
        NSString* q = location.fullLocationName;
        if (fabs(0.0 - location.latitude) > DBL_EPSILON &&
            fabs(0.0 - location.longitude) > DBL_EPSILON)
        {
            q = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
        }
        
        BOOL isAutoLocation = [location isKindOfClass:[SWNAutoLocation class]];
        
        requestMethod = @"GET";
        requestURL = [SWNWorldWeatherOnline URLWithPath:kWWOWeatherPath];
        parameters = @{kWWOQueryKey:q,
                       kWWOFormatKey:kWWOJSONKey,
                       kWWOAPIKey:_apiKey,
                       kWWONumOfForecastDaysKey:(isAutoLocation) ? @(kWWOFullForecastNumOfDays) :@(kWWODefaultForecastNumOfDays),
                       kWWOForecastTimePeriodKey:@(kWWODefaultForecastTimePeriod)};

    }else
    {
        return nil;
    }
    
    return [self.requestSerializer requestWithMethod:requestMethod
                                           URLString:requestURL
                                          parameters:parameters
                                               error:nil];
}

- (Class)responseSerializerClassForWeatherRequest:(SWNWeatherRequest *)request
{
    if (request.requestType == SWNWeatherRequestTypeLocations)
        return [SWNWWOLocationsSerializer class];
    
    if (request.requestType == SWNWeatherRequestTypeForecast)
        return [SWNWWOForecastSerializer class];
    
    return nil;
}

@end
