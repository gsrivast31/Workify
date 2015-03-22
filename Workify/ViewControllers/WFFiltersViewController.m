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
@property (nonatomic, strong, readwrite) RETableViewSection *spaceSection;
@property (nonatomic, strong, readwrite) RETableViewSection *daysSection;
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
    self.manager[@"WFRatingItem"] = @"WFRatingCell";
    self.manager[@"WFTagItem"] = @"WFTagViewCell";
    self.manager[@"WFDetailedItem"] = @"RETableViewCell";
    self.spaceSection = [self addSpaceTypeControls];
    self.daysSection = [self addDaysControls];
    self.ratingSection = [self addRatingControls];
    self.wifiSection = [self addWifiControls];
    self.noiseSection = [self addNoiseControls];
    self.foodSection = [self addFoodControls];
    self.seatingSection = [self addSeatingControls];
    self.powerSection = [self addPowerControls];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconSave"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    self.clearButton.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.clearButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender {
    
}

- (void)clear:(id)sender {
    
}

- (RETableViewSection*)addSpaceTypeControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Space Type"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    void (^changeState)(RETableViewItem *item) = ^(RETableViewItem *item){
        UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:item.indexPath];
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    };

    for (NSString* value in [WFStringStore spaceTypeStrings]) {
        [section addItem:[RETableViewItem itemWithTitle:value accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
            changeState(item);
        }]];
    }
    return section;
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
    
    [section addItem:[WFStepperItem itemWithValue:[WFStringStore wifiSpeedString:WFWifiSpeed1Mbps] andRange:[WFStringStore wifiSpeedStrings]]];

    return section;
}

- (RETableViewSection*)addNoiseControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Noise level"];
    [self.manager addSection:section];
    
    RESegmentedItem* item = [RESegmentedItem itemWithTitle:nil segmentedControlTitles:[WFStringStore noiseStrings] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
    }];

    item.tintColor = [UIColor turquoiseColor];
    [section addItem:item];
    return section;
}

- (RETableViewSection*)addFoodControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Dining Options"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    void (^changeState)(RETableViewItem *item) = ^(RETableViewItem *item){
        UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:item.indexPath];
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    };
    
    for (NSString* key in [WFStringStore foodStrings]) {
        [section addItem:[RETableViewItem itemWithTitle:key accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
            changeState(item);
        }]];
    }
    return section;
}

- (RETableViewSection*)addSeatingControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Seating Options"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    void (^changeState)(RETableViewItem *item) = ^(RETableViewItem *item){
        UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:item.indexPath];
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    };
    
    for (NSString* key in [WFStringStore seatingStrings]) {
        [section addItem:[RETableViewItem itemWithTitle:key accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
            changeState(item);
        }]];
    }

    return section;
}

- (RETableViewSection*)addPowerControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Power Options"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    void (^changeState)(RETableViewItem *item) = ^(RETableViewItem *item){
        UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:item.indexPath];
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    };

    for (NSString* key in [WFStringStore powerStrings]) {
        [section addItem:[RETableViewItem itemWithTitle:key accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
            changeState(item);
        }]];
    }

    return section;
}

@end
