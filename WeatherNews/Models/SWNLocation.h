//
//  SWNLocation.h
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "RLMObject.h"
#import "SWNWeatherCondition.h"
#import "RLMArray.h"
#import "SWNWeatherDisplayableItem.h"

@class CLLocation;
@class SWNWeatherFeed;

@interface SWNLocation : RLMObject <SWNWeatherDisplayableItem>

@property NSString* locationID;
@property NSString* locationName;
@property NSString* country;
@property NSString* region;
@property double latitude;
@property double longitude;
@property RLMArray<SWNWeatherCondition>* forecast;

@property (nonatomic, readonly) NSString* fullLocationName;
@property (nonatomic, readonly) SWNWeatherCondition* currentCondition;

- (void)updateWithCoreLocation:(CLLocation*)location;
- (void)updateWeatherConditions:(NSArray*)conditions;

@end
RLM_ARRAY_TYPE(SWNLocation)
