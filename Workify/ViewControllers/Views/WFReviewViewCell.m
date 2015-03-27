//
//  WFReviewViewCell.m
//  Workify
//
//  Created by Ranjeet on 3/24/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFReviewViewCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;
static const CGFloat kImageDim = 32.0;

@interface WFReviewViewCell()

@property (nonatomic, strong) UILabel* reviewLabel;
@property (nonatomic, strong) UILabel* ratingLabel;
@property (nonatomic, strong) UILabel* authorLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@property (nonatomic, strong) UIButton* authorImageButton;

@end

@implementation WFReviewViewCell

@synthesize reviewLabel;
@synthesize ratingLabel;
@synthesize authorLabel;
@synthesize authorImageButton;
@synthesize dateLabel;

- (void)cellDidLoad {
    [super cellDidLoad];
    
    reviewLabel = [[UILabel alloc] init];
    reviewLabel.font = [UIFont flatFontOfSize:14];
    reviewLabel.textColor = [UIColor darkGrayColor];
    reviewLabel.textAlignment = NSTextAlignmentLeft;
    reviewLabel.numberOfLines = 0;
    reviewLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:reviewLabel];

    ratingLabel = [[UILabel alloc] init];
    ratingLabel.font = [UIFont iconFontWithSize:12];
    ratingLabel.textColor = [UIColor turquoiseColor];
    ratingLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:ratingLabel];
    
    authorImageButton = [[UIButton alloc] init];
    authorImageButton.layer.masksToBounds = YES;
    authorImageButton.layer.cornerRadius = kImageDim/2.0f;
    authorImageButton.clipsToBounds = YES;
    [self addSubview:authorImageButton];

    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont flatFontOfSize:10];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:dateLabel];

    authorLabel = [[UILabel alloc] init];
    authorLabel.font = [UIFont flatFontOfSize:10];
    authorLabel.textColor = [UIColor grayColor];
    authorLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:authorLabel];

}

- (void)cellWillAppear {
    [super cellWillAppear];
    reviewLabel.text = self.item.reviewText;
    ratingLabel.text = self.item.ratingText;
    [authorImageButton setImage:[UIImage imageNamed:self.item.authorProfileImageName] forState:UIControlStateNormal];
    dateLabel.text = self.item.reviewDate;
    authorLabel.text = self.item.authorName;
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFReviewViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    CGFloat reviewTextHeight = [self.item.reviewText re_sizeWithFont:reviewLabel.font constrainedToSize:CGSizeMake(frame.size.width, INFINITY)].height;

    reviewLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, reviewTextHeight);
    authorImageButton.frame = CGRectMake(frame.origin.x, frame.origin.y + reviewTextHeight + kVerticalMargin, kImageDim, kImageDim);

    CGFloat ratingTextWidth = [self.item.ratingText re_sizeWithFont:ratingLabel.font].width;
    ratingLabel.frame = CGRectMake(frame.origin.x + frame.size.width - ratingTextWidth, frame.origin.y + reviewTextHeight + kVerticalMargin, ratingTextWidth, kImageDim);
    
    CGFloat authorTextHeight = [self.item.authorName re_sizeWithFont:authorLabel.font].height;
    authorLabel.frame = CGRectMake(frame.origin.x + kImageDim + 5.0, frame.origin.y + reviewTextHeight + kVerticalMargin, frame.size.width - ratingTextWidth - kImageDim - 5.0, authorTextHeight);

    CGFloat dateTextHeight = [self.item.reviewDate re_sizeWithFont:dateLabel.font].height;
    dateLabel.frame = CGRectMake(frame.origin.x + kImageDim + 5.0, frame.origin.y + reviewTextHeight + kVerticalMargin + kImageDim - dateTextHeight, frame.size.width - ratingTextWidth - kImageDim - 5.0, dateTextHeight);
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && item.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
    WFReviewItem* _item = (WFReviewItem*)item;
    CGFloat reviewTextHeight = [_item.reviewText re_sizeWithFont:[UIFont flatFontOfSize:14] constrainedToSize:CGSizeMake(width, INFINITY)].height;
    return reviewTextHeight + kImageDim + 3*kVerticalMargin;
}

@end
