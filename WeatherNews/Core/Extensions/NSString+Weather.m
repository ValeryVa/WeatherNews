//
//  NSString+Weather.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "NSString+Weather.h"

@implementation NSString (Weather)

+ (NSString*)conditionImageNameForWeatherType:(SWNWeatherConditionType)weatherType
{
    switch (weatherType)
    {
        case SWNWeatherConditionCloudy:
            
            return @"icon_condition_cloudy";
            
        case SWNWeatherConditionLightning:
            
            return @"icon_condition_lightning";
            
        case SWNWeatherConditionWindy:
            
            return @"icon_condition_windy";
            
        case SWNWeatherConditionSunny:
            
            return @"icon_condition_sunny";
    }
    
    return @"icon_condition_sunny";
}

+ (NSString*)temperatureSignWithUnitType:(SWNUnitOfTemperatureType)temperature
{
    switch (temperature)
    {
        case SWNUnitOfTemperatureCelsius:
            
            return @"C";
            
        case SWNUnitOfTemperatureFahrenheit:
            
            return @"F";
    }
    
    return @"C";
}

+ (NSString*)lengthSignWithUnitType:(SWNUnitOfLengthType)length
{
    switch (length)
    {
        case SWNUnitOfLengthMeters:
            
            return NSLocalizedString(@"km/h", @"");
            
        case SWNUnitOfLengthMiles:
            
            return NSLocalizedString(@"miles", @"");
    }
    
    return @"km/h";
}

+ (NSString*)temperatureWithUnitType:(SWNUnitOfTemperatureType)temperatureType
{
    switch (temperatureType)
    {
        case SWNUnitOfTemperatureCelsius:
            
            return NSLocalizedString(@"Celsius", @"");
            
        case SWNUnitOfTemperatureFahrenheit:
            
            return NSLocalizedString(@"Fahrenheit", @"");
    }
    
    return NSLocalizedString(@"Celsius", @"");
}

+ (NSString*)lengthWithUnitType:(SWNUnitOfLengthType)lengthType
{
    switch (lengthType)
    {
        case SWNUnitOfLengthMeters:
            
            return NSLocalizedString(@"Meters", @"");
            
        case SWNUnitOfLengthMiles:
            
            return NSLocalizedString(@"Miles", @"");
    }
    
    return @"Meters";
}

@end
