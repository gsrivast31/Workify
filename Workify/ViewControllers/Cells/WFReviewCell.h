//
//  WFReviewCell.h
//  Workify
//
//  Created by Ranjeet on 3/29/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface WFReviewCell : UITableViewCell

- (void)configureCellWithObject:(PFObject*)object;

@end
