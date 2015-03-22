//
//  WFButtonCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/19/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFButtonCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;
static const CGFloat kButtonHeight = 40.0;

@interface WFButtonCell()

@property (nonatomic, strong) UIButton* button;

@end

@implementation WFButtonCell

@synthesize button;

- (void)cellDidLoad {
    [super cellDidLoad];
    
    button = [[UIButton alloc] init];
    [button.titleLabel setFont:[UIFont flatFontOfSize:17]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor turquoiseColor]];
    [button addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text = @"";
    [button setTitle:self.item.title forState:UIControlStateNormal];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)addPhotos:(id)sender {
    if ([self.item respondsToSelector:@selector(setTapHandler:)]) {
        RETableViewItem* actionItem = (RETableViewItem*)self.item;
        if (self.item.tapHandler) {
            self.item.tapHandler(actionItem);
        }
    }
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    return kButtonHeight + 2*kVerticalMargin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFButtonCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    button.frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
}

@end
