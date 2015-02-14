//
//  WFTagItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFTagItem : RETableViewItem

@property (copy, readwrite, nonatomic) NSArray *values;

+ (WFTagItem*)itemWithValues:(NSArray*)values;

@end
