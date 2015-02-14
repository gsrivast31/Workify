//
//  WFDetailedViewItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDetailedViewItem.h"

@implementation WFDetailedViewItem

+ (WFDetailedViewItem*)itemWithName:(NSString*)name ratings:(NSNumber*)ratings phone:(NSString*)phone email:(NSString*)email address:(NSString*)address latitude:(NSNumber*)lat longitude:(NSNumber*)lon {
    WFDetailedViewItem* item = [[WFDetailedViewItem alloc] init];
    item.name = name;
    item.phone = phone;
    item.email = email;
    item.ratings = ratings;
    item.address = address;
    item.latitude = lat;
    item.longitude = lon;
    return item;
}

@end
