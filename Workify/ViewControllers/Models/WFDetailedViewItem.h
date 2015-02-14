//
//  WFDetailedViewItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFDetailedViewItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSString* name;
@property (nonatomic, copy, readwrite) NSNumber* ratings;
@property (nonatomic, copy, readwrite) NSString* phone;
@property (nonatomic, copy, readwrite) NSString* email;
@property (nonatomic, copy, readwrite) NSString* address;
@property (nonatomic, copy, readwrite) NSNumber* latitude;
@property (nonatomic, copy, readwrite) NSNumber* longitude;

+ (WFDetailedViewItem*)itemWithName:(NSString*)name ratings:(NSNumber*)ratings phone:(NSString*)phone email:(NSString*)email address:(NSString*)address latitude:(NSNumber*)lat longitude:(NSNumber*)lon;
@end
