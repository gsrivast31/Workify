//
//  WFNavigationController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 11/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//


#import "WFNavigationController.h"
#import "WFSideMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"

@interface WFNavigationController()

@property (strong, readwrite, nonatomic) WFSideMenuViewController *menuViewController;

@end

@implementation WFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController panGestureRecognized:sender];
}

@end
