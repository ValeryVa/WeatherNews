//
//  SWNCustomActivityItemProvider.m
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

#import "SWNCustomActivityItemProvider.h"

@implementation SWNCustomActivityItemProvider

- (id)initWithDefaultText:(NSString *)defaultText
{
    self = [super initWithPlaceholderItem:defaultText];
    if (self) {
        _customText = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)item
{
    NSString *outputString = [self.placeholderItem copy];
    NSString *customString = self.customText[self.activityType];
    
    if (customString) {
        outputString = customString;
    }
    
    return outputString;
}

@end
