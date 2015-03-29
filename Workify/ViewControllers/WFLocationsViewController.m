//
//  WFLocationsViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationsViewController.h"
#import "WFLocationTableViewCell.h"
#import "SGActionView.h"
#import "SGSheetMenu.h"

#import "WFFiltersViewController.h"
#import "WFLocationDetailViewController.h"
#import <Parse/Parse.h>

#define N(x) [NSNumber numberWithInt: x]

@interface WFLocationsViewController () </*UITableViewDataSource, UITableViewDelegate, */WFFilterDelegate>
{
    NSInteger currentMaxDisplayedCell;
    NSInteger currentMaxDisplayedSection;
}

//@property (weak, nonatomic) IBOutlet UIView *footerView;
//@property (weak, nonatomic) IBOutlet UIButton *filterButton;
//@property (weak, nonatomic) IBOutlet UIButton *sortButton;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSNumber* cellZoomXScaleFactor;
@property (strong, nonatomic) NSNumber* cellZoomYScaleFactor;
@property (strong, nonatomic) NSNumber* cellZoomXOffset;
@property (strong, nonatomic) NSNumber* cellZoomYOffset;
@property (strong, nonatomic) NSNumber* cellZoomInitialAlpha;
@property (strong, nonatomic) NSNumber* cellZoomAnimationDuration;

@property (strong, nonatomic) NSNumber* minRatingFilter;
@property (strong, nonatomic) NSNumber* minWifiSpeedFilter;
@property (strong, nonatomic) NSNumber* spaceTypeFilter;
@property (strong, nonatomic) NSArray* openDaysFilter;

@property (strong, nonatomic) UIButton* filterButton;

-(void)resetViewedCells;

@end

@implementation WFLocationsViewController

@synthesize cellZoomXScaleFactor = _xZoomFactor;
@synthesize cellZoomYScaleFactor = _yZoomFactor;
@synthesize cellZoomAnimationDuration = _animationDuration;
@synthesize cellZoomInitialAlpha = _initialAlpha;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger filterCount = (self.minRatingFilter?1:0) + (self.minWifiSpeedFilter?1:0) + (self.spaceTypeFilter?1:0) + (self.openDaysFilter?1:0);
    /*self.tableView.dataSource = self;
    self.tableView.delegate = self;
    */
    //self.title = @"Mumbai";
    
//    [self.sortButton addTarget:self action:@selector(showSortMenu:) forControlEvents:UIControlEventTouchUpInside];

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
    
    self.filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 31)];
    [self.filterButton setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [self.filterButton addTarget:self action:@selector(filter:)forControlEvents:UIControlEventTouchUpInside];
    
    NSString* filterString = nil;
    if (filterCount) {
        filterString = [NSString stringWithFormat:@"(%ld)", (long)filterCount];
    }
    [self.filterButton setTitle:filterString forState:UIControlStateNormal];
    [self.filterButton.titleLabel setFont:[UIFont flatFontOfSize:17]];
    [self.filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.filterButton];
    self.navigationItem.rightBarButtonItem = barButton;
    
    /*self.footerView.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.filterButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.filterButton setTintColor:[UIColor whiteColor]];
    [self.filterButton setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];*/
/*    [self.sortButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.sortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sortButton setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [self.sortButton setTintColor:[UIColor whiteColor]];*/
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)filter:(id)sender {
    UINavigationController* navVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"filtersNavVC"];
    WFFiltersViewController* vc = (WFFiltersViewController*)navVC.topViewController;
    vc.delegate = self;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = kWFLocationClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        // self.objectsPerPage = 10;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = YES;
    }
    return self;
}

- (NSNumber*)minWifiSpeed:(NSInteger)index {
    double val = 0.0f;
    switch (index) {
        case WFWifiSpeed0Mbps:
            val = 0.0f;
            break;
        case WFWifiSpeed256Kbps:
            val = 0.256f;
            break;
        case WFWifiSpeed512Kbps:
            val = 0.512f;
            break;
        case WFWifiSpeed1Mbps:
            val = 1.0f;
            break;
        case WFWifiSpeed2Mbps:
            val = 2.0f;
            break;
        case WFWifiSpeed4Mbps:
            val = 4.0f;
            break;
        case WFWifiSpeed10Mbps:
            val = 10.0f;
            break;
        default:
            break;
    }
    return [NSNumber numberWithDouble:val];
}

