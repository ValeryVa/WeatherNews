//
//  SWNCustomActivityItemProvider.h
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

@import UIKit;

@interface SWNCustomActivityItemProvider : UIActivityItemProvider

@property (nonatomic, strong) NSMutableDictionary *customText;

- (id)initWithDefaultText:(NSString *)defaultText;

@end
