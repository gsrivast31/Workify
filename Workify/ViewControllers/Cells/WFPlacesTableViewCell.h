//
//  WFPlacesTableViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface WFPlacesTableViewCell : UITableViewCell

- (void)configureCellWithObject:(PFObject*)object;

@end
