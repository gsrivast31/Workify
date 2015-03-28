//
//  WFLocationDetailViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationDetailViewController.h"
#import "ParallaxHeaderView.h"
#import "RETableViewManager.h"
#import "WFDetailedItem.h"
#import "WFDetailedViewItem.h"
#import "WFTwoColumnItem.h"
#import "WFTwoColumnViewCell.h"
#import "WFFullTextView.h"
#import "WFButtonItem.h"

#import "WFMapViewController.h"
#import "WFReviewsViewController.h"
#import <MessageUI/MessageUI.h>
#import "MWPhotoBrowser.h"
#import "WFLoginViewController.h"
#import "MZFormSheetPresentationController.h"
#import <Parse/Parse.h>

@interface WFLocationDetailViewController () <RETableViewManagerDelegate, WFDetailDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, MWPhotoBrowserDelegate, WFLoginDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;
@property (weak, nonatomic) IBOutlet UIButton *photosButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation WFLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc] init];
    self.thumbs = [[NSMutableArray alloc] init];

    ParallaxHeaderView* headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"bkgnd1"] forSize:CGSizeMake(self.tableView.frame.size.width, 200)];
    headerView.headerTitleLabel.text = @"";
    self.tableView.tableHeaderView = headerView;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotos)];
    [headerView addGestureRecognizer:gesture];
    
    self.tableView.tintColor = [UIColor turquoiseColor];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFDetailedItem"] = @"WFDetailSingleItemCell";
    self.manager[@"WFDetailedViewItem"] = @"WFDetailsViewCell";
    self.manager[@"WFTwoColumnItem"] = @"WFTwoColumnViewCell";
    self.manager[@"WFButtonItem"] = @"WFButtonCell";

    self.bottomView.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.reviewsButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.reviewsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reviewsButton setTintColor:[UIColor whiteColor]];
    [self.reviewsButton setImage:[UIImage imageNamed:@"reviews"] forState:UIControlStateNormal];
    [self.reviewsButton addTarget:self action:@selector(showReviews) forControlEvents:UIControlEventTouchUpInside];

    [self.photosButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.photosButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.photosButton setTintColor:[UIColor whiteColor]];
    [self.photosButton setImage:[UIImage imageNamed:@"photos"] forState:UIControlStateNormal];
    [self.photosButton addTarget:self action:@selector(showPhotos) forControlEvents:UIControlEventTouchUpInside];

    [self addTableEntries];
    
    if(!self.navigationItem.leftBarButtonItem) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [backButton setImage:[[UIImage imageNamed:@"NavBarIconBack.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [backButton setTitle:self.navigationItem.backBarButtonItem.title forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10.0f, 0, 0)];
        [backButton setAdjustsImageWhenHighlighted:NO];
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    }
    
    UIBarButtonItem* shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    for (NSInteger i=0; i<5; i++) {
        MWPhoto* photo = [MWPhoto photoWithImage:[UIImage imageNamed:@"splash"]];
        [self.photos addObject:photo];
        [self.thumbs addObject:photo];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [(ParallaxHeaderView*)self.tableView.tableHeaderView refreshBlurViewForNewImage];
    [super viewDidAppear:animated];
}

- (void)loadDetails {
    if (self.locationId) {
        PFQuery* query = [PFQuery queryWithClassName:kWFLocationClassKey];
        [query whereKey:@"objectId" equalTo:self.locationId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
        }];
    }
}

- (void)dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share:(id)sender {
    
}

- (void)showReviews {
    WFReviewsViewController* vc = [[WFReviewsViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)showPhotos {
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = YES;
    browser.startOnGrid = YES;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark -
#pragma mark UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark -

- (void)addTableEntries {
    [self addGeneralSection];
    [self addInfoSection];
    [self addHoursSection];
    [self addAmenitiesSection];
    [self addReportEditSection];
}

- (void)addGeneralSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    WFDetailedViewItem* item = [WFDetailedViewItem itemWithName:@"Cafe Zoe" delegate:self];
    item.ratings = [NSNumber numberWithInteger:4];
    item.phone = @"+91-9717961964";
    item.email = @"gaurav.sri87@gmail.com";
    item.address = @"12/105, VikasNagar, Lucknow, U.P. - 226022";
    item.longitude = nil;
    item.latitude = nil;
    item.website = @"http://www.google.com";
    item.facebookUrl = @"http://www.facebook.com/";
    item.twitterUrl = @"http://www.twitter.com/";
    
    [section addItem:item];
}

- (void)addInfoSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    NSString* aboutText = @"";
    
    __typeof (&*self) __weak weakSelf = self;
    [section addItem:[WFDetailedItem itemWithTitle:@"About" subTitle:aboutText imageName:@"about" selectionHandler:^(RETableViewItem *item) {
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        [WFFullTextView presentInView:self.view withText:aboutText];
    }]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Location Type" subTitle:@"Co-Working space" imageName:@"locationtype"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"WiFi" subTitle:@"Reliable - 4Mbps download speed, 2Mbps upload speed" imageName:@"wifi"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Pricing" subTitle:@"Day Pass - INR 200, Weekly Pass - INR 300, Monthly Pass - INR 400" imageName:@"pricing"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Power" subTitle:@"1/2 per table" imageName:@"power"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Food" subTitle:@"Tea, Coffee, Snacks, Dinner, Alcohol, Desserts" imageName:@"food"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Noise" subTitle:@"Average Noisy" imageName:@"noise"]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Seating" subTitle:@"Indoor, Outdoor, Standing Desks, Table for 2, Table for 4" imageName:@"seat"]];
}

- (void)addHoursSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    [section addItem:[WFTwoColumnItem itemWithTitle:@"Hours"
                                          imageName:@"calendar"
                                            contents:@[@{@"title":@"Mon", @"value":@"Open"},
                                                       @{@"title":@"Tue", @"value":@"Open"},
                                                       @{@"title":@"Wed", @"value":@"Open"},
                                                       @{@"title":@"Thu", @"value":@"Open"},
                                                       @{@"title":@"Fri", @"value":@"Open"},
                                                       @{@"title":@"Sat", @"value":@"Open"},
                                                       @{@"title":@"Sun", @"value":@"Closed"}
                                                       ]]];
}

