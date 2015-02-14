//
//  WFRatingItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFRatingItem.h"

@implementation WFRatingItem

+ (WFRatingItem*)itemWithValue:(NSNumber*)value {
    WFRatingItem* item = [[WFRatingItem alloc] init];
    item.value = value;
    return item;
}

@end