- (PFQuery *)queryForTable {
    PFRelation* relation = [self.cityObject relationForKey:kWFCityLocationsKey];
    PFQuery* query = [relation query];
    [query selectKeys:@[kWFLocationNameKey,
                        kWFLocationWifiDownloadSpeedKey,
                        kWFLocationWifiUploadSpeedKey,
                        kWFLocationRatingsKey,
                        kWFLocationAddressKey,
                        kWFLocationTypeKey,
                        kWFLocationDisplayPhotoKey]];
    
    self.minRatingFilter = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterRatings];
    self.openDaysFilter = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterOpenDays];
    self.spaceTypeFilter = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterSpaceType];
    self.minWifiSpeedFilter = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterWifiSpeed];
    
    if (self.spaceTypeFilter) {
        [query whereKey:kWFLocationTypeKey equalTo:self.spaceTypeFilter];
    }
    if (self.minRatingFilter) {
        [query whereKey:kWFLocationRatingsKey greaterThanOrEqualTo:self.minRatingFilter];
    }
    if (self.minWifiSpeedFilter) {
        [query whereKey:kWFLocationWifiDownloadSpeedKey greaterThanOrEqualTo:[self minWifiSpeed:[self.minWifiSpeedFilter integerValue]]];
    }
    if (self.openDaysFilter) {
        [query whereKey:kWFLocationOpenDaysKey containedIn:self.openDaysFilter];
    }
    
    [query orderByDescending:kWFLocationRatingsKey];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    WFLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    
    [cell configureCellForObject:object];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    
    [cell configureCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 0 && currentMaxDisplayedCell == 0) || indexPath.section > currentMaxDisplayedSection){
        currentMaxDisplayedCell = -1;
    }
    
    if (indexPath.section >= currentMaxDisplayedSection && indexPath.row > currentMaxDisplayedCell){
        cell.contentView.alpha = self.cellZoomInitialAlpha.floatValue;
        
        CGAffineTransform transformScale = CGAffineTransformMakeScale(self.cellZoomXScaleFactor.floatValue, self.cellZoomYScaleFactor.floatValue);
        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(self.cellZoomXOffset.floatValue, self.cellZoomYOffset.floatValue);
        
        cell.contentView.transform = CGAffineTransformConcat(transformScale, transformTranslate);
        
        [self.tableView bringSubviewToFront:cell.contentView];
        [UIView animateWithDuration:self.cellZoomAnimationDuration.floatValue
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cell.contentView.alpha = 1;
                             //clear the transform
                             cell.contentView.transform = CGAffineTransformIdentity;
                         } completion:nil];
        
        
        currentMaxDisplayedCell = indexPath.row;
        currentMaxDisplayedSection = indexPath.section;
    }
}*/

-(void)resetViewedCells{
    currentMaxDisplayedSection = 0;
    currentMaxDisplayedCell = 0;
}

