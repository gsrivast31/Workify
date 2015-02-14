//
//  WFMultilineTextCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFMultilineTextCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;

@interface WFMultilineTextCell ()

@property (strong, readwrite, nonatomic) UILabel *multilineLabel;

@end

@implementation WFMultilineTextCell

+ (CGFloat)heightWithItem:(WFMultilineTextItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && item.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
    return [item.title re_sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(width, INFINITY)].height + 2.0 * kVerticalMargin;
}

- (void)cellDidLoad {
    [super cellDidLoad];
    self.multilineLabel = [[UILabel alloc] init];
    self.multilineLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.multilineLabel.font = [UIFont systemFontOfSize:17];
    self.multilineLabel.numberOfLines = 0;
    self.multilineLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.multilineLabel];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text = @"";
    self.multilineLabel.text = self.item.title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFMultilineTextCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    self.multilineLabel.frame = frame;
}

@end