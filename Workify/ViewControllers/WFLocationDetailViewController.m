//
//  WFLocationDetailViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationDetailViewController.h"
#import "ParallaxHeaderView.h"
#import "RETableViewManager.h"
#import "WFDetailedItem.h"
#import "WFDetailedViewItem.h"
#import "WFTwoColumnItem.h"
#import "WFTwoColumnViewCell.h"

@interface WFLocationDetailViewController () <RETableViewManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;
@property (weak, nonatomic) IBOutlet UIButton *photosButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong, readwrite) RETableViewManager *manager;

@end

@implementation WFLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ParallaxHeaderView* headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"bkgnd1"] forSize:CGSizeMake(self.tableView.frame.size.width, 200)];
    headerView.headerTitleLabel.text = @"";
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.tintColor = [UIColor turquoiseColor];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFDetailedItem"] = @"WFDetailSingleItemCell";
    self.manager[@"WFDetailedViewItem"] = @"WFDetailsViewCell";
    self.manager[@"WFTwoColumnItem"] = @"WFTwoColumnViewCell";

    [self addTableEntries];
}

- (void)viewDidAppear:(BOOL)animated {
    [(ParallaxHeaderView*)self.tableView.tableHeaderView refreshBlurViewForNewImage];
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark -

- (void)addTableEntries {
    [self addGeneralSection];
    [self addHoursSection];
    [self addAmenitiesSection];
}

- (void)addGeneralSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    [section addItem:[WFDetailedViewItem itemWithName:@"Cafe Zoe" ratings:[NSNumber numberWithInteger:4] phone:@"+91-9717961964" email:@"gaurav.sri87@gmail.com" address:@"12/105, VikasNagar, Lucknow, U.P. - 226022" latitude:nil longitude:nil]];
    [section addItem:[WFDetailedItem itemWithTitle:@"About" subTitle:@"" imageName:nil]];
    [section addItem:[WFDetailedItem itemWithTitle:@"WiFi" subTitle:@"Reliable - 4Mbps download speed, 2Mbps upload speed" imageName:@"wifi"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Pricing" subTitle:@"Rs. 200" imageName:@"wifi"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Power" subTitle:@"1/2 per table" imageName:@"power"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Food" subTitle:@"Tea, Coffee, Snacks, Dinner, Alcohol, Desserts" imageName:@"food"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Noise" subTitle:@"Average Noisy" imageName:@"noise"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Seating" subTitle:@"Indoor, Outdoor, Standing Desks, Table for 2, Table for 4" imageName:@"seat"]];
}

- (void)addHoursSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    [section addItem:[WFTwoColumnItem itemWithTitle:@"Hours" imageName:@"calendar" contents:@[@{@"title":@"Mon", @"value":@"7am - 11pm"}, @{@"title":@"Tue", @"value":@"7am - 11pm"}, @{@"title":@"Wed", @"value":@"7am - 11pm"}, @{@"title":@"Thu", @"value":@"7am - 11pm"}, @{@"title":@"Fri", @"value":@"7am - 11pm"}, @{@"title":@"Sat", @"value":@"7am - 11pm"}, @{@"title":@"Sun", @"value":@"Closed"}]]];
}

- (void)addAmenitiesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];

    [section addItem:[WFTwoColumnItem itemWithTitle:@"Amenities" imageName:nil contents:
                      @[@{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Air Conditioner"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Television"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Dog Friendly"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Kid Friendly"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Washroom"}
                       ]]];
}

#pragma mark RETableViewManagerDelegate

- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WFTwoColumnViewCell class]]) {
        if ([cell respondsToSelector:@selector(setItemCount:)]) {
            WFTwoColumnItem *item = (WFTwoColumnItem*)[[[self.manager.sections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
            [(WFTwoColumnViewCell*)cell setItemCount:[[item contents] count]];
        }
    }
}

@end
