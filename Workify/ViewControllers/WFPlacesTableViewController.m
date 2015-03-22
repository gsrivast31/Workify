//
//  WFPlacesTableViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPlacesTableViewController.h"
#import "WFPlacesTableViewCell.h"
#import "WFNavigationController.h"

#import "WFAppDelegate.h"
#import "WFTooltipViewController.h"
#import "WFIntroductionTooltipView.h"

@interface WFPlacesTableViewController () <WFTooltipViewControllerDelegate>

@end

@implementation WFPlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Workify";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBarIconListMenu"] style:UIBarButtonItemStylePlain target:(WFNavigationController *)self.navigationController action:@selector(showMenu)];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kHasSeenStarterTooltip]) {
        [self showTips];
    }
}

- (void)showTips {
    WFAppDelegate *appDelegate = (WFAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *targetVC = appDelegate.viewController;
    
    WFTooltipViewController *modalView = [[WFTooltipViewController alloc] initWithParentVC:targetVC andDelegate:self];
    WFIntroductionTooltipView *tooltipView = [[WFIntroductionTooltipView alloc] initWithFrame:CGRectZero];
    [modalView setContentView:tooltipView];
    [modalView present];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFPlacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"     forIndexPath:indexPath];

    [cell configureCell];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark WFTooltipViewControllerDelegate

- (void)willDisplayModalView:(WFTooltipViewController *)aModalController {
    
}

- (void)didDismissModalView:(WFTooltipViewController *)aModalController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasSeenStarterTooltip];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
