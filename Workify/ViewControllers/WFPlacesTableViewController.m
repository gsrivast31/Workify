//
//  WFPlacesTableViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPlacesTableViewController.h"
#import "WFPlacesTableViewCell.h"
#import "WFNavigationController.h"
#import "WFLocationsViewController.h"

#import "WFAppDelegate.h"
#import "WFTooltipViewController.h"
#import "WFIntroductionTooltipView.h"
#import <Parse/Parse.h>

@interface WFPlacesTableViewController () <WFTooltipViewControllerDelegate>

@end

@implementation WFPlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = APP_NAME;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBarIconListMenu"] style:UIBarButtonItemStylePlain target:(WFNavigationController *)self.navigationController action:@selector(showMenu)];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kHasSeenStarterTooltip]) {
        [self showTips];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)showTips {
    WFAppDelegate *appDelegate = (WFAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *targetVC = appDelegate.viewController;
    
    WFTooltipViewController *modalView = [[WFTooltipViewController alloc] initWithParentVC:targetVC andDelegate:self];
    WFIntroductionTooltipView *tooltipView = [[WFIntroductionTooltipView alloc] initWithFrame:CGRectZero];
    [modalView setContentView:tooltipView];
    [modalView present];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = kWFCityClassKey;
        
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

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByDescending:kWFCityLocationsCountKey];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    WFPlacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];

    [cell configureCellWithObject:object];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLocations"]) {
        WFLocationsViewController* vc = (WFLocationsViewController*)segue.destinationViewController;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath.row < self.objects.count) {
            PFObject* obj = [self.objects objectAtIndex:indexPath.row];
            vc.cityObject = obj;
            vc.title = [obj valueForKey:kWFCityNameKey];
        }
    }
}

#pragma mark - Table view delegate

#pragma mark WFTooltipViewControllerDelegate

- (void)willDisplayModalView:(WFTooltipViewController *)aModalController {
    
}

- (void)didDismissModalView:(WFTooltipViewController *)aModalController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasSeenStarterTooltip];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
