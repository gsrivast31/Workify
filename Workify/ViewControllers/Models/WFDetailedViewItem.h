//
//  WFDetailedViewItem.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@protocol WFDetailDelegate <NSObject>

- (void)phoneTapped:(RETableViewItem*)item;
- (void)emailTapped:(RETableViewItem*)item;
- (void)mapTapped:(RETableViewItem*)item;
- (void)websiteTapped:(RETableViewItem*)item;
- (void)facebookTapped:(RETableViewItem*)item;
- (void)twitterTapped:(RETableViewItem*)item;

@end

@interface WFDetailedViewItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSString* name;
@property (nonatomic, copy, readwrite) NSNumber* ratings;
@property (nonatomic, copy, readwrite) NSString* phone;
@property (nonatomic, copy, readwrite) NSString* email;
@property (nonatomic, copy, readwrite) NSString* address;
@property (nonatomic, copy, readwrite) NSNumber* latitude;
@property (nonatomic, copy, readwrite) NSNumber* longitude;
@property (nonatomic, copy, readwrite) NSString* website;
@property (nonatomic, copy, readwrite) NSString* facebookUrl;
@property (nonatomic, copy, readwrite) NSString* twitterUrl;
@property (nonatomic, strong, readwrite) id <WFDetailDelegate> delegate;

+ (WFDetailedViewItem*)itemWithName:(NSString*)name delegate:(id<WFDetailDelegate>)delegate;

@end
