//
//  WFTwoColumnItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 08/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFTwoColumnItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSArray* contents;
@property (nonatomic, copy, readwrite) NSString* name;
@property (nonatomic, copy, readwrite) NSString* imagename;

+ (WFTwoColumnItem*)itemWithTitle:(NSString*)title imageName:(NSString*)imageName contents:(NSArray*)contents;

@end
