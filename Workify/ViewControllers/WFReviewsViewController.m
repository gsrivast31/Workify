//
//  WFReviewsViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFReviewsViewController.h"
#import "WFAddReviewController.h"
#import "WFLoginViewController.h"
#import "MZFormSheetPresentationController.h"
#import "RETableViewManager.h"
#import "WFReviewItem.h"
#import "WFReviewCell.h"

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface WFReviewsViewController () <WFAddReviewDelegate, WFLoginDelegate, RETableViewManagerDelegate>

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *section;
@end

@implementation WFReviewsViewController

- (id) initWithObject:(PFObject*)object {
    self = [super init];
    if (self) {
        self.locationObject = object;
        
        // The className to query on
        self.parseClassName = kWFReviewClassKey;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        // self.objectsPerPage = 10;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = YES;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Reviews";

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFReviewItem"] = @"WFReviewViewCell";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(addReview:)];
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addReview:(id)sender {
    if ([WFHelper isLoggedIn]) {
        WFAddReviewController* vc = [[WFAddReviewController alloc] init];
        vc.delegate = self;
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVC animated:YES completion:nil];
    } else {
        WFLoginViewController* vc = [[WFLoginViewController alloc] init];
        vc.loginDelegate = self;
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        navVC.view.layer.cornerRadius = 6.0;
        
        MZFormSheetPresentationController *controller = [[MZFormSheetPresentationController alloc] initWithContentViewController:navVC];
        controller.contentViewControllerTransitionStyle = MZFormSheetTransitionStyleDropDown;
        controller.shouldCenterVertically = YES;
        controller.shouldDismissOnBackgroundViewTap = YES;
        controller.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTop;
        controller.shouldApplyBackgroundBlurEffect = YES;
        
        navVC.navigationBarHidden = YES;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (PFQuery *)queryForTable {
    PFRelation* relation = [self.locationObject objectForKey:kWFLocationReviewsKey];
    PFQuery* query = [relation query];
    [query orderByDescending:@"createdAt"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    WFReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"WFReviewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    }
    
    [cell configureCellWithObject:object];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
}

#pragma mark WFAddReviewDelegate
- (void)reviewAdded:(NSDictionary *)reviewDictionary {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    PFObject* object = [PFObject objectWithClassName:kWFReviewClassKey];
    [object setObject:[PFUser currentUser] forKey:kWFReviewUserKey];
    [object setObject:[reviewDictionary objectForKey:kReviewKey] forKey:kWFReviewContentKey];
    [object setObject:[reviewDictionary objectForKey:kRatingKey] forKey:kWFReviewRatingsKey];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFRelation* relation = [self.locationObject relationForKey:kWFLocationReviewsKey];
            [relation addObject:object];
            NSInteger reviewCnt = [[self.locationObject objectForKey:kWFLocationReviewCountKey] integerValue];
            NSInteger oldRatings = [[self.locationObject objectForKey:kWFLocationRatingsKey] integerValue];
            NSInteger newRatings = (oldRatings * reviewCnt + [[object objectForKey:kWFReviewRatingsKey] integerValue]) / (reviewCnt + 1);
            
            [self.locationObject setObject:[NSNumber numberWithInteger:newRatings] forKey:kWFLocationRatingsKey];
            [self.locationObject incrementKey:kWFLocationReviewCountKey];
            
            [self.locationObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                        [self loadObjects];
                    });
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReviewAddedNotification object:nil];
                }
            }];
        } else if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save the review. Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            });
        }
    }];
    
}

- (void)reviewCanceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark WFLoginDelegate

- (void)loggedInWithUser:(PFUser *)user error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!user) {
        NSString *errorMessage = nil;
        if (!error) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            errorMessage = @"Uh oh. The user cancelled the Facebook login.";
        } else {
            NSLog(@"Uh oh. An error occurred: %@", error);
            errorMessage = [error localizedDescription];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss", nil];
        [alert show];
    } else {
        WFAddReviewController* vc = [[WFAddReviewController alloc] init];
        vc.delegate = self;
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navVC animated:YES completion:nil];
    }
}

@end
