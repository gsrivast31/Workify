//
//  WFSubTitleItem.m
//  Workify
//
//  Created by Ranjeet on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFSubTitleItem.h"

@implementation WFSubTitleItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString*)subtitle accessoryType:(UITableViewCellAccessoryType)accessoryType selectionHandler:(void(^)(RETableViewItem *item))selectionHandler {
    WFSubTitleItem* item = [WFSubTitleItem itemWithTitle:title accessoryType:accessoryType selectionHandler:selectionHandler];
    item.detailLabelText = subtitle;
    return item;
}

@end
