//
//  WFAddressViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/20/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddressViewController.h"
#import "RETableViewManager.h"
#import "WFButtonItem.h"
#import <CoreLocation/CoreLocation.h>

@interface WFAddressViewController () <RETableViewManagerDelegate>
{
    UIView* _mapView;
}

@property (nonatomic, readwrite, strong) RETableViewManager* manager;
@property (nonatomic, readwrite, strong) RETextItem* nameItem;
@property (nonatomic, readwrite, strong) RETextItem* thoroughfareItem;
@property (nonatomic, readwrite, strong) RETextItem* subThoroughfareItem;
@property (nonatomic, readwrite, strong) RETextItem* localityItem;
@property (nonatomic, readwrite, strong) RETextItem* subLocalityItem;
@property (nonatomic, readwrite, strong) RETextItem* administrativeAreaItem;
@property (nonatomic, readwrite, strong) RETextItem* subAdministrativeAreaItem;
@property (nonatomic, readwrite, strong) RETextItem* postalCodeItem;
@property (nonatomic, readwrite, strong) RETextItem* countryItem;
@end

@implementation WFAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFButtonItem"] = @"WFButtonCell";
    [self addTableEntries];
    
    if (self.placemark) {
        self.tableView.tableHeaderView = [self mapView];
    } else {
        self.tableView.tableHeaderView = nil;
    }
    [self updateNavigationBar];
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

- (UIView *)mapView {
    if (_mapView)
        return _mapView;
    
    // if not cached, setup the map view...
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 240.0f);
    MKMapView *map = [[MKMapView alloc] initWithFrame:frame];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.placemark.location.coordinate, 200, 200);
    [map setRegion:region];
    
    map.layer.masksToBounds = YES;
    map.layer.cornerRadius = 10.0;
    map.mapType = MKMapTypeStandard;
    [map setScrollEnabled:NO];
    
    // add a pin using self as the object implementing the MKAnnotation protocol
    [map addAnnotation:self];

    _mapView = map;
    return _mapView;
}

- (void)addTableEntries {
    [self addNameEntry];
    [self addThoroughfareEntry];
    [self addSubThoroughfareEntry];
    [self addLocalityEntry];
    [self addSubLocalityEntry];
    [self addAdministrativeAreaEntry];
    [self addSubAdministrativeAreaEntry];
    [self addPostalCodeEntry];
    [self addCountryEntry];
    [self addUseAddressEntry];
}

- (void)addNameEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Name"];
    [self.manager addSection:section];
    
    self.nameItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.name:nil placeholder:@"E.g. Apple Inc."];
    [section addItem:self.nameItem];
}

- (void)addThoroughfareEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Street Address 1"];
    [self.manager addSection:section];
    
    self.thoroughfareItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.thoroughfare:nil placeholder:@"E.g. 1 Infinite Loop"];
    [section addItem:self.thoroughfareItem];
}

- (void)addSubThoroughfareEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Street Address 2"];
    [self.manager addSection:section];
    
    self.subThoroughfareItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.subThoroughfare:nil placeholder:nil];
    [section addItem:self.subThoroughfareItem];
}

- (void)addLocalityEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"City"];
    [self.manager addSection:section];
    
    self.localityItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.locality:nil placeholder:@"E.g. Cupertino"];
    [section addItem:self.localityItem];
}

- (void)addSubLocalityEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Sub-Locality"];
    [self.manager addSection:section];
    
    self.subLocalityItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.subLocality:nil placeholder:@"Neighborhood, Common name, e.g. Mission District"];
    [section addItem:self.subLocalityItem];
}

- (void)addAdministrativeAreaEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"State"];
    [self.manager addSection:section];
    
    self.administrativeAreaItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.administrativeArea:nil placeholder:@"E.g. CA"];
    [section addItem:self.administrativeAreaItem];
}

- (void)addSubAdministrativeAreaEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"District/Town/County"];
    [self.manager addSection:section];
    
    self.subAdministrativeAreaItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.subAdministrativeArea:nil placeholder:@"E.g. Santa Clara"];
    [section addItem:self.subAdministrativeAreaItem];
}

- (void)addPostalCodeEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"ZipCode"];
    [self.manager addSection:section];
    
    self.postalCodeItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.postalCode:nil placeholder:@"E.g. 95014"];
    [section addItem:self.postalCodeItem];
}

- (void)addCountryEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Country"];
    [self.manager addSection:section];
    
    self.countryItem = [RETextItem itemWithTitle:@"" value:self.placemark?self.placemark.country:nil placeholder:@"E.g. United States"];
    [section addItem:self.countryItem];
}

- (void)addUseAddressEntry {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    WFButtonItem* item = [WFButtonItem itemWithTitle:@"Use this address" tapHandler:^(RETableViewItem *item) {
        [weakSelf saveAddress];
    }];
    [section addItem:item];
}

- (NSString*)validString:(NSString*)string {
    return string ? string : @"";
}

- (void)saveAddress {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(addressAdded:)]) {
            NSNumber* lat = self.placemark ?  [NSNumber numberWithFloat:self.placemark.location.coordinate.latitude] : nil;
            NSNumber* lon = self.placemark ?  [NSNumber numberWithFloat:self.placemark.location.coordinate.longitude] : nil;
            NSDictionary* addressDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [self validString:self.nameItem.value], @"Name",
                                         [self validString:self.thoroughfareItem.value], @"ThoroughFare",
                                         [self validString:self.subThoroughfareItem.value], @"SubThoroughFare",
                                         [self validString:self.localityItem.value], @"Locality",
                                         [self validString:self.subLocalityItem.value], @"SubLocality",
                                         [self validString:self.administrativeAreaItem.value], @"AdministrativeArea",
                                         [self validString:self.subAdministrativeAreaItem.value], @"SubAdministrativeArea",
                                         [self validString:self.postalCodeItem.value], @"PostalCode",
                                         [self validString:self.countryItem.value], @"Country",
                                         lat, @"Latitude",
                                         lon, @"Longitude",
                                         nil];
            [self.delegate addressAdded:addressDict];
        }
    }
}

#pragma mark - MKAnnotation Protocol (for map pin)

- (CLLocationCoordinate2D)coordinate {
    return self.placemark.location.coordinate;
}

- (NSString *)title {
    return self.placemark.thoroughfare;
}

@end
