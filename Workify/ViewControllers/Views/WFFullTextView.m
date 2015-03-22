//
//  WFFullTextView.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/17/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFFullTextView.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

@interface WFFullTextView()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UILabel* textLabel;

@end
@implementation WFFullTextView

@synthesize text;
@synthesize textLabel;
@synthesize scrollView;

#pragma mark - Setup

+ (id)presentInView:(UIView *)parentView withText:(NSString*)text {
    CGRect frameRect = parentView.bounds;
    frameRect.origin.y += 64.0f;
    frameRect.size.height -= 64.0f;
    WFFullTextView *view = [[WFFullTextView alloc] initWithFrame:frameRect withText:text];
    [parentView addSubview:view];
    
    return view;
}

- (id)initWithFrame:(CGRect)frame withText:(NSString*)_text {
    self = [super initWithFrame:frame];
    if (self) {
        self.text = _text;
        self.tintColor = [UIColor clearColor];
        self.dynamic = NO;
        self.blurRadius = 30.0f;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:gesture];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:scrollView];
    
    textLabel = [[UILabel alloc] init];
    textLabel.text = self.text;
    textLabel.font = [UIFont flatFontOfSize:18];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.numberOfLines = 0;
    [scrollView addSubview:textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textHeight = [self.text re_sizeWithFont:textLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 40.0f, INFINITY)].height;
    CGRect textRect = CGRectMake(20.0, 20.0, self.frame.size.width - 40.0f, textHeight);
    textLabel.frame = textRect;
    scrollView.contentSize = CGSizeMake(self.frame.size.width, textHeight + 20.0);
}

#pragma mark - Logic
- (void)dismiss {
    [self removeFromSuperview];
}

@end
