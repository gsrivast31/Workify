//
//  WFReviewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 04/03/2014.
//  Copyright (c) 2014 GAURAV SRIVASTAVA. All rights reserved.
//

static NSString *kCellIdentifier = @"reviewCellId";

@interface WFReviewCell : UITableViewCell

+ (void)setTableViewWidth:(CGFloat)tableWidth;
+ (id)reviewCellForTableWidth:(CGFloat)width;
+ (CGFloat)cellHeightForReview:(NSString *)review;
- (void)configureReviewCellForReview:(NSDictionary *)review;

@end
