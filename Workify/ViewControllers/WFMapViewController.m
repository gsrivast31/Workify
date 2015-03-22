//
//  WFMapViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/04/2014.
//  Copyright (c) 2014 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFMapViewController.h"

@interface WFMapViewController ()
{
    MKMapView *mapView;
    UIButton* mapButton;
    WFMapPin *pin;
    
    CLLocation *location;
}
@end

@implementation WFMapViewController

#pragma mark - Setup
- (id)initWithLocation:(CLLocation *)theLocation {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.title = NSLocalizedString(@"Location", @"Geo-location of event");
        location = theLocation;
        pin = [[WFMapPin alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView = [[MKMapView alloc] init];
    [self.view addSubview:mapView];
    
    mapButton = [[UIButton alloc] init];
    [mapButton setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8]];
    [mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mapButton setTitle:@"View in Maps" forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(viewInMap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:mapButton];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self positionPin:location];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    mapButton.frame = CGRectMake(0, self.view.frame.size.height - 44.0f, self.view.frame.size.width, 44.0f);
    mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.0f);
}

- (void)dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Logic

- (void)viewInMap:(id)sender {
    NSString *ll = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    ll = [ll stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", ll];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)positionPin:(CLLocation *)aLocation {
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = aLocation.coordinate.latitude;
    newRegion.center.longitude = aLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
    
    pin.coordinate = aLocation.coordinate;
    [mapView setRegion:newRegion animated:YES];
    [mapView addAnnotation:pin];
}

@end
