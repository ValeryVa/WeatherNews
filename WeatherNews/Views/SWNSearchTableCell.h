//
//  SWNSearchTableCell.h
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

@import UIKit;

extern NSString* const kSWNSearchTableCellReuseIdentifier;

@interface SWNSearchTableCell : UITableViewCell

- (void)updateWithLocationName:(NSString*)locationName
                       country:(NSString*)country;

@end
