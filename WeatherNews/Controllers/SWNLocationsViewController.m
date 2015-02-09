//
//  SWNLocationsViewController.m
//  WeatherNews
//
//  Created by ValeryV on 2/5/15.
//
//

#import "SWNLocationsViewController.h"
#import "SWNWeatherTableCell.h"
#import "SWNWeatherFeed.h"

#import <Realm/Realm.h>
#import <extobjc.h>

@interface SWNLocationsViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) CAGradientLayer* gradientLayer;

@property (nonatomic, strong, readonly) NSMutableArray* locations;

@property (nonatomic, strong) RLMNotificationToken* realmToken;
@property (nonatomic, strong) id userDefaultsObserver;


@end

@implementation SWNLocationsViewController

@synthesize gradientLayer = _gradientLayer;
@synthesize locations = _locations;

- (CAGradientLayer *)gradientLayer
{
    if (_gradientLayer == nil)
    {
        _gradientLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        
        _gradientLayer.colors = @[(__bridge id)innerColor, (__bridge id)outerColor];
        _gradientLayer.locations = @[@(0.7), @(1.0)];
        
        _gradientLayer.bounds = self.tableView.bounds;
        _gradientLayer.anchorPoint = CGPointZero;

    }
    
    return _gradientLayer;
}

- (NSMutableArray *)locations
{
    if (_locations == nil)
        _locations = [NSMutableArray array];
    
    return _locations;
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

    [self.tableView registerNib:[SWNWeatherTableCell swn_customNibForView] forCellReuseIdentifier:kSWNWeatherTableCellReuseIdentifier];
    self.tableView.contentInset = self.tableView.scrollIndicatorInsets;
    
    [self.tableView.layer addSublayer:self.gradientLayer];
    
    [self reloadData];
    
    @weakify(self)
    self.userDefaultsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  
                                                                                  @strongify(self);
                                                                                  [self reloadData];
                                                                                  
                                                                              }];
    
    self.realmToken = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        
        @strongify(self);
        [self reloadData];
        
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.gradientLayer.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

#pragma mark -
#pragma mark Actions

- (void)reloadData
{
    [self.locations removeAllObjects];
    
    SWNWeatherFeed* feed = [SWNWeatherFeed feed];
    if (feed.autoLocation)
    {
        [self.locations addObject:feed.autoLocation];
    }
    for (NSInteger i = 0; i < feed.locations.count; i++)
    {
        SWNLocation* location = [[SWNLocation alloc] initWithObject:feed.locations[i]];
        [self.locations addObject:location];
    }
        
    [self.tableView reloadData];
    
    self.tableView.hidden = (self.locations.count == 0);
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWNWeatherTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kSWNWeatherTableCellReuseIdentifier forIndexPath:indexPath];
    
    id<SWNWeatherDisplayableItem> item = self.locations[indexPath.row];
    [cell updateWithItem:item];
    
    if ([item isKindOfClass:[SWNAutoLocation class]] == NO)
    {
        NSMutableArray* rightUtilityButton = [NSMutableArray new];
        [rightUtilityButton sw_addUtilityButtonWithColor:[UIColor colorWithHex:@"fd884f"]
                                                    icon:[UIImage imageNamed:@"cell_accessory_delete_button"]];
        cell.rightUtilityButtons = rightUtilityButton;
        cell.delegate = self;
    }else
    {
        cell.rightUtilityButtons = nil;
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark SWTableViewCellDelegate methods

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    if (index == 0)
    {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        SWNLocation* location = self.locations[indexPath.row];
        [self.locations removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // TODO: change implementation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [[SWNWeatherFeed feed] removeLocation:location];
            
        });
        
    }
}


@end
