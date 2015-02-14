//
//  WFAddPlaceViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddPlaceViewController.h"
#import "RETableViewManager.h"
#import "WFHourViewCell.h"
#import "WFDayItem.h"
#import "WFInputItem.h"
#import "WFOptionItem.h"
#import "WFOptionViewCell.h"

@interface WFAddPlaceViewController () <RETableViewManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite, strong) RETableViewManager* manager;

@property (strong, readwrite, nonatomic) RETextItem *nameItem;
@property (strong, readwrite, nonatomic) RETextItem *emailItem;
@property (strong, readwrite, nonatomic) RETextItem *phoneItem;
@property (strong, readwrite, nonatomic) RETextItem *addressItem;
@property (strong, readwrite, nonatomic) RELongTextItem *descItem;
@end

@implementation WFAddPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFMultilineTextItem"] = @"WFMultilineTextCell";
    self.manager[@"WFDayItem"] = @"WFHourViewCell";
    self.manager[@"WFInputItem"] = @"WFInputViewCell";
    self.manager[@"WFOptionItem"] = @"WFOptionViewCell";
    [self addTableEntries];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconSave"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor turquoiseColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor turquoiseColor];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTableEntries {
    [self addGeneralSection];
    [self addHoursSection];
    [self addDescriptionSection];
    [self addWifiSection];
    [self addPricingSection];
    [self addFoodSection];
    [self addPowerSection];
    [self addSeatingSection];
    [self addNoiseSection];
    [self addAmenitiesSection];
}

- (void)addGeneralSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"General Info"];
    [self.manager addSection:section];
    
    self.nameItem = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"E.g. Gaurav Srivastava"];
    self.emailItem = [RETextItem itemWithTitle:@"Email" value:nil placeholder:@"abc@xyz.com"];
    self.phoneItem = [RENumberItem itemWithTitle:@"Phone" value:nil placeholder:@"(123) 456-7890" format:@"(XXX) XXX-XXXX"];
    self.addressItem = [RENumberItem itemWithTitle:@"Address" value:nil];
    
    [section addItem:self.nameItem];
    [section addItem:self.emailItem];
    [section addItem:self.phoneItem];
    [section addItem:self.addressItem];
}

- (void)addDescriptionSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Description"];
    [self.manager addSection:section];

    self.descItem = [RELongTextItem itemWithValue:nil placeholder:@"A short description"];
    self.descItem.cellHeight = 88.0f;
    [section addItem:self.descItem];
}

- (void)addHoursSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Hours"];
    [self.manager addSection:section];

    [section addItem:[WFDayItem item]];
}

- (void)addWifiSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Wifi"];
    [self.manager addSection:section];
    
    [section addItem:[RESegmentedItem itemWithTitle:@"" segmentedControlTitles:@[@"Reliable", @"Shaky", @"Absent", @"Don't know "] value:3 switchValueChangeHandler:^(RESegmentedItem *item) {
        
    }]];
    
    [section addItem:[WFInputItem itemWithTitle:@"Download Speed" value:@"4" categories:@[@"Gbps", @"Mbps", @"Kbps"] selectedIndex:[NSNumber numberWithInteger:2]]];
    [section addItem:[WFInputItem itemWithTitle:@"Upload Speed" value:@"4" categories:@[@"Gbps", @"Mbps", @"Kbps"] selectedIndex:[NSNumber numberWithInteger:2]]];
}

- (void)addPricingSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Average Pricing"];
    [self.manager addSection:section];
    
    [section addItem:[WFInputItem itemWithTitle:@"Price" value:@"100" categories:@[@"INR", @"Dollars", @"Pounds", @"Euros"  ] selectedIndex:[NSNumber numberWithInteger:0]]];
}

- (void)addFoodSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Food Options"];
    [self.manager addSection:section];
    
    [section addItem:[WFOptionItem itemWithOptions:@[@"Breakfast", @"Lunch", @"Dinner", @"Snacks", @"Tea", @"Coffee", @"Alcohol"]]];
}

- (void)addPowerSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Power Options"];
    [self.manager addSection:section];

    [section addItem:[WFOptionItem itemWithOptions:@[@"None", @"Limited (< 1/4 tables)", @"Good (1/4 - 1/2 tables)", @"Enough (> 1/2 tables)"]]];
}

- (void)addSeatingSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Seating Options"];
    [self.manager addSection:section];

    [section addItem:[WFOptionItem itemWithOptions:@[@"Indoor", @"Outdoor", @"Separate Room", @"Standing Desk", @"Tables for 1-4", @"Tables for > 4"]]];
}

- (RETableViewSection*)addNoiseSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Noise level"];
    [self.manager addSection:section];
    
    [section addItem:[RESegmentedItem itemWithTitle:nil segmentedControlTitles:@[@"Silence", @"Avg. Noisy", @"Noisy"] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
        
    }]];
    return section;
}

- (void)addAmenitiesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Amenities"];
    [self.manager addSection:section];
    
    [section addItem:[WFOptionItem itemWithOptions:@[@"Air Conditioner", @"Television", @"Dog Friendly", @"Kid Friendly", @"Washroom", @"Parking"]]];
}

#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"addPhoto"]) {
        
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addPhoto"]) {
        
    }
}

#pragma mark RETableViewManagerDelegate

- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WFOptionViewCell class]]) {
        if ([cell respondsToSelector:@selector(setItemCount:)]) {
            WFOptionItem *item = (WFOptionItem*)[[[self.manager.sections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
            [(WFOptionViewCell*)cell setItemCount:[[item options] count]];
        }
    }
}

@end
