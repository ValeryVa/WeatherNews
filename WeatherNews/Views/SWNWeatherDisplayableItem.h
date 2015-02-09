//
//  SWNWeatherDisplayableItem.h
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import <Foundation/Foundation.h>

@protocol SWNWeatherDisplayableItem <NSObject>

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* subtitle;
@property (nonatomic, readonly) NSString* imageName;
@property (nonatomic, readonly) NSString* temperature;

@optional
@property (nonatomic, readonly) BOOL showsLocationIcon;

@end
