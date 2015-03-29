//
//  WFRatingCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/18/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFRatingCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 5.0;
static const CGFloat kRatingDim = 32.0;

@interface WFRatingCell()

@property (strong, nonatomic) NSMutableArray *stars;

@end

@implementation WFRatingCell

@synthesize stars;

- (void)cellDidLoad {
    [super cellDidLoad];
    
    stars = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSInteger i=1; i<=5; i++) {
        UIButton* button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"star"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [self addSubview:button];
        [stars addObject:button];
    }
}

- (void)cellWillAppear {
    [super cellWillAppear];
    NSInteger starsCount = [self.item.value integerValue];
    for (NSInteger i=1; i<=starsCount; i++) {
        [((UIButton*)[stars objectAtIndex:i-1]) setSelected:TRUE];
    }
    for (NSInteger i=starsCount+1; i<=5; i++) {
        [((UIButton*)[stars objectAtIndex:i-1]) setSelected:FALSE];
    }

}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)changeState:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSInteger selectedIndex = button.tag;
    if (button.tag == [self.item.value integerValue]) { //double tapped the same star
        selectedIndex --;
    }
    
    for (NSInteger i=1; i<=selectedIndex; i++) {
        [((UIButton*)[stars objectAtIndex:i-1]) setSelected:TRUE];
    }
    for (NSInteger i=selectedIndex+1; i<=5; i++) {
        [((UIButton*)[stars objectAtIndex:i-1]) setSelected:FALSE];
    }
    self.item.value = [NSNumber numberWithInteger:selectedIndex];
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    return kRatingDim + 2*kVerticalMargin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFRatingCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    CGFloat startX = frame.origin.x + (frame.size.width - 5*kRatingDim - 4*kHorizontalMargin)/2.0f;
    CGFloat startY = frame.origin.y + (frame.size.height - kRatingDim)/2.0f;
    
    for (NSInteger i=1; i<=5; i++) {
        UIButton* button = (UIButton*)[stars objectAtIndex:i-1];
        button.frame = CGRectMake(startX, startY, kRatingDim, kRatingDim);
        startX += kRatingDim + kHorizontalMargin;
    }
}

@end
