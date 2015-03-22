//
//  WFDetailedViewItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDetailedViewItem.h"

@implementation WFDetailedViewItem

+ (WFDetailedViewItem*)itemWithName:(NSString*)name delegate:(id<WFDetailDelegate>)delegate {
    WFDetailedViewItem* item = [[WFDetailedViewItem alloc] init];
    item.name = name;
    item.delegate = delegate;
    return item;
}

@end
