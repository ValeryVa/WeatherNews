//
//  SWNDBQueue.h
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import <Foundation/Foundation.h>

@interface SWNDBQueue : NSObject

+ (dispatch_queue_t)dbQueue;
+ (void)performDBActionWithBlock:(dispatch_block_t)block;

@end
