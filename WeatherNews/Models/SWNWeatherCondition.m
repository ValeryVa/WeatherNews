//
//  SWNWeatherCondition.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "SWNWeatherCondition.h"
#import "NSUserDefaults+Weather.h"

@implementation SWNWeatherCondition

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"date=%@", self.date];
    [description appendFormat:@", temperature=%ld", (long)self.temperatureInCelsius];
    [description appendFormat:@", description=%@", self.weatherDescription];
    [description appendString:@">"];
    return description;
}

#pragma mark -
#pragma mark DisplayableItem

+ (NSDateFormatter*)displayableDateFormatter
{
    static NSDateFormatter* dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
    });
    
    return dateFormatter;
}

- (NSString *)title
{
    return [[SWNWeatherCondition displayableDateFormatter] stringFromDate:self.date];
}

- (NSString *)subtitle
{
    return self.weatherDescription;
}

- (NSString*)imageName
{
    return [NSString conditionImageNameForWeatherType:self.weatherType];
}

- (NSString *)temperature
{
    SWNUnitOfTemperatureType temperatureType = [NSUserDefaults standardUserDefaults].unitOfTemperature;
    NSInteger value = (temperatureType == SWNUnitOfTemperatureFahrenheit) ? self.temperatureInFahrenheit : self.temperatureInCelsius;
    return [NSString stringWithFormat:@"%ld°", (long)value];
}


@end
