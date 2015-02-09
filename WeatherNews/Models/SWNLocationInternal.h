//
//  SWNLocationInternal.h
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#ifndef WeatherNews_SWNLocationInternal_h
#define WeatherNews_SWNLocationInternal_h

@interface SWNLocation()

- (SWNLocation*)updateWeatherConditionsInternal:(NSArray *)conditions
                                          realm:(RLMRealm*)realm
                                     locationID:(NSString*)locationID;

@end

#endif
