//
//  Extensions.h
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

#ifndef __EXTENSIONS_H
#define __EXTENSIONS_H

#import <Foundation/Foundation.h>

#ifdef APPSTORE
#define LOGS_ENABLED 0
#else
#define LOGS_ENABLED 1
#endif


#ifdef LOGS_ENABLED
#define DEBUG_LOG(...) NSLog(__VA_ARGS__)
#else
#define DEBUG_LOG(...)
#endif

#import "UIColor+Extensions.h"
#import "NSString+Weather.h"
#import "UIView+Extensions.h"


#endif