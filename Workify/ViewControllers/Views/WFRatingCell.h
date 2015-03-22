//
//  WFRatingCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/18/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFRatingItem.h"

@interface WFRatingCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFRatingItem *item;

@end
