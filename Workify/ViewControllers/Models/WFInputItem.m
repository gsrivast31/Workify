//
//  WFInputItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFInputItem.h"

@implementation WFInputItem

+ (WFInputItem*)itemWithTitle:(NSString*)title value:(NSString*)value categories:(NSArray*)categories selectedIndex:(NSNumber*)selectedIndex {
    WFInputItem* item = [[WFInputItem alloc] init];
    item.name = title;
    item.value = value;
    item.categories = categories;
    item.selectedIndex = selectedIndex;
    return item;
}

@end
