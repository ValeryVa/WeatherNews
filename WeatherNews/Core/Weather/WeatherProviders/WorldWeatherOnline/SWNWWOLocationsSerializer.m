//
//  SWNWWOLocationsSerializer.m
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "SWNWWOLocationsSerializer.h"
#import "SWNLocation.h"

@implementation SWNWWOLocationsSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    
    DEBUG_LOG(@"%@", responseObject);
    
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        NSArray* results = responseObject[@"search_api"][@"result"];
        __block NSMutableArray* locations = [NSMutableArray array];
        
        [results enumerateObjectsUsingBlock:^(NSDictionary* locationDict, NSUInteger idx, BOOL *stop) {
            
            SWNLocation* location = [[SWNLocation alloc] init];
            location.locationName = [locationDict[@"areaName"] firstObject][@"value"];
            location.country = [locationDict[@"country"] firstObject][@"value"];
            location.region = [locationDict[@"region"] firstObject][@"value"];
            location.latitude = [locationDict[@"latitude"] doubleValue];
            location.longitude = [locationDict[@"longitude"] doubleValue];
            
            [locations addObject:location];
            
        }];
        
        return [NSArray arrayWithArray:locations];
    }
    
    return responseObject;
}

@end
