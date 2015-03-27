//
//  WFReviewItem.m
//  Workify
//
//  Created by Ranjeet on 3/24/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFReviewItem.h"

@implementation WFReviewItem

+ (instancetype)itemWithReview:(NSString *)review author:(NSString*)author imageName:(NSString*)imageName date:(NSString*)date ratings:(NSInteger)ratings {
    WFReviewItem* item = [[WFReviewItem alloc] init];
    item.reviewText = review;
    item.authorName = author;
    item.authorProfileImageName = imageName;
    item.reviewDate = date;
    
    NSString* ratingsText = @"";
    for (NSInteger i=0; i<ratings; i++) {
        ratingsText = [ratingsText stringByAppendingString:[NSString iconStringForEnum:FUIStar2]];
    }
    item.ratingText = ratingsText;
    

    return item;
}

@end
