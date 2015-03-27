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

@interface WFReviewsViewController () <WFAddReviewDelegate, WFLoginDelegate, RETableViewManagerDelegate>

@property (nonatomic) NSMutableArray *reviewsArray;
@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) RETableViewSection *section;
@end

@implementation WFReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Reviews";

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFReviewItem"] = @"WFReviewViewCell";
    [self loadPlaceHolderComments];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(addReview:)];
    
    [self addTableEntries];
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

- (void)loadPlaceHolderComments {
    self.reviewsArray = [NSMutableArray arrayWithObjects:@{kReviewKey: @"Friendship is always a sweet responsibility, never an opportunity", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"True friendship is when you walk into their house and your WiFi connects automatically", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"True friendship multiplies the good in life and divides its evils. Strive to have friends, for life without friends is like life on a desert island… to find one real friend in a lifetime is good fortune; to keep him is a blessing.", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"Like Thought Catalog on Facebook", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"The language of friendship is not words but meanings", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"Don’t walk behind me; I may not lead. Don’t walk in front of me; I may not follow. Just walk beside me and be my friend.", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"Friendship is like money, easier made than kept. – Samuel Butler", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"A friend is one that knows you as you are, understands where you have been, accepts what you have become, and still, gently allows you to grow. – William Shakespeare", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"I think if I’ve learned anything about friendship, it’s to hang in, stay connected, fight for them, and let them fight for you. Don’t walk away, don’t be distracted, don’t be too busy or tired, don’t take them for granted. Friends are part of the glue that holds life and faith together. Powerful stuff", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"I value the friend who for me finds time on his calendar, but I cherish the friend who for me does not consult his calendar", kTimeKey : @"1 Min Ago"},
                         @{kReviewKey: @"Every friendship travels at sometime through the black valley of despair. This tests every aspect of your affection. You lose the attraction and the magic. Your sense of each other darkens and your presence is sore. If you can come through this time, it can purify with your love, and falsity and need will fall away. It will bring you onto new ground where affection can grow again Friendship improves happiness, and abates misery, by doubling our joys, and dividing our grief Do not save your loving speeches For your friends till they are dead Do not write them on their tombstones, Speak them rather now instead", kTimeKey : @"1 Min Ago"},
                         nil];
}

- (void)addTableEntries {
    self.section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:self.section];
    
    for (NSDictionary* review in self.reviewsArray) {
        [self.section addItem:[WFReviewItem itemWithReview:[review valueForKey:kReviewKey] author:@"Gaurav Srivastava" imageName:@"author" date:[review valueForKey:kTimeKey] ratings:3]];
    }
}

#pragma mark WFAddReviewDelegate
- (void)reviewAdded:(NSDictionary *)reviewDictionary {
    [self.reviewsArray addObject:reviewDictionary];
    WFReviewItem* item = [WFReviewItem itemWithReview:[reviewDictionary valueForKey:kReviewKey] author:@"Gaurav Srivastava" imageName:@"author" date:@"1 Min Ago" ratings:[[reviewDictionary objectForKey:kRatingKey] integerValue]];
    [self.section insertItem:item atIndex:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.manager.tableView insertRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
