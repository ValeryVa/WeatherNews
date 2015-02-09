//
//  SWNSettingsViewController.m
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

#import "SWNSettingsViewController.h"
#import "SWNAppAppearance.h"
#import "NSUserDefaults+Weather.h"

#import "SWNSettingsTableViewCell.h"

#import <PSTAlertController/PSTAlertController.h>

@implementation SWNSettingsViewController

static NSInteger kSWNSettingsUnitOfLengthsRow = 0;
static NSInteger kSWNSettingsUnitOfTemperatureRow = 1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)updateUnitOfLength:(SWNUnitOfLengthType)unitOfLength
{
    [[NSUserDefaults standardUserDefaults] setUnitOfLength:unitOfLength];
    [self updateData];
}

- (void)updateUnitOfTemperature:(SWNUnitOfTemperatureType)unitOfTemperature
{
    [[NSUserDefaults standardUserDefaults] setUnitOfTemperature:unitOfTemperature];
    [self updateData];
}

- (void)updateData
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate/DataSource methods


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* headerView = (UITableViewHeaderFooterView*)view;
    headerView.textLabel.font = [SWNAppAppearance semiboldFontWithSize:14];
    headerView.textLabel.textColor = [UIColor colorWithHex:@"2f91ff"];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWNSettingsTableViewCell* cell = (SWNSettingsTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* detailsText = nil;
    if (indexPath.row == kSWNSettingsUnitOfLengthsRow)
    {
        detailsText = [NSString lengthWithUnitType:defaults.unitOfLength];
    }else if (indexPath.row == kSWNSettingsUnitOfTemperatureRow)
    {
        detailsText = [NSString temperatureWithUnitType:defaults.unitOfTemperature];
    }
    
    [cell updateDetailsText:detailsText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == kSWNSettingsUnitOfLengthsRow)
    {
        PSTAlertController* alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Please select unit of length", @"")
                                                                                   message:nil
                                                                            preferredStyle:PSTAlertControllerStyleActionSheet];
        
        [alertController addAction:[PSTAlertAction actionWithTitle:[NSString lengthWithUnitType:SWNUnitOfLengthMeters] handler:^(PSTAlertAction *action) {
            
            [self updateUnitOfLength:SWNUnitOfLengthMeters];
            
        }]];
        
        [alertController addAction:[PSTAlertAction actionWithTitle:[NSString lengthWithUnitType:SWNUnitOfLengthMiles] handler:^(PSTAlertAction *action) {

            [self updateUnitOfLength:SWNUnitOfLengthMiles];

        }]];
        
        [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
            
        }]];

        [alertController showWithSender:self.tabBarController.tabBar controller:self animated:YES completion:nil];
    }else if (indexPath.row == kSWNSettingsUnitOfTemperatureRow)
    {
        PSTAlertController* alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Please select unit of temperature", @"")
                                                                                   message:nil
                                                                            preferredStyle:PSTAlertControllerStyleActionSheet];
        
        [alertController addAction:[PSTAlertAction actionWithTitle:[NSString temperatureWithUnitType:SWNUnitOfTemperatureCelsius] handler:^(PSTAlertAction *action) {
            
            [self updateUnitOfTemperature:SWNUnitOfTemperatureCelsius];
            
        }]];
        
        [alertController addAction:[PSTAlertAction actionWithTitle:[NSString temperatureWithUnitType:SWNUnitOfTemperatureFahrenheit] handler:^(PSTAlertAction *action) {

            [self updateUnitOfTemperature:SWNUnitOfTemperatureFahrenheit];

        }]];
        
        [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
            
        }]];
        
        [alertController showWithSender:self.tabBarController.tabBar controller:self animated:YES completion:nil];
    }
}

@end
