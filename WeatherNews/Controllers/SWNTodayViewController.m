//
//  SWNTodayViewController.m
//  WeatherNews
//
//  Created by ValeryV on 2/4/15.
//
//

#import "SWNTodayViewController.h"
#import "SWNLocation.h"
#import "SWNWeatherFeed.h"
#import "SWNWeatherCondition.h"

#import "UIViewController+SWNAdditions.h"
#import "NSUserDefaults+Weather.h"
#import "SWNCustomActivityItemProvider.h"

#import <Masonry/Masonry.h>
#import <Realm/Realm.h>
#import <extobjc.h>
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface SWNTodayViewController()

@property (weak, nonatomic) IBOutlet UIView *todayContainer;
@property (weak, nonatomic) IBOutlet UIImageView *autoLocationIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeOfRainLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionImageView;

@property (nonatomic, strong, readonly) UILabel* noDataLabel;

@property (nonatomic, strong) RLMNotificationToken* realmToken;
@property (nonatomic, strong) id userDefaultsObserver;
@property (nonatomic) BOOL canShowAlerts;

@end

@implementation SWNTodayViewController

@synthesize noDataLabel = _noDataLabel;

- (UILabel *)noDataLabel
{
    if (_noDataLabel == nil)
    {
        _noDataLabel = [[self class] createEmptyDataSourceLabel];
        
        [self.view addSubview:_noDataLabel];
        
        UIView* superview = self.view;
        [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(superview);
            make.left.equalTo(superview.mas_left).with.offset(10);
            make.right.equalTo(superview.mas_right).with.offset(-10);

            
        }];
    }
    return _noDataLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.userDefaultsObserver];
    self.userDefaultsObserver = nil;
    
    [[RLMRealm defaultRealm] removeNotification:self.realmToken];
    self.realmToken = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canShowAlerts = YES;
    
    SWNWeatherFeed* feed = [SWNWeatherFeed feed];
    [self updateUIWithWeatherFeed:feed];
    
    @weakify(self)
    self.userDefaultsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  
                                                                                  @strongify(self);
                                                                                  [self updateUIWithWeatherFeed:feed];
                                                                                  
                                                                              }];
    
    self.realmToken = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
       
        @strongify(self)
        if ([notification isEqualToString:RLMRealmDidChangeNotification])
        {
            [self updateUIWithWeatherFeed:feed];
        }
        DEBUG_LOG(@"%@", notification);
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.canShowAlerts)
    {
        if ([CLLocationManager isLocationUpdatesAvailable] == NO)
        {
            [self showLocationServicesErrorWithCallback:nil];
        }
        
        self.canShowAlerts = NO;
    }
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO)
    {
        [self showInternetConnectionErrorAsAlert:NO];
    }
}

- (void)updateUIWithWeatherFeed:(SWNWeatherFeed*)feed
{
    SWNLocation* location = [feed fetchCurrentLocation];
    BOOL isDataInvalid = location == nil || location.forecast.count == 0;
    
    if (self.todayContainer.hidden)
    {
        self.todayContainer.hidden = isDataInvalid;
        self.noDataLabel.hidden = !isDataInvalid;
    }else
    {
        self.noDataLabel.hidden = YES;
    }

    if (isDataInvalid == NO)
    {
        SWNWeatherCondition* condition = location.currentCondition;
        if (condition)
        {
            self.locationNameLabel.text = location.fullLocationName;
            self.autoLocationIconImageView.hidden = !([location isKindOfClass:[SWNAutoLocation class]] && [CLLocationManager isLocationUpdatesAvailable]);
            
            SWNUnitOfTemperatureType temperatureType = [NSUserDefaults standardUserDefaults].unitOfTemperature;
            BOOL isInCelcius = temperatureType == SWNUnitOfTemperatureCelsius;
            self.currentConditionLabel.text = [NSString stringWithFormat:@"%ld°%@ | %@", (isInCelcius) ? (long)condition.temperatureInCelsius : (long)condition.temperatureInFahrenheit,
                                               [NSString temperatureSignWithUnitType:temperatureType],
                                               condition.weatherDescription];
            
            self.changeOfRainLabel.text = [NSString stringWithFormat:@"%ld%%", (long)condition.chanceOfRain];
            self.precipitationLabel.text = [NSString stringWithFormat:@"%.2f mm", condition.precipitation];
            self.pressureLabel.text = [NSString stringWithFormat:@"%ld hPa", (long)condition.pressure];
            
            SWNUnitOfLengthType lengthType = [NSUserDefaults standardUserDefaults].unitOfLength;
            BOOL isInKmh = lengthType == SWNUnitOfLengthMeters;
            self.windSpeedLabel.text = [NSString stringWithFormat:@"%ld %@", (isInKmh) ? (long)condition.windSpeedInKmh : (long) condition.windSpeedInMiles,
                                        [NSString lengthSignWithUnitType:lengthType]];
            
            self.windDirectionLabel.text = condition.windDirection;

            NSString* imageName = [NSString stringWithFormat:@"%@_big", [NSString conditionImageNameForWeatherType:condition.weatherType]];
            self.conditionImageView.image = [UIImage imageNamed:imageName];
        }        
    }
}

#pragma mark -
#pragma mark Actions

- (NSString*)sharingText
{
    SWNWeatherFeed* feed = [SWNWeatherFeed feed];
    SWNLocation* location = [feed fetchCurrentLocation];
    
    if (location == nil)
        return nil;
    
    SWNWeatherCondition* condition = location.currentCondition;
    
    SWNUnitOfTemperatureType temperatureType = [NSUserDefaults standardUserDefaults].unitOfTemperature;
    BOOL isInCelcius = temperatureType == SWNUnitOfTemperatureCelsius;

    NSString *text = [NSString stringWithFormat:@"Today in %@ is %ld°%@, %@", location.locationName,
                      (isInCelcius) ? (long)condition.temperatureInCelsius : (long)condition.temperatureInFahrenheit,
                      [NSString temperatureSignWithUnitType:temperatureType],
                      condition.weatherDescription];
    
    return text;
}

- (IBAction)shareButtonPressed:(id)sender
{
    NSString *text = [self sharingText];
    SWNCustomActivityItemProvider *customTextItem = [[SWNCustomActivityItemProvider alloc] initWithDefaultText:text];
    customTextItem.customText[UIActivityTypePostToFacebook] = text;
    customTextItem.customText[UIActivityTypePostToTwitter] = text;
    customTextItem.customText[UIActivityTypeMail] = text;
    NSArray *items = @[customTextItem];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:items
                                                    applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeAssignToContact];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}


@end
