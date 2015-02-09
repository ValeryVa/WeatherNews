//
//  SWNForecastTableCell.m
//  WeatherNews
//
//  Created by ValeryV on 2/5/15.
//
//

#import "SWNWeatherTableCell.h"

@interface SWNWeatherTableCell()

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationIconImageView;

@end

@implementation SWNWeatherTableCell

NSString* const kSWNWeatherTableCellReuseIdentifier = @"weather_default_cell";

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)separatorInset
{
    return UIEdgeInsetsMake(0, 87, 0, 0);
}

- (void)updateWithItem:(id<SWNWeatherDisplayableItem>)displayableItem
{
    if ([displayableItem respondsToSelector:@selector(title)])
        self.mainLabel.text = [displayableItem title];

    if ([displayableItem respondsToSelector:@selector(subtitle)])
        self.subtitleLabel.text = [displayableItem subtitle];
    
    if ([displayableItem respondsToSelector:@selector(imageName)])
        self.iconImageView.image = [UIImage imageNamed:[displayableItem imageName]];

    if ([displayableItem respondsToSelector:@selector(temperature)])
        self.temperatureLabel.text = [displayableItem temperature];
    
    if ([displayableItem respondsToSelector:@selector(showsLocationIcon)])
        self.currentLocationIconImageView.hidden = ![displayableItem showsLocationIcon];
}

@end
