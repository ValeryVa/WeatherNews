//
//  NSUserDefaults+Weather.h
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

@import Foundation;

@interface NSUserDefaults (Weather)

@property NSString* weatherProviderName;
@property SWNUnitOfLengthType unitOfLength;
@property SWNUnitOfTemperatureType unitOfTemperature;

@end
