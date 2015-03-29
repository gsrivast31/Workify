//
//  WFDetailSingleItemCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 08/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDetailSingleItemCell.h"
#import "WFDetailedItem.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;

@interface WFDetailSingleItemCell()

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation WFDetailSingleItemCell

- (void)cellDidLoad {
    [super cellDidLoad];
    [self.titleLabel setFont:[UIFont flatFontOfSize:14.0f]];
    [self.valueLabel setFont:[UIFont flatFontOfSize:16.0f]];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    [self.titleLabel setText:self.item.name];
    
    if (self.item.value) {
        [self.valueLabel setFont:[UIFont flatFontOfSize:16.0f]];
        [self.valueLabel setText:self.item.value];
    } else {
        [self.valueLabel setFont:[UIFont italicFlatFontOfSize:16.0f]];
        [self.valueLabel setText:self.item.placeholder];
    }
    [self.imageButton setImage:[UIImage imageNamed:self.item.imagename] forState:UIControlStateNormal];
    [self.imageButton setContentMode:UIViewContentModeCenter];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFDetailSingleItemCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    self.imageButton.frame = CGRectMake(frame.origin.x, frame.origin.y, 30.0f, 30.0f);
    self.titleLabel.frame = CGRectMake(frame.origin.x + 40.0f, frame.origin.y, frame.size.width - 40.0f, 30.0f);
    CGRect valueRect = CGRectMake(frame.origin.x + 40.0f,
                                  frame.origin.y + 30.0f + kVerticalMargin,
                                  frame.size.width - 40.0f, frame.size.height - 30.0f - kVerticalMargin);
    self.valueLabel.frame = valueRect;
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    WFDetailedItem* detailItem = (WFDetailedItem*)item;
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && item.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
    CGFloat height = 30.0f + 2*kVerticalMargin;
    if (detailItem.value && ![detailItem.value isEqualToString:@""]) {
        height += [detailItem.value re_sizeWithFont:[UIFont flatFontOfSize:16] constrainedToSize:CGSizeMake(width - 40.0f, INFINITY)].height + kVerticalMargin;
    } else {
        height += [detailItem.placeholder re_sizeWithFont:[UIFont italicFlatFontOfSize:16] constrainedToSize:CGSizeMake(width - 40.0f, INFINITY)].height + kVerticalMargin;
    }
    
    return MIN(200.0f, height);
}

@end


