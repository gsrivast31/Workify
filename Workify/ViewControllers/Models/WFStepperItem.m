//
//  WFStepperItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFStepperItem.h"

@implementation WFStepperItem

+ (WFStepperItem*)itemWithValue:(NSString *)value andRange:(NSArray *)values {
    WFStepperItem* item = [[WFStepperItem alloc] init];
    item.values = values;
    item.value = value;
    return item;
}

@end
