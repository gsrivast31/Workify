//
//  WFOptionItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFOptionItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSArray* options;
@property (nonatomic, copy, readwrite) NSArray* value;

+ (WFOptionItem*)itemWithOptions:(NSArray*)option;

@end
