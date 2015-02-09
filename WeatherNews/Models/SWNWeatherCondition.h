//
//  SWNWeatherCondition.h
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "RLMObject.h"
#import "SWNWeatherDisplayableItem.h"

@interface SWNWeatherCondition : RLMObject <SWNWeatherDisplayableItem>

@property NSInteger windSpeedInKmh;
@property NSInteger windSpeedInMiles;
@property NSString* windDirection;
@property NSInteger chanceOfRain;
@property CGFloat precipitation;
@property NSInteger pressure;
@property NSInteger temperatureInCelsius;
@property NSInteger temperatureInFahrenheit;
@property NSString* weatherDescription;
@property SWNWeatherConditionType weatherType;
@property NSDate* date;

@end
RLM_ARRAY_TYPE(SWNWeatherCondition)
