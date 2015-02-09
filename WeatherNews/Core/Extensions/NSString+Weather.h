//
//  NSString+Weather.h
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Weather)

+ (NSString*)conditionImageNameForWeatherType:(SWNWeatherConditionType)weatherType;
+ (NSString*)temperatureSignWithUnitType:(SWNUnitOfTemperatureType)temperature;
+ (NSString*)lengthSignWithUnitType:(SWNUnitOfLengthType)length;

+ (NSString*)temperatureWithUnitType:(SWNUnitOfTemperatureType)temperatureType;
+ (NSString*)lengthWithUnitType:(SWNUnitOfLengthType)lengthType;

@end
