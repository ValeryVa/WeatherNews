//
//  UIViewController+SWNAdditions.m
//  WeatherNews
//
//  Created by ValeryV on 2/28/15.
//
//

#import "UIViewController+SWNAdditions.h"
#import "SWNAppAppearance.h"
#import <PSTAlertController/PSTAlertController.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>

@implementation UIViewController (SWNAdditions)

+ (UILabel*)createEmptyDataSourceLabel
{
    UILabel* emptyDataSourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    emptyDataSourceLabel.font = [SWNAppAppearance regularFontWithSize:18];
    emptyDataSourceLabel.textColor = [UIColor colorWithHex:@"333333"];
    emptyDataSourceLabel.numberOfLines = 0;
    emptyDataSourceLabel.textAlignment = NSTextAlignmentCenter;
    emptyDataSourceLabel.backgroundColor = [UIColor clearColor];
    emptyDataSourceLabel.text = NSLocalizedString(@"Currently there are no locations. Please add at least one location", @"");
    
    return emptyDataSourceLabel;
}

- (void)showLocationServicesErrorWithCallback:(dispatch_block_t)callback
{
    PSTAlertController* alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Enable location services", @"")
                                                                               message:NSLocalizedString(@"Location services are not enabled. The app uses location services to detect your current weather conditions", @"")
                                                                        preferredStyle:PSTAlertControllerStyleAlert];
    [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") handler:^(PSTAlertAction *action) {
        
        if (callback)
            callback();
        
    }]];
    [alertController showWithSender:self.view controller:self animated:YES completion:nil];
}

- (void)showInternetConnectionErrorAsAlert:(BOOL)showAsAlert
{
    if (showAsAlert == NO)
    {
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"There is no internet connection", @"")
                                   dismissAfter:3.0
                                      styleName:kSWNStatusBarNotificationStyle];
    }else
    {
        PSTAlertController* alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"No internet connection", @"")
                                                                                   message:NSLocalizedString(@"There is no internet connection. Please try again later", @"")
                                                                            preferredStyle:PSTAlertControllerStyleAlert];
        [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") handler:nil]];
        [alertController showWithSender:self.view controller:self animated:YES completion:nil];
    }
}

@end
