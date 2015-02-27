//
//  UIViewController+SWNAdditions.h
//  WeatherNews
//
//  Created by ValeryV on 2/28/15.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (SWNAdditions)

+ (UILabel*)createEmptyDataSourceLabel;
- (void)showLocationServicesErrorWithCallback:(dispatch_block_t)callback;
- (void)showInternetConnectionErrorAsAlert:(BOOL)showAsAlert;

@end
