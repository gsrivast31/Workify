//
//  WFTwoColumnItem.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 08/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFTwoColumnItem.h"

@implementation WFTwoColumnItem

+ (WFTwoColumnItem*)itemWithTitle:(NSString *)title imageName:(NSString *)imageName contents:(NSArray *)contents {
    WFTwoColumnItem* item = [[WFTwoColumnItem alloc] init];
    item.name = title;
    item.imagename = imageName;
    item.contents = contents;
    return item;
}

@end
