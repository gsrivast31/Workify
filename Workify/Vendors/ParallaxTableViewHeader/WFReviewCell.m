//
//  WFReviewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 04/03/2014.
//  Copyright (c) 2014 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFReviewCell.h"

@interface WFReviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *reviewAuthorIcon;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDateLabel;

@property (nonatomic) NSDictionary *review;

@end

static CGFloat kPaddingDist = 8.0f;
static CGFloat kDefaultReviewCellHeight = 40.0f;
static CGFloat kTableViewWidth = -1;
static CGFloat kStandardButtonSize = 30.0f;
static CGFloat kStandardLabelHeight = 20.0f;

@implementation WFReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    NSString *review = self.review[kReviewKey];
    CGFloat cellHeight = [WFReviewCell heightForReview:review];
    CGRect frame = self.reviewLabel.frame;
    frame.size.height = cellHeight;
    self.reviewLabel.frame = frame;
    
    frame = self.reviewDateLabel.frame;
    frame.origin.x = self.reviewAuthorIcon.frame.origin.x + self.reviewAuthorIcon.frame.size.width + kPaddingDist;
    frame.origin.y = self.reviewLabel.frame.origin.y + self.reviewLabel.frame.size.height + kPaddingDist;
    self.reviewDateLabel.frame = frame;
    [super layoutSubviews];
}

#pragma mark -
#pragma mark Interface

+ (void)setTableViewWidth:(CGFloat)tableWidth {
    kTableViewWidth = tableWidth;
}

+ (id)reviewCellForTableWidth:(CGFloat)width
{
    WFReviewCell *cell = [[WFReviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = width;
    cell.frame = cellFrame;
    
    //Left AuthorIconView
    UIImageView *authOrIconView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingDist, kPaddingDist, kStandardButtonSize, kStandardButtonSize)];
    authOrIconView.image = [UIImage imageNamed:@"author"];
    authOrIconView.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:authOrIconView];
    cell.reviewAuthorIcon = authOrIconView;

    //Review Label
    CGRect labelRect = CGRectMake(authOrIconView.frame.origin.x + authOrIconView.frame.size.width + kPaddingDist,
                                  authOrIconView.frame.origin.y, width - (kPaddingDist * 3 + authOrIconView.frame.size.width),
                                  kStandardLabelHeight);
    UILabel *reviewlabel = [[UILabel alloc] initWithFrame:labelRect];
    reviewlabel.font = [UIFont flatFontOfSize:14];
    reviewlabel.textColor = [UIColor darkGrayColor];
    reviewlabel.textAlignment = NSTextAlignmentLeft;
    reviewlabel.numberOfLines = 0;
    reviewlabel.lineBreakMode = NSLineBreakByWordWrapping;
    reviewlabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.reviewLabel = reviewlabel;
    [cell addSubview:reviewlabel];
    
    //reviewDateLabel;
    UILabel *reviewDatelabel = [[UILabel alloc] initWithFrame:CGRectMake(reviewlabel.frame.origin.x, reviewlabel.frame.origin.y + reviewlabel.frame.size.height + kPaddingDist, reviewlabel.frame.size.width, reviewlabel.frame.size.height)];
    reviewDatelabel.font = [UIFont flatFontOfSize:10];
    reviewDatelabel.textColor = [UIColor grayColor];
    reviewDatelabel.textAlignment = NSTextAlignmentLeft;
    cell.reviewDateLabel = reviewDatelabel;
    [cell addSubview:reviewDatelabel];
    
    return cell;
}

+ (CGFloat)cellHeightForReview:(NSString *)review {
    return kDefaultReviewCellHeight + [WFReviewCell heightForReview:review];
}

+ (CGFloat)heightForReview:(NSString *)review {
    CGFloat height = 0.0;
    CGFloat reviewlabelWidth = kTableViewWidth - 3 * kPaddingDist - kStandardButtonSize;
    CGRect rect = [review boundingRectWithSize:(CGSize){reviewlabelWidth, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont flatFontOfSize:14]}
                                        context:nil];
    height = rect.size.height;
    return height;
}

- (void)configureReviewCellForReview:(NSDictionary *)review {
    self.review = review;
    self.reviewLabel.text = review[kReviewKey];
    self.reviewDateLabel.text = review[kTimeKey];
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Private


@end
