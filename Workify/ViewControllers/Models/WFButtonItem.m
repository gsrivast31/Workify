//
//  WFButtonItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/19/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFButtonItem.h"

@implementation WFButtonItem

+ (WFButtonItem*)itemWithTitle:(NSString*)title tapHandler:(void(^)(RETableViewItem *item))tapHandler {
    WFButtonItem* item = [WFButtonItem itemWithTitle:title];
    item.tapHandler = tapHandler;
    return item;
}

@end
