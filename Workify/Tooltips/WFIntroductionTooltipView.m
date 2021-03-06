//
//  WFIntroductionTooltipView.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFIntroductionTooltipView.h"

@interface WFIntroductionTooltipView ()
{
    UIPageControl *pageControl;
    UIScrollView *scrollView;
    
    NSInteger totalPages;
}

- (UIView *)pageForIndex:(NSInteger)index;
@end

@implementation WFIntroductionTooltipView

#pragma mark - Logic
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        
        totalPages = 3;
        
        // Setup pages
        for(int i = 0; i < totalPages; i++)
        {
            UIView *view = [self pageForIndex:i];
            [scrollView addSubview:view];
        }
        [self addSubview:scrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        pageControl.numberOfPages = totalPages;
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:18.0f/255.0f green:185.0f/255.0f blue:139.0f/255.0f alpha:1.0f];
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:18.0f/255.0f green:185.0f/255.0f blue:139.0f/255.0f alpha:0.25f];
        [self addSubview:pageControl];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    scrollView.frame = self.bounds;
    scrollView.contentSize = CGSizeMake((totalPages+1) * self.frame.size.width, self.frame.size.height);
    pageControl.frame = CGRectMake(0, self.bounds.size.height-60, self.bounds.size.width, 60);
    
    NSInteger index = 0;
    for(UIView *pageContainerView in scrollView.subviews)
    {
        pageContainerView.frame = CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        index++;
    }
}

#pragma mark - Logic
- (UIView *)pageForIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    
    CGFloat contentHeight = 200.0f, headerHeight = 30.0f;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, floorf(self.frame.size.height/2 - ((contentHeight+headerHeight)/2)), self.frame.size.width, contentHeight+headerHeight)];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(floorf(self.frame.size.width/2 - 20), headerHeight+10, 40, 2)];
    border.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:237.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    [containerView addSubview:border];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(floorf(self.frame.size.width/2 - 200/2), 0, 200, headerHeight)];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor colorWithRed:18.0f/255.0f green:185.0f/255.0f blue:139.0f/255.0f alpha:1.0f];
    header.numberOfLines = 1;
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont flatFontOfSize:26];
    header.text = NSLocalizedString(@"Hi there!", nil);
    header.adjustsFontSizeToFitWidth = YES;
    header.minimumScaleFactor = 0.5f;
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(floorf(self.frame.size.width/2 - 225/2), headerHeight+20, 225, contentHeight)];
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor colorWithRed:115.0f/255.0f green:128.0f/255.0f blue:123.0f/255.0f alpha:1.0f];
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentCenter;
    content.font = [UIFont flatFontOfSize:16];

    if(index == 0)
    {
        header.text = NSLocalizedString(@"Hi there!", nil);
        content.text = NSLocalizedString(@"WorkOnGo is a crowdsourced listing of best places to work remotely all over the world. Find best cafes, bars, restaurants and co-working spaces to work from while you travel.\n\nTo learn more swipe your finger to the left.", nil);
    }
    else if(index == 1)
    {
        header.text = NSLocalizedString(@"Best listings", nil);
        content.text = NSLocalizedString(@"Find all details for a space - wifi speeds, amenities, seating options, power options etc.", nil);
    }
    else if(index == 2)
    {
        header.text = NSLocalizedString(@"Any suggestions?", nil);
        content.text = NSLocalizedString(@"If you have a place to suggest, tap 'Suggest a place' in the left menu to add your suggestion. We will get back to you after verifying your suggestion.", nil);
    }
    [containerView addSubview:header];
    [containerView addSubview:content];
    
    [view addSubview:containerView];
    
    return view;
}

#pragma mark - UIScrollViewDelegate method
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // Dismissing the modal if we scroll past the end
    if(page > 2)
    {
        page = 2;
        [self.modalViewController dismiss];
    }
    
    pageControl.currentPage = page;
}

@end