- (void)addAmenitiesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];

    [section addItem:[WFTwoColumnItem itemWithTitle:@"Amenities" imageName:nil contents:
                      @[@{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Air Conditioner"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Television"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Dog Friendly"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Kid Friendly"},
                       @{@"images":@{@"normal":@"check",@"disabled":@"check"},@"value":@"Washroom"}
                       ]]];
}

- (void)addReportEditSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    [section addItem:[WFButtonItem itemWithTitle:@"Report Edits" tapHandler:^(RETableViewItem *item) {
        [weakSelf reportEdits];
    }]];
}

- (void)reportEdits {
    if ([WFHelper isLoggedIn]) {
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setMailComposeDelegate:self];
            [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
            [mailController setSubject:@"Reporting Edits"];
            [mailController setToRecipients:@[@"gaurav.sri87@gmail.com"]];
            [mailController setMessageBody:[NSString stringWithFormat:@"%@\n\n", NSLocalizedString(@"Here's my info:", @"A default message shown to users when contacting support for help")] isHTML:NO];
            if(mailController) {
                [self presentViewController:mailController animated:YES completion:nil];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                message:NSLocalizedString(@"This device hasn't been setup to send emails.", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
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

#pragma mark RETableViewManagerDelegate

- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WFTwoColumnViewCell class]]) {
        if ([cell respondsToSelector:@selector(setItemCount:)]) {
            WFTwoColumnItem *item = (WFTwoColumnItem*)[[[self.manager.sections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
            [(WFTwoColumnViewCell*)cell setItemCount:[[item contents] count]];
        }
    }
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1 && indexPath.row == 0) ? YES : NO;
}

#pragma mark WFDetailViewDelegate

- (void)phoneTapped:(RETableViewItem *)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:_item.phone delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [alertView show];
}

- (void)emailTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
        [mailController setToRecipients:@[_item.email]];
        if(mailController) {
            [self presentViewController:mailController animated:YES completion:nil];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                            message:NSLocalizedString(@"This device hasn't been setup to send emails.", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)mapTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    WFMapViewController* vc = [[WFMapViewController alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:[_item.latitude doubleValue] longitude:[_item.longitude doubleValue]]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)websiteTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    NSString* website = _item.website;
    NSURL* webURL = [NSURL URLWithString:website];
    if ([[UIApplication sharedApplication] canOpenURL:webURL]) {
        [[UIApplication sharedApplication] openURL:webURL];
    }
}

- (void)facebookTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    NSString* facebookUrl = _item.facebookUrl;
    if ([facebookUrl hasSuffix:@"/"]) {
        facebookUrl = [facebookUrl substringToIndex:[facebookUrl length] - 1];
    }
    
    NSArray* components = [facebookUrl componentsSeparatedByString:@"/"];
    if (components.count) {
        __typeof (&*self) __weak weakSelf = self;

        NSString* pageName = [components lastObject];
        NSString* graphURLString = [@"https://graph.facebook.com/" stringByAppendingString:pageName];
        NSURL* graphURL = [NSURL URLWithString:graphURLString];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:graphURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError == nil) {
                NSError* error = nil;
                NSDictionary* parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error != nil) {
                    NSString* identifier = [parsedObject valueForKey:@"id"];
                    [weakSelf openPage:[NSString stringWithFormat:@"fb:///profile/%@", identifier] withURL:facebookUrl];
                }
            }
        }];
    }
}

- (void)twitterTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    NSString* twitterUrl = _item.twitterUrl;
    if ([twitterUrl hasSuffix:@"/"]) {
        twitterUrl = [twitterUrl substringToIndex:[twitterUrl length] - 1];
    }
    
    NSArray* components = [twitterUrl componentsSeparatedByString:@"/"];
    if (components.count) {
        NSString* identifier = [components lastObject];
        [self openPage:[NSString stringWithFormat:@"twitter:///user?screen_name=%@", identifier] withURL:twitterUrl];
    }
}

- (void)openPage:(NSString*)scheme withURL:(NSString*)url {
    NSURL* schemeURL = [NSURL URLWithString:scheme];
    if ([[UIApplication sharedApplication] canOpenURL:schemeURL]) {
        [[UIApplication sharedApplication] openURL:schemeURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
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
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setMailComposeDelegate:self];
            [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
            [mailController setSubject:@"Reporting Edits"];
            [mailController setToRecipients:@[@"gaurav.sri87@gmail.com"]];
            [mailController setMessageBody:[NSString stringWithFormat:@"%@\n\n", NSLocalizedString(@"Here's my info:", @"A default message shown to users when contacting support for help")] isHTML:NO];
            if(mailController) {
                [self presentViewController:mailController animated:YES completion:nil];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                message:NSLocalizedString(@"This device hasn't been setup to send emails.", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            NSURL* phoneURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:@"+91-9717961964"]];
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                [[UIApplication sharedApplication] openURL:phoneURL];
            }
        }
    }
}

@end
