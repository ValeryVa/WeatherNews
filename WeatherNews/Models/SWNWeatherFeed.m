//
//  SWNWeatherFeed.m
//  WeatherNews
//
//  Created by ValeryV on 2/8/15.
//
//

#import "SWNWeatherFeed.h"
#import "SWNDBQueue.h"

#import <Realm/Realm.h>
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <extobjc.h>

#import "SWNWeatherClient.h"
#import "SWNWeatherRequest.h"

@interface SWNWeatherFeed()

@property NSString* feedID;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) id reachabilityObserver;
@property (nonatomic, strong) NSString* locationRequestID;
@property (nonatomic, strong) CLLocation* currentGeolocation;

@property (nonatomic) BOOL internetConnectionAvailable;
@property (nonatomic) BOOL locationEnabled;
@property (nonatomic) BOOL currentLocationFetched;

@end

@implementation SWNWeatherFeed

static CGFloat kSWNWeatherLocationAccuracyInMeters = 1000.0;
static NSString* kSWNWeatherFeedID = @"__weather__feed__";

+ (instancetype)feed
{
    static SWNWeatherFeed* feed = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        RLMRealm* realm = [RLMRealm defaultRealm];
        feed = [self fetchWeatherFeedInRealm:realm];
        
        if (feed == nil)
        {
            [realm beginWriteTransaction];
            feed = [SWNWeatherFeed createInDefaultRealmWithObject:[SWNWeatherFeed new]];
            [realm commitWriteTransaction];
        }
        
        [feed commonInitialize];
            
    });
    
    return feed;
}

+ (instancetype)fetchWeatherFeedInRealm:(RLMRealm*)realm
{
    return [SWNWeatherFeed objectInRealm:realm forPrimaryKey:kSWNWeatherFeedID];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self.reachabilityObserver];
    self.reachabilityObserver = nil;
}

#pragma mark -
#pragma mark Realm methods

+ (NSArray *)ignoredProperties
{
    return @[NSStringFromSelector(@selector(locationManager)),
             NSStringFromSelector(@selector(locationRequestID)),
             NSStringFromSelector(@selector(reachabilityObserver)),
             NSStringFromSelector(@selector(internetConnectionAvailable)),
             NSStringFromSelector(@selector(locationEnabled)),
             NSStringFromSelector(@selector(currentLocationFetched)),
             NSStringFromSelector(@selector(currentGeolocation))];
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{NSStringFromSelector(@selector(feedID)):kSWNWeatherFeedID,
             NSStringFromSelector(@selector(currentLocationID)):@""};
}

+ (NSString *)primaryKey
{
    return NSStringFromSelector(@selector(feedID));
}

#pragma mark -
#pragma mark Initialization

- (void)initializeLocationManager
{
    self.locationManager = [CLLocationManager updateManagerWithAccuracy:kSWNWeatherLocationAccuracyInMeters
                                                            locationAge:kCLLocationAgeFilterNone
                                                authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
    @weakify(self)
    [self.locationManager didChangeAuthorizationStatusWithBlock:^(CLLocationManager *manager, CLAuthorizationStatus status) {
        
        @strongify(self)
        
        if (self.locationEnabled == NO && [CLLocationManager isLocationUpdatesAvailable])
            [self startUpdatingLocation];
        
    }];
}

- (void)startUpdatingLocation
{
    self.locationEnabled = [CLLocationManager isLocationUpdatesAvailable];

    if (self.locationEnabled == NO)
        return;
    
    @weakify(self)
    [self.locationManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
        
        @strongify(self)
        if (location)
        {
            *stopUpdating = YES;
            self.currentLocationFetched = NO;
            [self updateCurrentLocationWithCLLocation:location];
        }
        
        if (error)
        {
            *stopUpdating = YES;
            DEBUG_LOG(@"Location manager error: %@", error);
        }
        
    }];
}

- (void)initializeReachability
{
    @weakify(self)
    self.reachabilityObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AFNetworkingReachabilityDidChangeNotification
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  
                                                                                  @strongify(self)
                                                                                  BOOL isReachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
                                                                                  if (self.internetConnectionAvailable == NO && isReachable)
                                                                                  {
                                                                                      [self updateWeatherConditions];
                                                                                      
                                                                                      if (self.currentLocationFetched == NO)
                                                                                          [self updateCurrentLocationWithCLLocation:self.currentGeolocation];
                                                                                  }
                                                                                  
                                                                              }];
}

- (void)commonInitialize
{
    [self initializeLocationManager];
    [self initializeReachability];

    [self updateFeed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFeed) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)updateWeatherConditions
{
    self.internetConnectionAvailable = [[AFNetworkReachabilityManager sharedManager] isReachable];
    if (self.internetConnectionAvailable == NO)
        return;
    
    for (NSInteger i = 0; i < self.locations.count; i++)
    {
        SWNLocation* location = self.locations[i];
        [self updateWeatherConditionsForLocation:location];
    }
}

- (void)updateFeed
{
    [self startUpdatingLocation];
    [self updateWeatherConditions];
}

