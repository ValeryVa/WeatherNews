//
//  SWNWWOForecastSerializer.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "SWNWWOForecastSerializer.h"
#import "SWNWeatherCondition.h"

@interface SWNWWOForecastSerializer()

@property (nonatomic, strong, readonly) NSDateFormatter* dateFormatter;

@end

@implementation SWNWWOForecastSerializer

@synthesize dateFormatter = _dateFormatter;

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

+ (SWNWeatherConditionType)weatherTypeWithWeatherCode:(NSInteger)code
{
    if ([@[@395, @392, @374, @371, @368, @350, @338, @335, @332, @329, @326, @323, @230, @179, @227] containsObject:@(code)]) {
        return SWNWeatherConditionWindy;
    } else if ([@[@365, @362, @320, @317, @182] containsObject:@(code)]) {
        return SWNWeatherConditionWindy;
    } else if ([@[@389, @386, @356, @314, @311, @308, @305, @302, @299, @176] containsObject:@(code)]) {
        return SWNWeatherConditionLightning;
    } else if ([@[@296, @203, @284, @281, @266, @263, @185] containsObject:@(code)]) {
        return SWNWeatherConditionWindy;
    } else if (code == 359) {
        return SWNWeatherConditionLightning;
    } else if (code == 377 || code == 353) {
        return SWNWeatherConditionWindy;
    } else if (code == 260 || code == 248 || code == 200 || code == 143) {
        return SWNWeatherConditionWindy;
    } else if (code == 122 || code == 119) {
        return SWNWeatherConditionCloudy;
    } else if (code == 116) {
        return SWNWeatherConditionSunny;
    }
    
    //113
    return SWNWeatherConditionSunny;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    DEBUG_LOG(@"%@", responseObject);
    
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSArray* weatherArray = responseObject[@"data"][@"weather"];
        
        __block NSMutableArray* conditions = [NSMutableArray array];
        
        [weatherArray enumerateObjectsUsingBlock:^(NSDictionary* weatherDict, NSUInteger idx, BOOL *stop) {
            
            NSDictionary* hourlyWeatherDict = [weatherDict[@"hourly"] firstObject];

            SWNWeatherCondition* condition = [SWNWeatherCondition new];
            condition.precipitation = [hourlyWeatherDict[@"precipMM"] floatValue];
            condition.pressure = [hourlyWeatherDict[@"pressure"] integerValue];
            condition.temperatureInCelsius = [hourlyWeatherDict[@"tempC"] integerValue];
            condition.temperatureInFahrenheit = [hourlyWeatherDict[@"tempF"] integerValue];
            condition.weatherDescription = [hourlyWeatherDict[@"weatherDesc"] firstObject][@"value"];
            condition.windDirection = hourlyWeatherDict[@"winddir16Point"];
            condition.windSpeedInKmh = [hourlyWeatherDict[@"windspeedKmph"] integerValue];
            condition.windSpeedInMiles = [hourlyWeatherDict[@"windspeedMiles"] integerValue];
            condition.weatherType = [SWNWWOForecastSerializer weatherTypeWithWeatherCode:[hourlyWeatherDict[@"weatherCode"] integerValue]];
            condition.chanceOfRain = [hourlyWeatherDict[@"chanceofrain"] integerValue];
            condition.date = [self.dateFormatter dateFromString:weatherDict[@"date"]];

            [conditions addObject:condition];
        }];
        
        return [NSArray arrayWithArray:conditions];
    }
    
    return responseObject;
}

@end