/*
- (void)showSortMenu:(id)sender {
    [SGActionView showSheetWithTitle:@"Sort By" itemTitles:@[@"Ratings", @"Wifi Speed", @"Average Cost"] selectedIndex:0 selectedHandle:^(NSInteger index) {
        if (index ==0) { //Ratings
            
        } else if (index == 1) { //Wifi Speed
            
        } else { //Average Daily Cost
            
        }
    }];
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"filterSegue"]) {
        UINavigationController* navVC = (UINavigationController*)segue.destinationViewController;
        WFFiltersViewController* vc = (WFFiltersViewController*)navVC.topViewController;
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"locationDetailSegue"]) {
        WFLocationDetailViewController* vc = (WFLocationDetailViewController*)segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath.row < self.objects.count) {
            PFObject* obj = [self.objects objectAtIndex:indexPath.row];
            vc.locationId = obj.objectId;
            vc.title = [obj valueForKey:kWFLocationNameKey];
        }
    }
}

#pragma -mark Setters for four customisable variables

-(void)setCellZoomXScaleFactor:(NSNumber *)xZoomFactor{
    _xZoomFactor = xZoomFactor;
}

-(void)setCellZoomYScaleFactor:(NSNumber *)yZoomFactor{
    _yZoomFactor = yZoomFactor;
}

-(void)setCellZoomAnimationDuration:(NSNumber *)animationDuration{
    _animationDuration = animationDuration;
}

-(void)setCellZoomInitialAlpha:(NSNumber *)initialAlpha{
    _initialAlpha = initialAlpha;
}

#pragma -mark Getters for four customisable variable. Provide default if not set.

-(NSNumber *)cellZoomXScaleFactor{
    if (_xZoomFactor == nil){
        _xZoomFactor = [NSNumber numberWithFloat:1.25];
    }
    return _xZoomFactor;
}

-(NSNumber *)cellZoomXOffset{
    if (_cellZoomXOffset == nil){
        _cellZoomXOffset = [NSNumber numberWithFloat:0];
    }
    return _cellZoomXOffset;
}

-(NSNumber *)cellZoomYOffset{
    if (_cellZoomYOffset == nil){
        _cellZoomYOffset = [NSNumber numberWithFloat:0];
    }
    return _cellZoomYOffset;
}

-(NSNumber *)cellZoomYScaleFactor{
    if (_yZoomFactor == nil){
        _yZoomFactor = [NSNumber numberWithFloat:1.25];
    }
    return _yZoomFactor;
}

-(NSNumber *)cellZoomAnimationDuration{
    if (_animationDuration == nil){
        _animationDuration = [NSNumber numberWithFloat:0.65];
    }
    return _animationDuration;
}

-(NSNumber *)cellZoomInitialAlpha{
    if (_initialAlpha == nil){
        _initialAlpha = [NSNumber numberWithFloat:0.3];
    }
    return _initialAlpha;
}

#pragma mark WFFilterDelegate 

- (void)filtersAdded:(NSDictionary *)filterDictionary {
    self.minRatingFilter = [filterDictionary objectForKey:kFilterRatings];
    self.minWifiSpeedFilter = [filterDictionary objectForKey:kFilterWifiSpeed];
    self.spaceTypeFilter = [filterDictionary objectForKey:kFilterSpaceType];
    self.openDaysFilter = [[filterDictionary objectForKey:kFilterOpenDays] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber *)obj1 compare:(NSNumber *)obj2] == NSOrderedDescending;
    }];
    
    NSInteger filterCount = 0;
    if ([self.minRatingFilter integerValue] == 0) {
        self.minRatingFilter = nil;
    } else filterCount++;
    
    if ([self.spaceTypeFilter integerValue] == -1) {
        self.spaceTypeFilter = nil;
    } else filterCount++;
    
    if ([self.openDaysFilter isEqual:@[N(0), N(1), N(2), N(3), N(4), N(5), N(6)]] || [self.openDaysFilter isEqual:@[]]) {
        self.openDaysFilter = nil;
    } else filterCount++;
    
    if ([self.minWifiSpeedFilter integerValue] == WFWifiSpeed0Mbps) {
        self.minWifiSpeedFilter = nil;
    } else filterCount++;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.minRatingFilter forKey:kFilterRatings];
    [[NSUserDefaults standardUserDefaults] setObject:self.openDaysFilter forKey:kFilterOpenDays];
    [[NSUserDefaults standardUserDefaults] setObject:self.spaceTypeFilter forKey:kFilterSpaceType];
    [[NSUserDefaults standardUserDefaults] setObject:self.minWifiSpeedFilter forKey:kFilterWifiSpeed];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loadObjects];
    if (filterCount) {
        [self.filterButton setTitle:[NSString stringWithFormat:@"(%ld)", (long)filterCount] forState:UIControlStateNormal];
    } else {
        [self.filterButton setTitle:@"" forState:UIControlStateNormal];
    }
}

@end
