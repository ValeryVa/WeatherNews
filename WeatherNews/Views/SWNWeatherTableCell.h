//
//  SWNForecastTableCell.h
//  WeatherNews
//
//  Created by ValeryV on 2/5/15.
//
//

@import UIKit;

#import <SWTableViewCell/SWTableViewCell.h>

#import "SWNWeatherDisplayableItem.h"

extern NSString* const kSWNWeatherTableCellReuseIdentifier;

@interface SWNWeatherTableCell : SWTableViewCell

- (void)updateWithItem:(id<SWNWeatherDisplayableItem>)displayableItem;

@end
