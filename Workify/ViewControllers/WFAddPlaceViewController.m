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
#import "WFButtonItem.h"
#import "WFSubTitleItem.h"

#import "WFAddPhotoViewController.h"
#import "WFLocationSearchViewController.h"

#import <AddressBookUI/AddressBookUI.h>

@interface WFAddPlaceViewController () <RETableViewManagerDelegate, WFAddPhotoDelegate, WFAddAddressDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite, strong) RETableViewManager* manager;

@property (strong, readwrite, nonatomic) RETextItem *nameItem;
@property (strong, readwrite, nonatomic) RETextItem *emailItem;
@property (strong, readwrite, nonatomic) RETextItem *phoneItem;
@property (strong, readwrite, nonatomic) WFSubTitleItem *addressItem;
@property (strong, readwrite, nonatomic) RETextItem *websiteItem;
@property (strong, readwrite, nonatomic) RETextItem *facebookItem;
@property (strong, readwrite, nonatomic) RETextItem *twitterItem;
@property (strong, readwrite, nonatomic) RETableViewItem *photosCountItem;
@property (strong, readwrite, nonatomic) WFButtonItem *galleryItem;
@property (strong, readwrite, nonatomic) RELongTextItem *descItem;

@property (strong, readwrite, nonatomic) NSMutableArray *photosArray;

@end

@implementation WFAddPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Suggest a place";
    
    self.photosArray = [[NSMutableArray alloc] init];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFMultilineTextItem"] = @"WFMultilineTextCell";
    self.manager[@"WFDayItem"] = @"WFHourViewCell";
    self.manager[@"WFInputItem"] = @"WFInputViewCell";
    self.manager[@"WFOptionItem"] = @"WFOptionViewCell";
    self.manager[@"WFButtonItem"] = @"WFButtonCell";
    self.manager[@"WFSubTitleItem"] = @"WFSubTitleCell";
    [self addTableEntries];
    
    self.saveButton.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.saveButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
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

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)save:(id)sender {
    
}

- (void)dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableEntries {
    [self addGeneralSection];
    [self addAddressSection];
    [self addSocialWebSection];
    [self addDescriptionSection];
    [self addHoursSection];
    [self addWifiSection];
    [self addPricingSection];
    [self addNoiseSection];
    [self addLocationTypeSection];
    [self addFoodSection];
    [self addPowerSection];
    [self addSeatingSection];
    [self addAmenitiesSection];
    [self addPhotosButton];
}

- (void)addGeneralSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"General Info"];
    [self.manager addSection:section];
    
    self.nameItem = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"E.g. Gaurav Srivastava"];
    self.emailItem = [RETextItem itemWithTitle:@"Email" value:nil placeholder:@"abc@xyz.com"];
    self.phoneItem = [RENumberItem itemWithTitle:@"Phone" value:nil placeholder:@"(123) 456-7890" format:@"(XXX) XXX-XXXX"];
    
    [section addItem:self.nameItem];
    [section addItem:self.emailItem];
    [section addItem:self.phoneItem];
}

- (void)addLocationTypeSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Location Type"];
    [self.manager addSection:section];

    [section addItem:[WFOptionItem itemWithOptions:[WFStringStore spaceTypeStrings]]];
}

- (void)addAddressSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Address"];
    [self.manager addSection:section];

    __typeof (&*self) __weak weakSelf = self;
    self.addressItem = [WFSubTitleItem itemWithTitle:@"No address added" subTitle:@"Tap to find it" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        WFLocationSearchViewController* vc = [[WFLocationSearchViewController alloc] init];
        vc.delegate = self;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.addressItem.selectionStyle = UITableViewCellSelectionStyleNone;

    [section addItem:self.addressItem];
}

