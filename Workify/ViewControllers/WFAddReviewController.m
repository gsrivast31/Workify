//
//  WFAddReviewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/22/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddReviewController.h"
#import "RETableViewManager.h"
#import "WFRatingItem.h"

@interface WFAddReviewController () <RETableViewManagerDelegate>

@property (nonatomic, readwrite, strong) RETableViewManager* manager;

@property (nonatomic, strong) WFRatingItem* ratingItem;
@property (nonatomic, strong) RELongTextItem* reviewItem;
@end

@implementation WFAddReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Review";
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFRatingItem"] = @"WFRatingCell";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconSave"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(publish:)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addTableEntries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)addTableEntries {
    RETableViewSection* section1 = [RETableViewSection sectionWithHeaderTitle:@"Rate"];
    [self.manager addSection:section1];

    self.ratingItem = [WFRatingItem itemWithValue:[NSNumber numberWithInt:0]];
    [section1 addItem:self.ratingItem];
    
    RETableViewSection* section2 = [RETableViewSection sectionWithHeaderTitle:@"Review"];
    [self.manager addSection:section2];
    
    self.reviewItem = [RELongTextItem itemWithValue:@"" placeholder:@"Your review here"];
    self.reviewItem.cellHeight = 200.0f;
    [section2 addItem:self.reviewItem];
}

- (void)publish:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reviewAdded:)]) {
        [self.delegate reviewAdded:@{kRatingKey : self.ratingItem.value, kReviewKey: self.reviewItem.value}];
    }
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reviewCanceled)]) {
        [self.delegate reviewCanceled];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
