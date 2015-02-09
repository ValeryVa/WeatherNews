//
//  SWNSettingsTableViewCell.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "SWNSettingsTableViewCell.h"

@interface SWNSettingsTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel* mainLabel;
@property (nonatomic, weak) IBOutlet UILabel* detailsLabel;

@end

@implementation SWNSettingsTableViewCell

- (void)updateDetailsText:(NSString*)detailsText
{
    self.detailsLabel.text = detailsText;
}

@end
