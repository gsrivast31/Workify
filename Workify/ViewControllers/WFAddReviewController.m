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

@property (nonatomic, strong) UIButton* publishButton;
@property (nonatomic, strong) UIButton* cancelButton;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, readwrite, strong) RETableViewManager* manager;

@property (nonatomic, strong) WFRatingItem* ratingItem;
@property (nonatomic, strong) RELongTextItem* reviewItem;
@end

@implementation WFAddReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Review";
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.publishButton = [[UIButton alloc] init];
    [self.publishButton setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8]];
    [self.publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.publishButton setTitle:[NSString stringWithFormat:@"%@ Publish", [NSString iconStringForEnum:FUICheck]] forState:UIControlStateNormal];
    [self.publishButton.titleLabel setFont:[UIFont iconFontWithSize:16]];
    [self.publishButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.publishButton];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8]];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[NSString stringWithFormat:@"%@ Cancel", [NSString iconStringForEnum:FUICross]]  forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont iconFontWithSize:16]];

    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFRatingItem"] = @"WFRatingCell";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addTableEntries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.publishButton.frame = CGRectMake(0.0f, self.view.frame.size.height - 44.0f, self.view.frame.size.width / 2.0f, 44.0f);
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height - 44.0f, self.view.frame.size.width / 2.0f, 44.0f);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.0f);
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
