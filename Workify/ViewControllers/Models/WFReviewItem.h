//
//  WFReviewItem.h
//  Workify
//
//  Created by Ranjeet on 3/24/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewItem.h"

@interface WFReviewItem : RETableViewItem

@property (nonatomic, copy, readwrite) NSString* reviewText;
@property (nonatomic, copy, readwrite) NSString* ratingText;
@property (nonatomic, copy, readwrite) NSString* authorName;
@property (nonatomic, copy, readwrite) NSString* reviewDate;
@property (nonatomic, copy, readwrite) NSString* authorProfileImageName;

+ (instancetype)itemWithReview:(NSString *)review author:(NSString*)author imageName:(NSString*)imageName date:(NSString*)date ratings:(NSInteger)ratings;

@end
