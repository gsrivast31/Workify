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
@property (nonatomic, copy, readwrite) NSString* placeholder;

+ (id)itemWithTitle:(NSString *)title subTitle:(NSString*)subtitle placeHolder:(NSString*)placeholder imageName:(NSString*)imageName;

+ (id)itemWithTitle:(NSString *)title subTitle:(NSString*)subtitle placeHolder:(NSString*)placeholder imageName:(NSString*)imageName selectionHandler:(void(^)(RETableViewItem *item))selectionHandler ;

@end

