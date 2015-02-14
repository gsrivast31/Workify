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
    WFMapPin *pin;
    
    CLLocation *location;
}
@end

@implementation WFMapViewController

#pragma mark - Setup
- (id)initWithLocation:(CLLocation *)theLocation {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.title = NSLocalizedString(@"Event Location", @"Geo-location of event");
        location = theLocation;
        pin = [[WFMapPin alloc] init];
    }
    
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    mapView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:mapView];
    
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    mapView.frame = self.view.frame;
    [self positionPin:location];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    mapView.frame = self.view.bounds;
}

#pragma mark - Logic
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
