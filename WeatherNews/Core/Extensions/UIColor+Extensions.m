//
//  UIColor+Extensions.m
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *)colorWithHex: (NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    unsigned rgbValue = 0;
    [[NSScanner scannerWithString:cString] scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}


@end
