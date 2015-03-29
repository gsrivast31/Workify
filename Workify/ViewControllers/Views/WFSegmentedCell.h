//
//  WFSegmentedCell.h
//  Workify
//
//  Created by Ranjeet on 3/29/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewSegmentedCell.h"
#import "RESegmentedItem.h"

@interface WFSegmentedControl : UISegmentedControl

@end

@interface WFSegmentedCell : RETableViewCell

@property (strong, readonly, nonatomic) WFSegmentedControl *segmentedControl;
@property (strong, readwrite, nonatomic) RESegmentedItem *item;

@end