#pragma mark -
#pragma mark Locations

- (void)updateCurrentLocationWithCLLocation:(CLLocation*)location
{
    if (self.locationRequestID.length > 0)
    {
        [[SWNWeatherClient instance] cancelRequestWithID:self.locationRequestID];
        self.locationRequestID = nil;
    }
    
    self.currentGeolocation = location;
    if (self.currentGeolocation == nil)
        return;
    
    @weakify(self)
    SWNWeatherRequest* request = [SWNWeatherRequest locationsWithLatitude:location.coordinate.latitude
                                                                longitude:location.coordinate.longitude];
    [[SWNWeatherClient instance] performRequest:request callback:^(NSArray *results, NSError *error) {
        
        if (error == nil)
        {
            @strongify(self)
            self.locationRequestID = nil;
            self.currentLocationFetched = YES;
            
            SWNLocation* autoLocation = [results firstObject];
            if (autoLocation)
            {
                [autoLocation updateWithCoreLocation:location];
                [self setupAutoLocation:autoLocation];
            }
            
            DEBUG_LOG(@"%@", results);
        }
        
    }];
}


- (void)setupAutoLocation:(SWNLocation*)location
{
    [SWNDBQueue performDBActionWithBlock:^{
       
        RLMRealm* realm = [RLMRealm defaultRealm];
        SWNWeatherFeed* feed = [SWNWeatherFeed fetchWeatherFeedInRealm:realm];
        
        [realm beginWriteTransaction];
        if (feed.autoLocation)
        {
            [realm deleteObject:feed.autoLocation];
        }
        feed.autoLocation = [[SWNAutoLocation alloc] initWithObject:location];
        if (feed.currentLocationID.length == 0 && location)
        {
            feed.currentLocationID = feed.autoLocation.locationID;
        }
        
        [realm commitWriteTransaction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self updateWeatherConditionsForLocation:self.autoLocation];
            
        });
    }];
}

- (void)addLocation:(SWNLocation*)location
{
    if (location == nil)
        return;
    
    dispatch_async([SWNDBQueue dbQueue], ^{
        
        RLMRealm* realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        location.locationID = [[NSUUID UUID] UUIDString];
        SWNLocation* dbLocation = [SWNLocation createInRealm:realm withObject:location];
        SWNWeatherFeed* feed = [SWNWeatherFeed fetchWeatherFeedInRealm:realm];
        [feed.locations addObject:dbLocation];
        
        [realm commitWriteTransaction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self updateWeatherConditionsForLocation:location];
            
        });
        
    });
}

- (void)removeLocation:(SWNLocation*)location
{
    if (location == nil)
        return;
    
    @synchronized(self)
    {
        __block NSString* locationID = location.locationID;
        
        dispatch_async([SWNDBQueue dbQueue], ^{

            RLMRealm* realm = [RLMRealm defaultRealm];
            SWNWeatherFeed* feed = [SWNWeatherFeed fetchWeatherFeedInRealm:realm];

            [realm beginWriteTransaction];
            
            NSInteger index = -1;
            for (NSInteger i = 0; i < feed.locations.count; i++)
            {
                SWNLocation* savedLocation = feed.locations[i];
                if ([savedLocation.locationID isEqualToString:locationID])
                {
                    index = i;
                    break;
                }
            }
            if (index >= 0)
                [feed.locations removeObjectAtIndex:index];
            
            [realm commitWriteTransaction];

        });
    }
}

- (void)updateCurrentLocation:(SWNLocation*)location
{
    __block NSString* locationID = location.locationID;
    [SWNDBQueue performDBActionWithBlock:^{
       
        RLMRealm* realm = [RLMRealm defaultRealm];
        SWNWeatherFeed* feed = [SWNWeatherFeed fetchWeatherFeedInRealm:realm];
        
        [realm beginWriteTransaction];
        feed.currentLocationID = locationID;
        [realm commitWriteTransaction];
        
    }];
}

- (SWNLocation*)fetchCurrentLocation
{
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    SWNWeatherFeed* feed = [SWNWeatherFeed fetchWeatherFeedInRealm:realm];
    
    if (feed.currentLocationID.length == 0)
    {
        return [[SWNLocation allObjectsInRealm:realm] firstObject];
    }
    
    if ([feed.currentLocationID isEqualToString:kSWNAutoLocationID])
        return [SWNAutoLocation objectInRealm:realm forPrimaryKey:kSWNAutoLocationID];
    
    return [SWNLocation objectInRealm:realm forPrimaryKey:feed.currentLocationID];
}

#pragma mark -
#pragma mark Weather

- (void)updateWeatherConditionsForLocation:(SWNLocation*)location
{
    SWNWeatherRequest* request = [SWNWeatherRequest forecastWithLocation:location];
    [[SWNWeatherClient instance] performRequest:request callback:^(NSArray *results, NSError *error) {
       
        if (results.count > 0 && location && [location isInvalidated] == NO)
        {
            [location updateWeatherConditions:results];
        }
        
    }];
}


@end
