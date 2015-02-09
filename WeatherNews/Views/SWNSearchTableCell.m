//
//  SWNSearchTableCell.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "SWNSearchTableCell.h"
#import "SWNAppAppearance.h"

@interface SWNSearchTableCell()

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@end

@implementation SWNSearchTableCell

NSString* const kSWNSearchTableCellReuseIdentifier = @"search_cell";

- (void)updateWithLocationName:(NSString*)locationName
                       country:(NSString*)country
{
    NSString* compoundString = [NSString stringWithFormat:@"%@, %@", locationName, country];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:compoundString];
    NSRange locationNameRange = [compoundString rangeOfString:locationName];
    locationNameRange.length += 1;
    [attributedString addAttributes:@{NSFontAttributeName:[SWNAppAppearance semiboldFontWithSize:16]} range:locationNameRange];
    [attributedString addAttributes:@{NSFontAttributeName:[SWNAppAppearance lightFontWithSize:16]} range:[compoundString rangeOfString:country]];
    
    self.mainLabel.attributedText = attributedString;
}

@end
