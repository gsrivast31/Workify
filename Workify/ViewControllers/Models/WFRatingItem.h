//
//  WFRatingItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFRatingItem : RETableViewItem

@property (copy, readwrite, nonatomic) NSNumber *value;

+ (WFRatingItem*)itemWithValue:(NSNumber*)value;

@end
