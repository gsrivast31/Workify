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

@interface WFFiltersViewController () <RETableViewManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
//@property (nonatomic, strong) NSMutableArray* spaceTypeItemsArray;
@property (nonatomic, strong) WFDayItem* dayItem;
@property (nonatomic, strong) WFRatingItem* ratingItem;
@property (nonatomic, strong) WFStepperItem* wifiItem;
@property (nonatomic, strong) RESegmentedItem* spaceTypeItem;

@end

@implementation WFFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filters";
    
//    self.spaceTypeItemsArray = [[NSMutableArray alloc] init];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFDayItem"] = @"WFDaysTableViewCell";
    self.manager[@"WFStepperItem"] = @"WFStepperTableViewCell";
    self.manager[@"WFRatingItem"] = @"WFRatingCell";
    [self addTableEntries];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconSave"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    self.clearButton.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.clearButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save:(id)sender {
    /*NSMutableArray* spaceTypeValues = [NSMutableArray array];
    
    for (RETableViewItem* item in self.spaceTypeItemsArray) {
        if (item.accessoryType == UITableViewCellAccessoryCheckmark) {
            WFSpaceType type = (WFSpaceType)[WFStringStore spaceTypeIndex:item.title];
            [spaceTypeValues addObject:[NSNumber numberWithInteger:type]];
        }
    }
    */
    NSNumber* spaceType = [NSNumber numberWithInteger:self.spaceTypeItem.value];
    NSArray* dayValues = self.dayItem.value;
    NSNumber* minimumRatings = self.ratingItem.value;
    NSNumber* minimumWifi = [NSNumber numberWithInteger:[WFStringStore wifiSpeedIndex:self.wifiItem.value]];
    
    NSDictionary* filterDict = @{@"spaceFilters":spaceType,
                                 @"dayFilters": dayValues,
                                 @"ratingFilters": minimumRatings,
                                 @"wifiFilters": minimumWifi};
    if (self.delegate && [self.delegate respondsToSelector:@selector(filtersAdded:)]) {
        [self.delegate filtersAdded:filterDict];
    }
}

- (void)clear:(id)sender {
/*    for (RETableViewItem* item in self.spaceTypeItemsArray) {
        item.accessoryType = UITableViewCellAccessoryCheckmark;
        [item reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }
  */
    self.spaceTypeItem.value = -1;
    [self.spaceTypeItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    
    self.dayItem.value = @[[NSNumber numberWithInt:0]];
    [self.dayItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    
    self.ratingItem.value = [NSNumber numberWithInt:0];
    [self.ratingItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    
    self.wifiItem.value = [WFStringStore wifiSpeedString:0];
    [self.wifiItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addTableEntries {
    [self addSpaceTypeControls];
    [self addDaysControls];
    [self addRatingControls];
    [self addWifiControls];
    /*    [self addNoiseControls];
     [self addFoodControls];
     [self addSeatingControls];
     [self addPowerControls];*/
}

- (void)addSpaceTypeControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Space Type"];
    [self.manager addSection:section];
    
    /*__typeof (&*self) __weak weakSelf = self;
    void (^changeState)(RETableViewItem *item) = ^(RETableViewItem *item){
        UITableViewCell* cell = [weakSelf.tableView cellForRowAtIndexPath:item.indexPath];
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        item.accessoryType = cell.accessoryType;
    };

    for (NSString* value in [WFStringStore spaceTypeStrings]) {
        RETableViewItem* item = [RETableViewItem itemWithTitle:value accessoryType:UITableViewCellAccessoryCheckmark selectionHandler:^(RETableViewItem *item) {
            changeState(item);
        }];
        [section addItem:item];
        [self.spaceTypeItemsArray addObject:item];
    }*/
    self.spaceTypeItem = [RESegmentedItem itemWithTitle:nil segmentedControlTitles:[WFStringStore spaceTypeStrings] value:-1];
    self.spaceTypeItem.tintColor = [UIColor turquoiseColor];
    [section addItem:self.spaceTypeItem];
}

- (void)addDaysControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Open Days"];
    [self.manager addSection:section];
    
    self.dayItem = [WFDayItem item];
    [section addItem:self.dayItem];
}

- (void)addRatingControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Minimum Ratings"];
    [self.manager addSection:section];
    
    self.ratingItem = [WFRatingItem itemWithValue:[NSNumber numberWithInt:3]];
    [section addItem:self.ratingItem];
}

- (void)addWifiControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Minimum Wifi Speed"];
    [self.manager addSection:section];
    
    self.wifiItem = [WFStepperItem itemWithValue:[WFStringStore wifiSpeedString:WFWifiSpeed1Mbps] andRange:[WFStringStore wifiSpeedStrings]];
    [section addItem:self.wifiItem];
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

/*
- (void)addNoiseControls {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Noise level"];
    [self.manager addSection:section];
    
    RESegmentedItem* item = [RESegmentedItem itemWithTitle:nil segmentedControlTitles:[WFStringStore noiseStrings] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
    }];

    item.tintColor = [UIColor turquoiseColor];
    [section addItem:item];
}

- (void)addFoodControls {
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
}

- (void)addSeatingControls {
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
}

- (void)addPowerControls {
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
}*/

@end
