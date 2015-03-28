//
//  WFLocationsViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@class PFObject;

@interface WFLocationsViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject* cityObject;

@end
