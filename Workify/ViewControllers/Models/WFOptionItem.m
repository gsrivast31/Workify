//
//  WFOptionItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFOptionItem.h"

@implementation WFOptionItem

+ (WFOptionItem*)itemWithOptions:(NSArray *)options {
    WFOptionItem* item = [[WFOptionItem alloc] init];
    item.options = options;
    return item;
}

@end
