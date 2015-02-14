//
//  WFOptionViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFOptionViewCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kRowSize = 30.0f;
static const CGFloat kHorizontalMargin = 5.0f;
static const CGFloat kVerticalMargin = 5.0f;

@interface WFSingleOptionView()

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UILabel* label;

@end

@implementation WFSingleOptionView

- (id)init {
    if (self = [super init]) {
        self.button = [[UIButton alloc] init];
        self.label = [[UILabel alloc] init];
        
        [self.button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateDisabled];

        [self.label setFont:[UIFont flatFontOfSize:14]];
        
        [self addSubview:self.button];
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    self.button.frame = CGRectMake(0, 0, kRowSize, self.frame.size.height);
    self.label.frame = CGRectMake(kRowSize + kHorizontalMargin, 0, self.frame.size.width - kRowSize - kHorizontalMargin, self.frame.size.height);
}

- (void)setContent:(NSString*)value {
    self.label.text = value;
}

@end


@implementation WFOptionViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    
    if (self.itemCount > 0) {
        NSUInteger count = self.itemCount;
        while (count-- > 0) {
            [self.contentView addSubview:[[WFSingleOptionView alloc] init]];
        }
    }
}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    NSUInteger index= 0;
    for (UIView* view in self.contentView.subviews) {
        if ([view isKindOfClass:[WFSingleOptionView class]]) {
            [(WFSingleOptionView*)view setContent:[self.item.options objectAtIndex:index]];
            index++;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFOptionViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);

    BOOL isLeft = TRUE;
    CGFloat startY = frame.origin.y;
    
    NSUInteger count = [self.item.options count];
    if (count%2 == 0) count = count/2;
    else count = count/2 + 1;
    
    for (UIView* view in self.contentView.subviews) {
        if ([view isKindOfClass:[WFSingleOptionView class]]) {
            if (isLeft) {
                [(WFSingleOptionView*)view setFrame:CGRectMake(frame.origin.x, startY, frame.size.width/2.0f - 1.0, kRowSize)];
            } else {
                [(WFSingleOptionView*)view setFrame:CGRectMake(frame.origin.x + frame.size.width/2.0f + 1.0, startY, frame.size.width/2.0f - 1.0, kRowSize)];
                startY += kRowSize + kVerticalMargin;
            }
            isLeft = !isLeft;
            [view setNeedsLayout];
        }
    }
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    WFOptionItem* columnItem = (WFOptionItem*)item;
    NSUInteger count = [columnItem.options count];
    if (count%2 == 0) {
        count = count/2;
    } else {
        count = count/2 + 1;
    }
    
    return count * kRowSize + (count + 1)*kVerticalMargin;
}

@end
