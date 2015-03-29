//
//  WFReviewsViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@class PFObject;

@interface WFReviewsViewController : PFQueryTableViewController

- (id) initWithObject:(PFObject*)object;

@property (nonatomic, strong) PFObject* locationObject;

@end
