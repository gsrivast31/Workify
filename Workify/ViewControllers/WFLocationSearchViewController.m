//
//  WFLocationSearchViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/20/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationSearchViewController.h"
#import "WFLocationController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"
#import "WFAddressViewController.h"

@implementation WFDistanceView

@synthesize distanceLabel;
@synthesize arrowLabel;

- (id)initWithFrame:(CGRect)frame from:(CLLocation*)fromLocation to:(CLLocation*)toLocation {
    if (self = [super initWithFrame:frame]) {
        arrowLabel = [[UILabel alloc] init];
        [self addSubview:arrowLabel];
        
        distanceLabel = [[UILabel alloc] init];
        [self addSubview:distanceLabel];
        
        arrowLabel.font = [UIFont iconFontWithSize:14];
        arrowLabel.textAlignment = NSTextAlignmentRight;
        arrowLabel.textColor = [UIColor lightGrayColor];
        arrowLabel.text = [NSString iconStringForEnum:FUIArrowRight];
        
        distanceLabel.font = [UIFont italicFlatFontOfSize:12];
        distanceLabel.textAlignment = NSTextAlignmentRight;
        distanceLabel.textColor = [UIColor lightGrayColor];
        
        if (fromLocation != nil && toLocation != nil) {
            double distance = [fromLocation distanceFromLocation:toLocation];
            distanceLabel.text = [NSString stringWithFormat:@"%.1f km away", distance / 1000.0];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textHeight = [distanceLabel.text re_sizeWithFont:distanceLabel.font].height;
    distanceLabel.frame = CGRectMake(0.0, self.frame.size.height - textHeight, self.frame.size.width, textHeight);
    arrowLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - textHeight);
}

@end

@interface WFLocationSearchViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
{
    UISearchController* searchController;
    
    NSArray *searchResults;
}

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation WFLocationSearchViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Find Address";
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    [searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = searchController.searchBar;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.delegate = self;
    searchController.searchBar.delegate = self;
    searchController.searchBar.placeholder = @"Type an address";
    searchController.searchBar.barTintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.definesPresentationContext = YES;
    
    [self updateNavigationBar];
    
    self.currentPlaceMark = nil;
    __typeof (&*self) __weak weakSelf = self;
    
    [[WFLocationController sharedInstance] fetchUserLocationWithSuccess:^(CLLocation *location) {
        [[WFLocationController sharedInstance] reverseGeocodeLocation:location withSuccess:^(NSArray *placemarks) {
            if (placemarks.count) {
                weakSelf.currentPlaceMark = [placemarks objectAtIndex:0];
            }
        } failure:^(NSError *error) {
        }];
    } failure:^(NSError *error) {
    }];
}

- (void)updateNavigationBar {
    if(!self.navigationItem.leftBarButtonItem) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [backButton setImage:[[UIImage imageNamed:@"NavBarIconBack.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [backButton setTitle:self.navigationItem.backBarButtonItem.title forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10.0f, 0, 0)];
        [backButton setAdjustsImageWhenHighlighted:NO];
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    }
}

- (void) dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Logic
- (void)reloadViewData:(NSNotification *)note {
    [self.tableView reloadData];
    [self refreshView];
}

- (void)refreshView {
    // If we're actively searching refresh our data
    if (self.searchControllerWasActive) {
        searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[WFLocationController sharedInstance] geocodeString:searchBar.text withSuccess:^(NSArray *placemarks) {
        searchResults = placemarks;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        searchResults = nil;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchController setActive:NO];
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(searchController.isActive == NO) {
        return 1;
    } else {
        return 2 + [searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.font = [UIFont flatFontOfSize:15];
    cell.detailTextLabel.font = [UIFont flatFontOfSize:12];
    cell.tintColor = [UIColor turquoiseColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Current Location";
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"location"];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Can't find the address?";
        cell.detailTextLabel.text = @"Tap to add manually";
        cell.imageView.image = [UIImage imageNamed:@"add"];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        CLPlacemark* placemark = [searchResults objectAtIndex:indexPath.row - 2];
        cell.textLabel.text = placemark.name;
        cell.detailTextLabel.text = CFBridgingRelease(CFBridgingRetain(ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)));
        cell.imageView.image = [UIImage imageNamed:@"marker"];
        
        if (cell.accessoryView == nil) {
            cell.accessoryView = [[WFDistanceView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 40.0) from:self.currentPlaceMark.location to:placemark.location];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WFAddressViewController* vc = [[WFAddressViewController alloc] init];
    vc.delegate = self.delegate;
    if (indexPath.row == 0) {
        vc.placemark = self.currentPlaceMark;
        vc.title = self.currentPlaceMark.name;
    } else if (indexPath.row == 1) {
        vc.placemark = nil;
        vc.title = @"Add New Place";
    } else {
        CLPlacemark* placemark = [searchResults objectAtIndex:indexPath.row - 2];
        vc.placemark = placemark;
        vc.title = placemark.name;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - UIStateRestoration

/* we restore several items for state restoration:
 1) Search controller's active state,
 2) search text,
 3) first responder
 */
static NSString *ViewControllerTitleKey = @"ViewControllerTitleKey";
static NSString *SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchViewController = searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchViewController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchViewController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchViewController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

@end
