//
//  Constants.h
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

@import Foundation;

typedef NS_ENUM(NSInteger, SWNWeatherConditionType)
{
    SWNWeatherConditionCloudy,
    SWNWeatherConditionSunny,
    SWNWeatherConditionWindy,
    SWNWeatherConditionLightning
};

typedef NS_ENUM(NSInteger, SWNUnitOfLengthType)
{
    SWNUnitOfLengthMeters,
    SWNUnitOfLengthMiles
};

typedef NS_ENUM(NSInteger, SWNUnitOfTemperatureType)
{
    SWNUnitOfTemperatureCelsius,
    SWNUnitOfTemperatureFahrenheit
};
