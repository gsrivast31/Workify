//
//  WFAddressViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/20/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WFLocationSearchViewController.h"

@class CLPlacemark;

@interface WFAddressViewController : UITableViewController <MKAnnotation>

@property (nonatomic, strong) CLPlacemark* placemark;
@property (weak, readwrite, nonatomic) id<WFAddAddressDelegate> delegate;

#pragma mark - MKAnnotation Protocol (for map pin)

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *title;

@end
