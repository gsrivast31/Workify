//
//  WFFiltersViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFFiltersViewController.h"
#import "RETableViewManager.h"
#import "WFDayItem.h"
#import "WFStepperItem.h"
#import "WFRatingItem.h"
#import "WFTagItem.h"
#import "WFTagViewCell.h"

@interface WFFiltersViewController () <RETableViewManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *daysSection;
@property (nonatomic, strong, readwrite) RETableViewSection *hoursSection;
@property (nonatomic, strong, readwrite) RETableViewSection *ratingSection;
@property (nonatomic, strong, readwrite) RETableViewSection *wifiSection;
@property (nonatomic, strong, readwrite) RETableViewSection *noiseSection;
@property (nonatomic, strong, readwrite) RETableViewSection *foodSection;
@property (nonatomic, strong, readwrite) RETableViewSection *seatingSection;
@property (nonatomic, strong, readwrite) RETableViewSection *powerSection;

@end

@implementation WFFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filters";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFDayItem"] = @"WFDaysTableViewCell";
    self.manager[@"WFStepperItem"] = @"WFStepperTableViewCell";
    self.manager[@"WFRatingItem"] = @"WFRatingViewCell";
    self.manager[@"WFTagItem"] = @"WFTagViewCell";
    self.manager[@"WFDetailedItem"] = @"RETableViewCell";
    self.daysSection = [self addDaysControls];
    self.ratingSection = [self addRatingControls];
    self.wifiSection = [self addWifiControls];
    self.noiseSection = [self addNoiseControls];
    self.foodSection = [self addFoodControls];
    self.seatingSection = [self addSeatingControls];
    self.powerSection = [self addPowerControls];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconSave"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor turquoiseColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor turquoiseColor];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender {
    
}

- (void)clear:(id)sender {
    
}

- (RETableViewSection*)addDaysControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Open Days"];
    [self.manager addSection:section];
    
    [section addItem:[WFDayItem item]];
    return section;
}

- (RETableViewSection*)addRatingControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Minimum Ratings"];
    [self.manager addSection:section];
    
    [section addItem:[WFRatingItem itemWithValue:[NSNumber numberWithInt:3]]];
    return section;
}

- (RETableViewSection*)addWifiControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Minimum Wifi Speed"];
    [self.manager addSection:section];
    
    [section addItem:[WFStepperItem itemWithValue:@"2 Mbps" andRange:@[@"256 Kbps", @"512 Kbps", @"1 Mbps", @"2 Mbps", @"4 Mbps", @"10 Mbps"]]];
    return section;
}

- (RETableViewSection*)addNoiseControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Noise level"];
    [self.manager addSection:section];
    
    [section addItem:[RESegmentedItem itemWithTitle:nil segmentedControlTitles:@[@"Silence", @"Avg. Noisy", @"Noisy"] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
        
    }]];
    return section;
}

- (RETableViewSection*)addFoodControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Dining Options"];
    [self.manager addSection:section];
    
    [section addItem:[RETableViewItem itemWithTitle:@"Coffee/Tea" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Alcohol" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Snacks" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Lunch" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Dinner" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    
    return section;
}

- (RETableViewSection*)addSeatingControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Seating Options"];
    [self.manager addSection:section];
    
    [section addItem:[RETableViewItem itemWithTitle:@"Indoor" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"OutDoor" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Separate Room" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Standing Desk" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Table for 1-4" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Table for 5>" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    
    return section;
}

- (RETableViewSection*)addPowerControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Power Options"];
    [self.manager addSection:section];
    
    [section addItem:[RETableViewItem itemWithTitle:@"None" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Limited(less than 1/4 tables)" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Good(Between 1/4 - 1/2 tables)" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    [section addItem:[RETableViewItem itemWithTitle:@"Enough(More than 1/2 tables)" accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
    }]];
    
    return section;
}

@end