- (void)addSocialWebSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Web/Social"];
    [self.manager addSection:section];

    self.websiteItem = [RETextItem itemWithTitle:@"Website" value:nil];
    self.facebookItem = [RETextItem itemWithTitle:@"Facebook" value:nil];
    self.twitterItem = [RETextItem itemWithTitle:@"Twitter" value:nil];

    [section addItem:self.websiteItem];
    [section addItem:self.facebookItem];
    [section addItem:self.twitterItem];
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
    
    RESegmentedItem* item = [RESegmentedItem itemWithTitle:@"" segmentedControlTitles:[WFStringStore wifiStrings] value:3 switchValueChangeHandler:^(RESegmentedItem *item) {
        
    }];
    item.tintColor = [UIColor turquoiseColor];
    [section addItem:item];
    
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
    
    [section addItem:[WFOptionItem itemWithOptions:[WFStringStore foodStrings]]];
}

- (void)addPowerSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Power Options"];
    [self.manager addSection:section];

    [section addItem:[WFOptionItem itemWithOptions:[WFStringStore powerStrings]]];
}

- (void)addSeatingSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Seating Options"];
    [self.manager addSection:section];

    [section addItem:[WFOptionItem itemWithOptions:[WFStringStore seatingStrings]]];
}

- (RETableViewSection*)addNoiseSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Noise level"];
    [self.manager addSection:section];
    
    RESegmentedItem* item = [RESegmentedItem itemWithTitle:nil segmentedControlTitles:[WFStringStore noiseStrings] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
    }];
    item.tintColor = [UIColor turquoiseColor];
    [section addItem:item];
    return section;
}

- (void)addAmenitiesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Amenities"];
    [self.manager addSection:section];
    
    [section addItem:[WFOptionItem itemWithOptions:[WFStringStore amenitiesStrings]]];
}

- (void)addPhotosButton {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Gallery"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    
    NSString* countText;
    if (self.photosArray.count) {
        countText = [NSString stringWithFormat:@"Total Photos : %ld", (unsigned long)[self.photosArray count]];
    } else {
        countText = @"No photos added";
    }
    
    self.photosCountItem = [RETableViewItem itemWithTitle:countText];
    self.photosCountItem.selectionStyle = UITableViewCellSelectionStyleNone;
    self.photosCountItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:self.photosCountItem];
    
    self.galleryItem = [WFButtonItem itemWithTitle:@"Add Photos" tapHandler:^(RETableViewItem *item) {
        [weakSelf addPhotos];
    }];
    [section addItem:self.galleryItem];
}

- (void)addPhotos {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController* navVC = [storyboard instantiateViewControllerWithIdentifier:@"addPhotoNavController"];
    WFAddPhotoViewController* vc = (WFAddPhotoViewController*)navVC.topViewController;
    vc.delegate = self;
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.addressItem.indexPath]) {
        return YES;
    }
    return NO;
}

#pragma mark WFAddPhotoDelegate

- (void)photosAdded:(NSArray *)photos {
    if (photos && [photos count]) {
        [self.photosArray addObjectsFromArray:photos];
        RETableViewCell* cell = (RETableViewCell*)[self.tableView cellForRowAtIndexPath:self.photosCountItem.indexPath];
        NSString* countText;
        if ([self.photosArray count]) {
            countText = [NSString stringWithFormat:@"Total Photos : %ld", (unsigned long)[self.photosArray count]];
        } else {
            countText = @"No photos added";
        }
        self.photosCountItem.title = countText;
        [cell.textLabel setText:countText];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark WFAddAddressDelegate

- (void)addressAdded:(NSDictionary *)addressDictionary {
    double latitude, longitude;
    NSNumber* lat = (NSNumber*)[addressDictionary objectForKey:kAddressLatitude];
    NSNumber* lon = (NSNumber*)[addressDictionary objectForKey:kAddressLongitude];
    if (lat) latitude = [lat doubleValue];
    if (lon) longitude = [lon doubleValue];

    NSString* addrString  = [@[[addressDictionary objectForKey:kAddressStreet],
                               [addressDictionary objectForKey:kAddressCity],
                               [addressDictionary objectForKey:kAddressState],
                               [addressDictionary objectForKey:kAddressZIP],
                               [addressDictionary objectForKey:kAddressCountry]] componentsJoinedByString:@", "];

    self.addressItem.title = addrString;
    self.addressItem.detailLabelText = @"Tap to change";
    
    [self.tableView reloadRowsAtIndexPaths:@[self.addressItem.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.navigationController popToViewController:self animated:YES];
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
