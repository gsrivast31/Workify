//
//  WFDetailsViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDetailsViewCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;

@interface WFDetailsViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation WFDetailsViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    [self setButton:self.callButton withNormalImageName:@"phone" disabledImageName:@"phone-disabled"];
    [self setButton:self.emailButton withNormalImageName:@"email" disabledImageName:@"email-disabled"];
    [self setButton:self.mapButton withNormalImageName:@"map" disabledImageName:@"map-disabled"];
    [self setButton:self.webButton withNormalImageName:@"web" disabledImageName:@"web-disabled"];
    [self setButton:self.facebookButton withNormalImageName:@"facebook" disabledImageName:@"facebook-disabled"];
    [self setButton:self.twitterButton withNormalImageName:@"twitter" disabledImageName:@"twitter-disabled"];
    
    [self.callButton addTarget:self action:@selector(callButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailButton addTarget:self action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapButton addTarget:self action:@selector(mapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.webButton addTarget:self action:@selector(webButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.facebookButton addTarget:self action:@selector(facebookButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.twitterButton addTarget:self action:@selector(twitterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    self.nameLabel.text = self.item.name;
    self.addressLabel.text = self.item.address;
    
    [self.nameLabel setFont:[UIFont flatFontOfSize:18]];
    [self.addressLabel setFont:[UIFont flatFontOfSize:14]];
    [self.ratingsLabel setFont:[UIFont iconFontWithSize:16]];
    
    self.ratingsLabel.text = [WFDetailsViewCell ratingsText:self.item.ratings];
    [self.ratingsLabel setTextColor:[UIColor turquoiseColor]];
    [self.ratingsLabel setTintColor:[UIColor turquoiseColor]];
}

- (void)setButton:(UIButton*)button withNormalImageName:(NSString*)normalImageName disabledImageName:(NSString*)disabledImageName {
    [button.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [button.layer setBorderWidth:0.5f];
    [button.layer setMasksToBounds:YES];
    [button setClipsToBounds:YES];
    [button setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];

    [button setContentMode:UIViewContentModeCenter];
}

- (void)callButtonTapped:(id)sender {
    if (self.item.delegate && [self.item.delegate respondsToSelector:@selector(phoneTapped:)]) {
        [self.item.delegate phoneTapped:self.item];
    }
}

- (void)emailButtonTapped:(id)sender {
    if (self.item.delegate && [self.item.delegate respondsToSelector:@selector(emailTapped:)]) {
        [self.item.delegate emailTapped:self.item];
    }
}

- (void)mapButtonTapped:(id)sender {
    if (self.item.delegate && [self.item.delegate respondsToSelector:@selector(mapTapped:)]) {
        [self.item.delegate mapTapped:self.item];
    }
}

- (void)webButtonTapped:(id)sender {
    if (self.item.delegate && [self.item.delegate respondsToSelector:@selector(websiteTapped:)]) {
        [self.item.delegate websiteTapped:self.item];
    }
}

- (void)facebookButtonTapped:(id)sender {
    if (self.item.delegate && [self.item.delegate respondsToSelector:@selector(facebookTapped:)]) {
        [self.item.delegate facebookTapped:self.item];
    }
}

- (void)twitterButtonTapped:(id)sender {
    if (self.item.delegate && [self.item.delegate respondsToSelector:@selector(twitterTapped:)]) {
        [self.item.delegate twitterTapped:self.item];
    }
}

+ (NSString*)ratingsText:(NSNumber*)ratings {
    NSInteger stars = [ratings integerValue];
    NSString* ratingText = @"";
    for (; stars > 0; stars --) {
        ratingText = [ratingText stringByAppendingString:[NSString iconStringForEnum:FUIStar2]];
    }
    return ratingText;
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFDetailsViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    CGFloat ratingWidth = [[WFDetailsViewCell ratingsText:self.item.ratings] re_sizeWithFont:[UIFont iconFontWithSize:16]].width;
    CGFloat nameHeight = [self.item.name re_sizeWithFont:[UIFont flatFontOfSize:18] constrainedToSize:CGSizeMake(frame.size.width - ratingWidth - kHorizontalMargin, INFINITY)].height;
    CGFloat addressHeight = [self.item.address re_sizeWithFont:[UIFont flatFontOfSize:14] constrainedToSize:CGSizeMake(frame.size.width, INFINITY)].height;

    self.nameLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width - kHorizontalMargin - ratingWidth, nameHeight);
    self.ratingsLabel.frame = CGRectMake(frame.size.width - ratingWidth, frame.origin.y, ratingWidth, nameHeight);
    self.addressLabel.frame = CGRectMake(frame.origin.x, frame.origin.y + nameHeight + kVerticalMargin, frame.size.width, addressHeight);
    
    CGFloat buttonWidth = frame.size.width / 6.0f;
    CGRect buttonFrame = CGRectMake(frame.origin.x, frame.origin.y + nameHeight + addressHeight + 2*kVerticalMargin, buttonWidth, 40.0f);
    
    self.callButton.frame = buttonFrame;
    buttonFrame.origin.x += buttonWidth;
    self.emailButton.frame = buttonFrame;
    buttonFrame.origin.x += buttonWidth;
    self.mapButton.frame = buttonFrame;
    buttonFrame.origin.x += buttonWidth;
    self.webButton.frame = buttonFrame;
    buttonFrame.origin.x += buttonWidth;
    self.facebookButton.frame = buttonFrame;
    buttonFrame.origin.x += buttonWidth;
    self.twitterButton.frame = buttonFrame;
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    WFDetailedViewItem* detailItem = (WFDetailedViewItem*)item;
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && item.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
    
    CGFloat ratingWidth = [[WFDetailsViewCell ratingsText:detailItem.ratings] re_sizeWithFont:[UIFont iconFontWithSize:16]].width;
    CGFloat nameHeight = [detailItem.name re_sizeWithFont:[UIFont flatFontOfSize:18] constrainedToSize:CGSizeMake(width - ratingWidth - kHorizontalMargin, INFINITY)].height;
    CGFloat addressHeight = [detailItem.address re_sizeWithFont:[UIFont flatFontOfSize:14] constrainedToSize:CGSizeMake(width, INFINITY)].height;
    CGFloat buttonHeight = 40.0f;
    
    CGFloat height = 4 * kVerticalMargin + buttonHeight + nameHeight + addressHeight + 4*kVerticalMargin;
    return height;
}

@end
