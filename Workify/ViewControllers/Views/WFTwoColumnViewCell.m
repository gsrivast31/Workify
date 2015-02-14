//
//  WFTwoColumnViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 08/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFTwoColumnViewCell.h"
#import "WFTwoColumnItem.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kRowSize = 30.0f;
static const CGFloat kHorizSpacing = 5.0f;

@interface WFSingleColumnView()

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UILabel* label;

@end

@implementation WFSingleColumnView

- (id)init {
    if (self = [super init]) {
        self.button = [[UIButton alloc] init];
        self.label = [[UILabel alloc] init];

        [self.button setTitleColor:[UIColor turquoiseColor] forState:UIControlStateNormal];
        [self.button.titleLabel setFont:[UIFont flatFontOfSize:14]];
        [self.label setFont:[UIFont flatFontOfSize:14]];

        [self addSubview:self.button];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setContentFrame:(CGRect)frame {
    self.frame = frame;
    self.button.frame = CGRectMake(0, 0, kRowSize, frame.size.height);
    self.label.frame = CGRectMake(kRowSize + kHorizSpacing, 0, frame.size.width - kRowSize - kHorizSpacing, frame.size.height);
}

- (void)setContent:(NSDictionary*)dict {
    NSString* title = dict[@"title"];
    NSString* normalImage = dict[@"images"][@"normal"];
    NSString* disabledImage = dict[@"images"][@"disabled"];
    NSString* value = dict[@"value"];
    
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:disabledImage] forState:UIControlStateNormal];
    
    [self.label setText:value];
}

@end

@interface WFTwoColumnViewCell()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation WFTwoColumnViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    
    if (self.itemCount > 0) {
        NSUInteger count = self.itemCount;
        while (count-- > 0) {
            [self.mainView addSubview:[[WFSingleColumnView alloc] init]];
        }
    }
}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    [self.label setText:self.item.name];
    [self.button setImage:[UIImage imageNamed:self.item.imagename] forState:UIControlStateNormal];
    [self.button setContentMode:UIViewContentModeCenter];
    
    NSUInteger index= 0;
    for (UIView* view in self.mainView.subviews) {
        if ([view isKindOfClass:[WFSingleColumnView class]]) {
            [(WFSingleColumnView*)view setContent:[self.item.contents objectAtIndex:index]];
            index++;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    BOOL isLeft = TRUE;
    CGFloat startY = 0.0f;
    
    NSUInteger count = [self.item.contents count];
    if (count%2 == 0) count = count/2;
    else count = count/2 + 1;
    
    [self.mainView setFrame:CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y, self.mainView.frame.size.width, count * kRowSize)];
    CGFloat viewWidth = CGRectGetWidth(self.mainView.frame);
    
    count = [self.item.contents count];
    for (UIView* view in self.mainView.subviews) {
        if ([view isKindOfClass:[WFSingleColumnView class]]) {
            if (isLeft) {
                [(WFSingleColumnView*)view setContentFrame:CGRectMake(0, startY, viewWidth/2.0f - 1.0, kRowSize)];
            } else {
                [(WFSingleColumnView*)view setContentFrame:CGRectMake(viewWidth/2.0f + 1.0, startY, viewWidth/2.0f - 1.0, kRowSize)];
                startY += kRowSize;
            }
            isLeft = !isLeft;
        }
    }
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    WFTwoColumnItem* columnItem = (WFTwoColumnItem*)item;
    NSUInteger count = [columnItem.contents count];
    if (count%2 == 0) {
        count = count/2;
    } else {
        count = count/2 + 1;
    }
    
    return count * kRowSize + 15.0f + kRowSize;
}

@end
