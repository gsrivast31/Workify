//
//  WFButtonItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/19/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFButtonItem : RETableViewItem

@property (copy, readwrite, nonatomic) void (^tapHandler)(id item);

+ (WFButtonItem*)itemWithTitle:(NSString*)title tapHandler:(void(^)(RETableViewItem *item))tapHandler;

@end
