//
//  WFDetailedItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFDetailedItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSString* name;
@property (nonatomic, copy, readwrite) NSString* imagename;
@property (nonatomic, copy, readwrite) NSString* value;

+ (id)itemWithTitle:(NSString *)title subTitle:(NSString*)subtitle imageName:(NSString*)imageName;

@end

