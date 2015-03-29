//
//  WFReviewCell.m
//  Workify
//
//  Created by Ranjeet on 3/29/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFReviewCell.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "WFMediaController.h"

@interface WFReviewCell()

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewDateLabel;

@end

@implementation WFReviewCell

- (void)configureCellWithObject:(PFObject*)object {
    self.reviewTextLabel.font = [UIFont flatFontOfSize:14];
    self.reviewTextLabel.textColor = [UIColor darkGrayColor];
    self.reviewTextLabel.textAlignment = NSTextAlignmentLeft;
    self.reviewTextLabel.numberOfLines = 0;
    self.reviewTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.ratingLabel.font = [UIFont iconFontWithSize:12];
    self.ratingLabel.textColor = [UIColor turquoiseColor];
    self.ratingLabel.textAlignment = NSTextAlignmentRight;
    
    [self.authorImageView setBackgroundColor:[UIColor clearColor]];
    [self.authorImageView setOpaque:NO];
    [self.authorImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.cornerRadius = 16.0f;
    self.authorImageView.clipsToBounds = YES;
    self.authorImageView.image = [UIImage imageNamed:@"author"];
    
    self.reviewDateLabel.font = [UIFont flatFontOfSize:10];
    self.reviewDateLabel.textColor = [UIColor grayColor];
    self.reviewDateLabel.textAlignment = NSTextAlignmentLeft;
    
    self.authorNameLabel.font = [UIFont flatFontOfSize:10];
    self.authorNameLabel.textColor = [UIColor grayColor];
    self.authorNameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.reviewTextLabel.text = [object objectForKey:kWFReviewContentKey];
    
    NSString* ratingsText = @"";
    for (NSInteger i=0; i<[[object objectForKey:kWFReviewRatingsKey] integerValue]; i++) {
        ratingsText = [ratingsText stringByAppendingString:[NSString iconStringForEnum:FUIStar2]];
    }

    self.ratingLabel.text = ratingsText;

    __typeof (&*self) __weak weakSelf = self;
    PFUser* user = [object objectForKey:kWFReviewUserKey];
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSDictionary* dict = [object objectForKey:kWFUserProfileKey];
        weakSelf.authorNameLabel.text = [dict objectForKey:kWFUserDisplayNameKey];
        
        [[WFMediaController sharedInstance] imageFromURL:[NSURL URLWithString:
                                                          [dict objectForKey:kWFUserFacebookPictureURLKey]]
                                                 success:^(UIImage *image) {
                                                     weakSelf.authorImageView.image = image;
                                                 } failure:^{
                                                 }];
    }];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.reviewDateLabel.text = [dateFormatter stringFromDate:object.createdAt] ;
}


@end
