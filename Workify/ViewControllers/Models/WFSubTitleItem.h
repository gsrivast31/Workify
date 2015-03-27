//
//  WFSubTitleItem.h
//  Workify
//
//  Created by Ranjeet on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFSubTitleItem : RETableViewItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString*)subtitle accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^)(RETableViewItem *item))selectionHandler;

@property (nonatomic, copy, readwrite) NSDictionary* value;

@end
