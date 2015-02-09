//
//  SWNAddLocationViewController.m
//  WeatherNews
//
//  Created by ValeryV on 2/9/15.
//
//

#import "SWNAddLocationViewController.h"

#import "SWNWeatherClient.h"
#import "SWNWeatherRequest.h"
#import "SWNWeatherFeed.h"

#import "SWNSearchTableCell.h"

#import <extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SWNAddLocationViewController() <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, copy) NSString* currentSearchText;
@property (nonatomic, strong) SWNWeatherRequestID searchRequestID;

@property (nonatomic, strong) NSMutableArray* locations;

@end

@implementation SWNAddLocationViewController

static NSInteger kSWNSearchDefaultDelay = 1.4;
static NSInteger kSWNSearchMinTextLength = 3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[SWNSearchTableCell swn_customNibForView] forCellReuseIdentifier:kSWNSearchTableCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardObservers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardObservers];
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)startSearchWithText:(NSString*)text
{
    if (self.searchRequestID.length > 0)
        [[SWNWeatherClient instance] cancelRequestWithID:self.searchRequestID];
    
    self.currentSearchText = text;
    
    @weakify(self)
    SWNWeatherRequest* request = [SWNWeatherRequest locationsWithQueryText:self.currentSearchText];
    self.searchRequestID = [[SWNWeatherClient instance] performRequest:request callback:^(NSArray *results, NSError *error) {
       
        @strongify(self)
        self.searchRequestID = nil;
        
        self.locations = [NSMutableArray arrayWithArray:results];
        [self.tableView reloadData];
        
    }];
}

#pragma mark -
#pragma mark UISearchBarDelegate methods

- (void)initializeSearchWithText:(NSString*)searchText
{
    if (searchText.length < kSWNSearchMinTextLength)
        return;
    
    if ([searchText isEqualToString:self.currentSearchText])
        return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(startSearchWithText:) withObject:searchText afterDelay:kSWNSearchDefaultDelay];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self initializeSearchWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self initializeSearchWithText:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self initializeSearchWithText:searchBar.text];
}

#pragma mark -
#pragma mark UITableViewDelegate/DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWNSearchTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kSWNSearchTableCellReuseIdentifier forIndexPath:indexPath];
    
    SWNLocation* location = self.locations[indexPath.row];
    [cell updateWithLocationName:location.locationName country:location.country];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SWNLocation* location = self.locations[indexPath.row];
    [[SWNWeatherFeed feed] addLocation:location];
    
    [SVProgressHUD showSuccessWithStatus:@"Added"];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Keyboard actions/notifications

- (void)addKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSTimeInterval animationDuration = 0;
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    CGRect keyboardEndFrame = CGRectZero;
    
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         
                         [self keyboardWillBeShownAnimationActionWithFrame:keyboardEndFrame];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSTimeInterval animationDuration = 0;
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         
                         [self keyboardWillBeHiddenAnimationAction];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)keyboardWillBeShownAnimationActionWithFrame:(CGRect)keyboardFrame
{
    CGRect tableViewFrame = [self.view convertRect:self.tableView.frame toView:self.navigationController.view];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, tableViewFrame.origin.y + tableViewFrame.size.height - keyboardFrame.origin.y, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
}

- (void)keyboardWillBeHiddenAnimationAction
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
}

@end
