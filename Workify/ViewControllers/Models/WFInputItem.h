//
//  WFInputItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFInputItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSArray* categories;
@property (nonatomic, copy, readwrite) NSString* name;
@property (nonatomic, copy, readwrite) NSString* value;
@property (nonatomic, copy, readwrite) NSNumber* selectedIndex;

+ (WFInputItem*)itemWithTitle:(NSString*)title value:(NSString*)value categories:(NSArray*)categories selectedIndex:(NSNumber*)selectedIndex;

@end
