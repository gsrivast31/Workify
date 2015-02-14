//
//  WFStepperItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFStepperItem : RETableViewItem

@property (copy, readwrite, nonatomic) NSString *value;
@property (copy, readwrite, nonatomic) NSArray *values;

+ (WFStepperItem*)itemWithValue:(NSString*)value andRange:(NSArray*)values;

@end
