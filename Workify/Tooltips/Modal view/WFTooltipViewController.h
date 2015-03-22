//
//  WFTooltipViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFTooltipView;
@class WFTooltipViewController;
@protocol WFTooltipViewControllerDelegate <NSObject>

@optional
- (void)willDisplayModalView:(WFTooltipViewController *)aModalController;
- (void)didDismissModalView:(WFTooltipViewController *)aModalController;

@end

@class WFModalViewPane;
@interface WFTooltipViewController : UIViewController
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, assign) id<WFTooltipViewControllerDelegate> delegate;

// Setup
- (id)initWithParentVC:(UIViewController *)parentVC andDelegate:(id <WFTooltipViewControllerDelegate>)delegate;

// Logic
- (void)setContentView:(WFTooltipView *)view;
- (void)present;
- (void)dismiss;

@end

@interface WFModalViewPane : UIView
@end