//
//  SWNDBQueue.m
//  WeatherNews
//
//  Created by ValeryV on 2/7/15.
//
//

#import "SWNDBQueue.h"

@implementation SWNDBQueue

+ (dispatch_queue_t)dbQueue
{
    static dispatch_queue_t dbQueue = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dbQueue = dispatch_queue_create("swn.db.queue", DISPATCH_QUEUE_CONCURRENT);
        
    });
    
    return dbQueue;
}

+ (void)performDBActionWithBlock:(dispatch_block_t)block
{
    dispatch_async([self dbQueue], ^{
       
        if (block)
            block();
        
    });
}

@end
