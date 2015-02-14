//
//  WFTagItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFTagItem.h"

@implementation WFTagItem

+ (WFTagItem*)itemWithValues:(NSArray *)values {
    WFTagItem* item = [[WFTagItem alloc] init];
    item.values = values;
    return item;
}

@end
