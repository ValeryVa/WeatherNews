//
//  SWNAppAppearance.h
//  WeatherNews
//
//  Created by ValeryV on 2/3/15.
//
//

@import Foundation;
@import UIKit;

@interface SWNAppAppearance : NSObject

+ (void)configure;

+ (UIFont*)regularFontWithSize:(CGFloat)size;
+ (UIFont*)lightFontWithSize:(CGFloat)size;
+ (UIFont*)boldFontWithSize:(CGFloat)size;
+ (UIFont*)semiboldFontWithSize:(CGFloat)size;

@end
