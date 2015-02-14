//
//  WFMapViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/04/2014.
//  Copyright (c) 2014 GAURAV SRIVASTAVA. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WFMapPin.h"

@interface WFMapViewController : UIViewController

- (id)initWithLocation:(CLLocation *)theLocation;
- (void)positionPin:(CLLocation *)aLocation;

@end
