//
//  SWNLocation.m
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "SWNLocation.h"
#import "SWNDBQueue.h"
#import "SWNWeatherFeed.h"
#import "SWNLocationInternal.h"
#import "SWNWeatherRequest.h"
#import "SWNWeatherClient.h"

#import <Realm/Realm.h>
#import <extobjc.h>

@import CoreLocation;

@interface SWNLocation()

@property (nonatomic, strong) SWNWeatherRequestID updateRequestID;

@end

@implementation SWNLocation

+ (NSString *)primaryKey
{
    return NSStringFromSelector(@selector(locationID));
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{NSStringFromSelector(@selector(locationID)): @"",
             NSStringFromSelector(@selector(locationName)): @"",
             NSStringFromSelector(@selector(country)): @"",
             NSStringFromSelector(@selector(region)): @"",
             NSStringFromSelector(@selector(latitude)): @(0.0),
             NSStringFromSelector(@selector(longitude)): @(0.0)};
}

+ (NSArray *)ignoredProperties
{
    return @[NSStringFromSelector(@selector(fullLocationName)),
             NSStringFromSelector(@selector(updateRequestID))];
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.locationName];
    [description appendFormat:@", country=%@", self.country];
    [description appendFormat:@", region=%@", self.region];
    [description appendString:@">"];
    return description;
}

#pragma mark -
#pragma mark Actions

- (NSString *)fullLocationName
{
    NSMutableString* locationName = [NSMutableString string];
    if (self.locationName.length > 0)
        [locationName appendString:self.locationName];
    
    if (self.country.length > 0)
        [locationName appendFormat:@", %@", self.country];
    
    return locationName;
}

- (void)updateWithCoreLocation:(CLLocation*)location
{
    if (location == nil)
        return;
    
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
}

- (void)updateWeatherConditions:(NSArray*)conditions
{
    __block NSString* locationID = self.locationID;
    [SWNDBQueue performDBActionWithBlock:^{
       
        RLMRealm* realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        [self updateWeatherConditionsInternal:conditions realm:realm locationID:locationID];
        [realm commitWriteTransaction];
        
    }];
}

- (SWNLocation*)updateWeatherConditionsInternal:(NSArray *)conditions
                                          realm:(RLMRealm*)realm
                                     locationID:(NSString*)locationID
{
    SWNLocation* location = [[self class] objectInRealm:realm forPrimaryKey:locationID];
    if (location)
    {
        [realm deleteObjects:location.forecast];
        [location.forecast removeAllObjects];
        [location.forecast addObjects:conditions];
    }
    
    return location;
}

- (SWNWeatherCondition *)currentCondition
{
    return [self.forecast firstObject];
}

#pragma mark -
#pragma mark DisplayableItem

- (NSString *)title
{
    return self.locationName;
}

- (NSString *)subtitle
{
    return [self.currentCondition subtitle];
}

- (NSString*)imageName
{
    return [self.currentCondition imageName];
}

- (NSString *)temperature
{
    return [self.currentCondition temperature];
}

- (BOOL)showsLocationIcon
{
    return NO;
}

@end
