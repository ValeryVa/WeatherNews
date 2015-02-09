//
//  SWNWeatherServiceLocator.m
//  WeatherNews
//
//  Created by valery voskobovich on 2/6/15.
//
//

#import "SWNWeatherClient.h"
#import <AFNetworking/AFNetworking.h>

#import "SWNWeatherRequest.h"
#import "SWNWorldWeatherOnline.h"
#import "NSUserDefaults+Weather.h"

@interface SWNWeatherClient()

@property (nonatomic, strong, readonly) NSMutableDictionary* services;
@property (nonatomic, strong, readonly) NSOperationQueue* operationQueue;;

@end

@implementation SWNWeatherClient

static NSString* kSWNWorldWeatherOnlineKey = @"5218c91c2d5d6ee6a790e8d646167";
static NSString* kAFHTTPOperationIDKey = @"WeatherOperationID";

@synthesize services = _services;
@synthesize operationQueue = _operationQueue;

- (NSMutableDictionary *)services
{
    if (_services == nil)
        _services = [NSMutableDictionary dictionary];
    
    return _services;
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil)
        _operationQueue = [[NSOperationQueue alloc] init];
    
    return _operationQueue;
}

+ (instancetype)instance
{
    static SWNWeatherClient* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        SWNWorldWeatherOnline* wwoWeatherProvider = [SWNWorldWeatherOnline providerWithAPIKey:kSWNWorldWeatherOnlineKey];
        [self registerService:wwoWeatherProvider];

        // TODO: change implementation of saving default weather provider if it's needed
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        defaults.weatherProviderName = [wwoWeatherProvider serviceName];
        [defaults synchronize];
    }
    return self;
}

#pragma mark -
#pragma mark Service Locator

+ (void)registerService:(id<SWNWeatherProvider>)service
{
    [[self instance] registerService:service];
}

+ (id<SWNWeatherProvider>)serviceForName:(NSString *)serviceName
{
    return [[self instance] serviceForName:serviceName];
}

- (void)registerService:(id<SWNWeatherProvider>)service
{
    NSString* serviceName = [service serviceName];
    if (serviceName.length == 0)
        return;
    
    id<SWNWeatherProvider> weatherService = self.services[serviceName];
    if (weatherService)
        return;
    
    if (service)
        self.services[serviceName] = service;
}

- (id<SWNWeatherProvider>)serviceForName:(NSString*)serviceName
{
    return self.services[serviceName];
}


#pragma mark -
#pragma mark Weather Manager API

- (SWNWeatherRequestID)performRequest:(SWNWeatherRequest*)weatherRequest
                             callback:(SWNWeatherManagerRequestCallback)callback
{
    id<SWNWeatherProvider> provider = [self serviceForName:[[NSUserDefaults standardUserDefaults] weatherProviderName]];
    if (provider == nil)
        return nil;
    
    NSURLRequest* request = [provider requestForWeatherRequest:weatherRequest];
    if (request == nil)
        return nil;
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    Class responseSerializerClass = [provider responseSerializerClassForWeatherRequest:weatherRequest];
    if (responseSerializerClass)
        operation.responseSerializer = [responseSerializerClass serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        DEBUG_LOG(@"Weather operation [%@] finished. Response: %@", [operation.request.URL absoluteString], responseObject);
        NSArray* results = nil;
        if (responseObject)
        {
            results = [responseObject isKindOfClass:[NSArray class]] ? responseObject : @[responseObject];
        }
        
        if (callback)
            callback(results, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        DEBUG_LOG(@"Weather operation [%@] failed. Error: %@", [operation.request.URL absoluteString], error);

        if (callback)
            callback(nil, error);
        
    }];
    
    NSString* operationID = [[NSUUID UUID] UUIDString];
    operation.userInfo = @{kAFHTTPOperationIDKey: operationID};
    
    [[self operationQueue] addOperation:operation];
    return operationID;
}

- (void)cancelRequestWithID:(SWNWeatherRequestID)operationID
{
    __block NSOperation* operation = nil;
    NSArray* operations = self.operationQueue.operations;
    [operations enumerateObjectsUsingBlock:^(AFHTTPRequestOperation* weatherOperation, NSUInteger idx, BOOL *stop) {
        
        if ([[weatherOperation userInfo][kAFHTTPOperationIDKey] isEqualToString:operationID])
        {
            operation = weatherOperation;
            *stop = YES;
        }
    }];

    [operation cancel];
}

@end
