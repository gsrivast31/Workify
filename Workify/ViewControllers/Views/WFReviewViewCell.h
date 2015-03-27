//
//  WFReviewViewCell.h
//  Workify
//
//  Created by Ranjeet on 3/24/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFReviewItem.h"

@interface WFReviewViewCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFReviewItem *item;

@end
