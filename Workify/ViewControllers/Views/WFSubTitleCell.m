//
//  WFSubTitleCell.m
//  Workify
//
//  Created by Ranjeet on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFSubTitleCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;

@interface WFSubTitleCell()

@property (nonatomic, strong) UILabel* mainLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@end

@implementation WFSubTitleCell

@synthesize mainLabel;
@synthesize subtitleLabel;

- (void)cellDidLoad {
    [super cellDidLoad];
    
    mainLabel = [[UILabel alloc] init];
    mainLabel.font = [UIFont flatFontOfSize:17];
    mainLabel.textColor = [UIColor blackColor];
    mainLabel.numberOfLines = 0;
    [self addSubview:mainLabel];
    
    subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.font = [UIFont italicFlatFontOfSize:13];
    subtitleLabel.textColor = [UIColor turquoiseColor];
    [self addSubview:subtitleLabel];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    mainLabel.text = self.item.title;
    subtitleLabel.text = self.item.detailLabelText;
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)layoutSubviews {
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFSubTitleCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    CGFloat mainLabelHt = [self.item.title re_sizeWithFont:mainLabel.font constrainedToSize:CGSizeMake(frame.size.width, INFINITY)].height;
    mainLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, mainLabelHt);
    
    CGFloat subtitleLabelHt = [self.item.detailLabelText re_sizeWithFont:subtitleLabel.font constrainedToSize:CGSizeMake(frame.size.width, INFINITY)].height;
    
    subtitleLabel.frame = CGRectMake(frame.origin.x, frame.origin.y + mainLabelHt + kVerticalMargin, frame.size.width, subtitleLabelHt);
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && item.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
    CGFloat height = 0.0f;

    CGFloat mainLabelHt = [item.title re_sizeWithFont:[UIFont flatFontOfSize:17] constrainedToSize:CGSizeMake(width, INFINITY)].height;
    height += mainLabelHt;
    
    if (item.detailLabelText) {
        CGFloat subtitleLabelHt = item.detailLabelText ? [item.detailLabelText re_sizeWithFont:[UIFont italicFlatFontOfSize:13] constrainedToSize:CGSizeMake(width, INFINITY)].height : 0.0f;
        height += subtitleLabelHt + kVerticalMargin;
    }
    return height + 2*kVerticalMargin;
}

@end
