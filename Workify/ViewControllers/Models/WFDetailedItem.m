//
//  WFDetailedItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDetailedItem.h"

@implementation WFDetailedItem

+ (id)itemWithTitle:(NSString *)title subTitle:(NSString*)subtitle imageName:(NSString*)imageName {
    WFDetailedItem* item = [[WFDetailedItem alloc] init];
    item.name = title;
    item.imagename = imageName;
    item.value = subtitle;
    return item;
}

@end
