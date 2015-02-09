//
//  UIView+Extensions.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

+ (UINib*)swn_customNibForView
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
