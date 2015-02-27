//
//  SWNAppAppearance.m
//  WeatherNews
//
//  Created by ValeryV on 2/3/15.
//
//

#import "SWNAppAppearance.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>

NSString* const kSWNStatusBarNotificationStyle = @"SWNDefault";

@implementation SWNAppAppearance

+ (void)configure
{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"navigation_bar_bottom_line"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[self semiboldFontWithSize:18]}];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithHex:@"2f91ff"]];
    
    [[UIToolbar appearance] setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setShadowImage:[UIImage imageNamed:@"navigation_bar_bottom_line"] forToolbarPosition:UIBarPositionTop];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[self semiboldFontWithSize:10],
                                                        NSForegroundColorAttributeName: [UIColor colorWithHex:@"333333"]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [self semiboldFontWithSize:10],
                                                        NSForegroundColorAttributeName: [UIColor colorWithHex:@"2f91ff"]}
                                             forState:UIControlStateSelected];
    
    [JDStatusBarNotification addStyleNamed:kSWNStatusBarNotificationStyle prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        
        style.barColor = [UIColor colorWithHex:@"fecb45"];
        style.textColor = [UIColor colorWithHex:@"333333"];
        style.font = [SWNAppAppearance lightFontWithSize:12];
        style.animationType = JDStatusBarAnimationTypeMove;
        
        return style;
        
    }];
}

+ (UIFont*)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"ProximaNova-Regular" size:size];
}

+ (UIFont*)lightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"ProximaNova-Light" size:size];
}

+ (UIFont*)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"ProximaNova-Bold" size:size];
}

+ (UIFont*)semiboldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"ProximaNova-Semibold" size:size];
}

@end
