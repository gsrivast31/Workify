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
        
        [self.button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [self.button setImage:[UIImage imageNamed:@"check-disabled"] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
        [self.label setFont:[UIFont flatFontOfSize:14]];
        [self.label setUserInteractionEnabled:YES];
        [self.label setNumberOfLines:0];
        
        [self addSubview:self.button];
        [self addSubview:self.label];
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeState)];
        [self.label addGestureRecognizer:gesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = CGRectMake(0, 0, kRowSize, self.frame.size.height);
    self.label.frame = CGRectMake(kRowSize + kHorizontalMargin, 0, self.frame.size.width - kRowSize - kHorizontalMargin, self.frame.size.height);
}

- (void)setContent:(NSString*)value {
    self.label.text = value;
}

- (void)changeState {
    self.button.selected = !self.button.selected;
}

+ (CGFloat)heightWithText:(NSString*)text constrainedToWidth:(CGFloat)width{
    return MAX(kRowSize, [text re_sizeWithFont:[UIFont flatFontOfSize:14] constrainedToSize:CGSizeMake(width - kRowSize - kHorizontalMargin, INFINITY)].height);
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
    
    NSInteger index = 0;
    CGFloat optionWidth = frame.size.width/2.0f - 1.0;
    CGFloat leftOptionHeight = 0.0f, rightOptionHeight = 0.0f;
    for (UIView* view in self.contentView.subviews) {
        if ([view isKindOfClass:[WFSingleOptionView class]]) {
            CGFloat optionHeight = [WFSingleOptionView heightWithText:[self.item.options objectAtIndex:index]  constrainedToWidth:optionWidth];
            if (isLeft) {
                leftOptionHeight = optionHeight;
                [(WFSingleOptionView*)view setFrame:CGRectMake(frame.origin.x, startY, optionWidth, optionHeight)];
            } else {
                rightOptionHeight = optionHeight;
                [(WFSingleOptionView*)view setFrame:CGRectMake(frame.origin.x + frame.size.width/2.0f + 1.0, startY, optionWidth, optionHeight)];
                startY += MAX(leftOptionHeight, rightOptionHeight) + kVerticalMargin;
                leftOptionHeight = rightOptionHeight = 0.0f;
            }
            isLeft = !isLeft;
            ++index;
            [view setNeedsLayout];
        }
    }
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && item.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargin;
    CGFloat height = 0.0f;
    
    WFOptionItem* columnItem = (WFOptionItem*)item;
    NSInteger count = [columnItem.options count];
    for (NSInteger i=0; i<count; i++) {
        CGFloat leftHeight = [WFSingleOptionView heightWithText:[columnItem.options objectAtIndex:i] constrainedToWidth:width/2.0 - 1.0];
        CGFloat rightHeight = 0.0f;
        if (++i < count) {
            rightHeight = [WFSingleOptionView heightWithText:[columnItem.options objectAtIndex:i] constrainedToWidth:width/2.0 - 1.0];
        }
        
        height += MAX(leftHeight, rightHeight) + kVerticalMargin;
    }

    height += kVerticalMargin;
    
    return height;
}


@end
