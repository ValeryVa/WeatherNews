//
//  NSUserDefaults+Weather.m
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "NSUserDefaults+Weather.h"
#import <NSUserDefaults+Property/NSUserDefaults+Property.h>

@interface NSUserDefaults(WeatherInternal)

@property NSNumber* unitOfLengthInternal;
@property NSNumber* unitOfTemperatureInternal;

@end

@implementation NSUserDefaults(WeatherInternal)

@dynamic unitOfLengthInternal;
@dynamic unitOfTemperatureInternal;

@end

@implementation NSUserDefaults (Weather)

@dynamic weatherProviderName;
@dynamic unitOfLength;
@dynamic unitOfTemperature;

- (void)setUnitOfLength:(SWNUnitOfLengthType)unitOfLength
{
    self.unitOfLengthInternal = @(unitOfLength);
}

- (SWNUnitOfLengthType)unitOfLength
{
    NSNumber* value = self.unitOfLengthInternal;
    if (value == nil)
        return SWNUnitOfLengthMeters;
    
    return [value integerValue];
}

- (void)setUnitOfTemperature:(SWNUnitOfTemperatureType)unitOfTemperature
{
    self.unitOfTemperatureInternal = @(unitOfTemperature);
}

- (SWNUnitOfTemperatureType)unitOfTemperature
{
    NSNumber* value = self.unitOfTemperatureInternal;
    if (value == nil)
        return SWNUnitOfTemperatureCelsius;
    
    return [value integerValue];
}

@end
