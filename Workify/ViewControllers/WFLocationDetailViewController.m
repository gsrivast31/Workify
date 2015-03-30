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
#import <MBProgressHUD/MBProgressHUD.h>

@interface WFLocationDetailViewController () <RETableViewManagerDelegate, WFDetailDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, MWPhotoBrowserDelegate, WFLoginDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;
@property (weak, nonatomic) IBOutlet UIButton *photosButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong, readwrite) RETableViewManager *manager;
@property (nonatomic, strong, readwrite) WFDetailedViewItem *generalItem;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) PFObject* locationObject;

@end

@implementation WFLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc] init];
    self.thumbs = [[NSMutableArray alloc] init];

    self.locationObject = nil;
    
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

    self.bottomView.alpha = 0.0f;
    [self loadDetails];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadObject:) name:kReviewAddedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [(ParallaxHeaderView*)self.tableView.tableHeaderView refreshBlurViewForNewImage];
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReviewAddedNotification object:nil];
}

- (void)loadDetails {
    if (self.locationId) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        PFQuery* query = [PFQuery queryWithClassName:kWFLocationClassKey];
        [query whereKey:@"objectId" equalTo:self.locationId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error == nil) {
                self.locationObject = object;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [self addTableEntries];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load the details. Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                });
            }
        }];
    }
}

- (void)reloadObject:(NSNotification*)notification {
    [self setReviewCount];

    [self.generalItem setRatings:[self.locationObject objectForKey:kWFLocationRatingsKey]];
    [self.generalItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
}

- (void)dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)share:(id)sender {
    NSString* text = [NSString stringWithFormat:@"Look at this space I found out on %@.\n", APP_NAME];
    NSURL* webURL = [self.locationObject objectForKey:kWFLocationWebsiteKey];
    NSURL* facebookURL = [NSURL URLWithString:[@"https://www.facebook.com/" stringByAppendingString:[self.locationObject objectForKey:kWFLocationFacebookKey]]];
    NSURL* twitterURL = [NSURL URLWithString:[@"https://www.twitter.com/" stringByAppendingString:[self.locationObject objectForKey:kWFLocationTwitterKey]]];
    
    NSString* shareText = [@"\nYou can find more spaces on this app. Download it from " stringByAppendingString:APP_URL];
    NSArray* objectsToShare = @[text, webURL, facebookURL, twitterURL, shareText];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)showReviews {
    WFReviewsViewController* vc = [[WFReviewsViewController alloc] initWithObject:self.locationObject];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)showPhotos {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    PFRelation* relation = [self.locationObject objectForKey:kWFLocationPhotosKey];
    PFQuery* query = [relation query];
    
    __typeof (&*self) __weak weakSelf = self;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            for (PFObject* object in objects) {
                PFFile* imageFile = [object objectForKey:kWFPhotoPictureKey];
                PFFile* thumbFile = [object objectForKey:kWFPhotoThumbnailKey];
                [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageFile.url]]];
                [self.thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:thumbFile.url]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
                
                // Create browser
                MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:weakSelf];
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
                [weakSelf presentViewController:nc animated:YES completion:nil];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
            });
        }
    }];
    
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
    ParallaxHeaderView* headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"banner2"] forSize:CGSizeMake(self.tableView.frame.size.width, 200)];
    headerView.headerTitleLabel.text = @"";
    self.tableView.tableHeaderView = headerView;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotos)];
    [headerView addGestureRecognizer:gesture];
    
    PFFile* displayFile = [self.locationObject objectForKey:kWFLocationDisplayPhotoKey];
    [displayFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error == nil) {
            headerView.headerImage = [UIImage imageWithData:data];
        }
    }];
    
    [self addGeneralSection];
    [self addInfoSection];
    [self addHoursSection];
    [self addAmenitiesSection];
    [self addReportEditSection];
    
    [self setPhotoCount];
    [self setReviewCount];

    self.bottomView.alpha = 1.0f;

    [self.tableView reloadData];
}

- (void)setPhotoCount {
    NSString* photoCountString = [NSString stringWithFormat:@"Photos(%@)", [(NSNumber*)[self.locationObject objectForKey:kWFLocationPhotoCountKey] stringValue]];
    [self.photosButton setTitle:photoCountString forState:UIControlStateNormal];
}

- (void)setReviewCount {
    NSString* reviewCountString = [NSString stringWithFormat:@"Reviews(%@)", [(NSNumber*)[self.locationObject objectForKey:kWFLocationReviewCountKey] stringValue]];
    [self.reviewsButton setTitle:reviewCountString forState:UIControlStateNormal];
}

- (void)addGeneralSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    self.generalItem = [WFDetailedViewItem itemWithName:[self.locationObject objectForKey:kWFLocationNameKey] delegate:self];
    self.generalItem.ratings = [self.locationObject objectForKey:kWFLocationRatingsKey];
    self.generalItem.phone = [self.locationObject objectForKey:kWFLocationPhoneKey];
    self.generalItem.email = [self.locationObject objectForKey:kWFLocationEmailKey];
    
    NSDictionary* addressDict = [self.locationObject objectForKey:kWFLocationAddressKey];
    self.generalItem.address = [WFHelper commaSeparatedString:@[[addressDict objectForKey:kAddressStreet],
                     [addressDict objectForKey:kAddressSubStreet],
                     [addressDict objectForKey:kAddressCity],
                     [addressDict objectForKey:kAddressSubCity],
                     [addressDict objectForKey:kAddressState],
                     [addressDict objectForKey:kAddressSubState],
                     [addressDict objectForKey:kAddressZIP],
                     [addressDict objectForKey:kAddressCountry],
                     ]];
    
    self.generalItem.longitude = [addressDict objectForKey:kAddressLongitude];
    self.generalItem.latitude = [addressDict objectForKey:kAddressLatitude];
    self.generalItem.website = [self.locationObject objectForKey:kWFLocationWebsiteKey];
    self.generalItem.facebookUrl = [self.locationObject objectForKey:kWFLocationFacebookKey];
    self.generalItem.twitterUrl = [self.locationObject objectForKey:kWFLocationTwitterKey];
    
    [section addItem:self.generalItem];
}

- (void)addInfoSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    NSString* aboutText = @"";
    
    __typeof (&*self) __weak weakSelf = self;
    [section addItem:[WFDetailedItem itemWithTitle:@"About" subTitle:[self.locationObject objectForKey:kWFLocationAboutKey] placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"about" selectionHandler:^(RETableViewItem *item) {
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:NO];
        WFDetailedItem* _item = (WFDetailedItem*)item;
        if (_item.value) {
            [WFFullTextView presentInView:self.view withText:aboutText];
        }
    }]];

    NSString* spaceString = [WFStringStore spaceTypeString:[[self.locationObject objectForKey:kWFLocationTypeKey] integerValue]];
    [section addItem:[WFDetailedItem itemWithTitle:@"Location Type" subTitle:spaceString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"locationtype"]];
    
    NSString* wifiString = @"Condition : ";
    wifiString = [wifiString stringByAppendingString:[WFStringStore wifiString:[[self.locationObject objectForKey:kWFLocationWifiTypeKey] integerValue]]];
    double wifiDwnldSpeed = [[self.locationObject objectForKey:kWFLocationWifiDownloadSpeedKey] doubleValue];
    double wifiUpldSpeed = [[self.locationObject objectForKey:kWFLocationWifiUploadSpeedKey] doubleValue];
    
    if (wifiDwnldSpeed < 1.0) {
        wifiDwnldSpeed *= 1000.0f;
        wifiString = [wifiString stringByAppendingFormat:@" - %0.1f Kbps download speed", wifiDwnldSpeed];
    } else if (wifiDwnldSpeed > 1000.0) {
        wifiDwnldSpeed /= 1000.0f;
        wifiString = [wifiString stringByAppendingFormat:@" - %0.1f Gbps download speed", wifiDwnldSpeed];
    } else {
        wifiString = [wifiString stringByAppendingFormat:@" - %0.1f Mbps download speed", wifiDwnldSpeed];
    }
    
    if (wifiUpldSpeed < 1.0) {
        wifiUpldSpeed *= 1000.0f;
        wifiString = [wifiString stringByAppendingFormat:@", %0.1f Kbps upload speed", wifiUpldSpeed];
    } else if (wifiUpldSpeed > 1000.0) {
        wifiUpldSpeed /= 1000.0f;
        wifiString = [wifiString stringByAppendingFormat:@", %0.1f Gbps upload speed", wifiUpldSpeed];
    } else {
        wifiString = [wifiString stringByAppendingFormat:@", %0.1f Mbps upload speed", wifiUpldSpeed];
    }

    [section addItem:[WFDetailedItem itemWithTitle:@"WiFi" subTitle:wifiString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"wifi"]];
    
    NSString* priceUnit = [WFStringStore priceUnitString:[[self.locationObject objectForKey:kWFLocationPricingUnitKey] integerValue]];
    NSDictionary* priceDict = [self.locationObject objectForKey:kWFLocationPricingKey];
    NSString* priceString = [NSString stringWithFormat:@"Day Pass - %@ %@, Weekly Pass - %@ %@, Monthly Pass - %@ %@", [priceDict objectForKey:kPriceDayPassKey], priceUnit, [priceDict objectForKey:kPriceWeekPassKey], priceUnit, [priceDict objectForKey:kPriceMonthPassKey], priceUnit];
    [section addItem:[WFDetailedItem itemWithTitle:@"Pricing" subTitle:priceString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"pricing"]];
    
    NSArray* powerOptions = [self.locationObject objectForKey:kWFLocationPowerOptionsKey];
    NSString* powerString = @"";
    for (NSInteger i=0; i<powerOptions.count; i++) {
        NSInteger val = [[powerOptions objectAtIndex:i] integerValue];
        powerString = [powerString stringByAppendingFormat:@"%@, ", [WFStringStore powerString:val]];
/*        if ([[powerOptions objectAtIndex:i] boolValue] == TRUE) {
            powerString = [powerString stringByAppendingFormat:@"%@, ", [WFStringStore powerString:i + 1]];
        }*/
    }
    if ([powerString hasSuffix:@", "]) {
        powerString = [powerString substringToIndex:powerString.length - 2];
    }
    
    [section addItem:[WFDetailedItem itemWithTitle:@"Power" subTitle:powerString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"power"]];
    
    NSArray* foodOptions = [self.locationObject objectForKey:kWFLocationFoodOptionsKey];
    NSString* foodString = @"";
    for (NSInteger i=0; i<foodOptions.count; i++) {
        NSInteger val = [[foodOptions objectAtIndex:i] integerValue];
        foodString = [foodString stringByAppendingFormat:@"%@, ", [WFStringStore foodString:val]];
/*        if ([[foodOptions objectAtIndex:i] boolValue] == TRUE) {
            foodString = [foodString stringByAppendingFormat:@"%@, ", [WFStringStore foodString:i + 1]];
        }*/
    }
    if ([foodString hasSuffix:@", "]) {
        foodString = [foodString substringToIndex:foodString.length - 2];
    }
    
    [section addItem:[WFDetailedItem itemWithTitle:@"Food" subTitle:foodString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"food"]];
    
    NSString* noiseString = [WFStringStore noiseString:[[self.locationObject objectForKey:kWFLocationNoiseOptionsKey] integerValue]];

    [section addItem:[WFDetailedItem itemWithTitle:@"Noise" subTitle:noiseString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"noise"]];
    
    NSArray* seatingOptions = [self.locationObject objectForKey:kWFLocationSeatingOptionsKey];
    NSString* seatingString = @"";
    for (NSInteger i=0; i<seatingOptions.count; i++) {
        NSInteger val = [[seatingOptions objectAtIndex:i] integerValue];
        seatingString = [seatingString stringByAppendingFormat:@"%@, ", [WFStringStore seatingString:val]];

/*        if ([[seatingOptions objectAtIndex:i] boolValue] == TRUE) {
            seatingString = [seatingString stringByAppendingFormat:@"%@, ", [WFStringStore seatingString:val]];
        }*/
    }
    if ([seatingString hasSuffix:@", "]) {
        seatingString = [seatingString substringToIndex:seatingString.length - 2];
    }
    
    [section addItem:[WFDetailedItem itemWithTitle:@"Seating" subTitle:seatingString placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"seat"]];
}

- (void)addHoursSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    NSArray* hourOptions = [self.locationObject objectForKey:kWFLocationOpenDaysKey];
    
    if (hourOptions && hourOptions.count) {
        NSMutableArray* hourArray = [NSMutableArray array];
        for (NSInteger i=WFMonday; i<=WFSunday; i++) {
            NSString* state;
            if ([hourOptions containsObject:[NSNumber numberWithInteger:i]]) state = @"Open";
            else state = @"Closed";
            
            [hourArray addObject:@{@"title":[[WFStringStore daysString:i] substringToIndex:3], @"value":state}];
        }
        
        [section addItem:[WFTwoColumnItem itemWithTitle:@"Hours"
                                              imageName:@"calendar"
                                               contents:hourArray]];
    } else {
        WFDetailedItem* item = [WFDetailedItem itemWithTitle:@"Hours" subTitle:nil placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:@"seat"];
        [section addItem:item];
    }
}

- (void)addAmenitiesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];

    NSArray* amenitiesOptions = [self.locationObject objectForKey:kWFLocationAmenitiesKey];
    NSMutableArray* amenitiesArray = [NSMutableArray array];
    
    if (amenitiesOptions && amenitiesOptions.count) {
        for (NSInteger i=0; i<amenitiesOptions.count; i++) {
            NSInteger val = [[amenitiesOptions objectAtIndex:i] integerValue];
            [amenitiesArray addObject:@{@"images":@{@"normal":@"check",@"disabled":@"check-disabled"},@"value":[WFStringStore amenitiesString:val]}];
            
/*            if ([[amenitiesOptions objectAtIndex:i] boolValue] == TRUE) {
                [amenitiesArray addObject:@{@"images":@{@"normal":@"check",@"disabled":@"check-disabled"},@"value":[WFStringStore amenitiesString:i + 1]}];
            }*/
        }
        
        [section addItem:[WFTwoColumnItem itemWithTitle:@"Amenities"
                                              imageName:nil
                                               contents:amenitiesArray]];
    } else {
        WFDetailedItem* item = [WFDetailedItem itemWithTitle:@"Amenities" subTitle:nil placeHolder:@"No information has been added here. Please tap \"Report Edits\" below to send us information." imageName:nil];
        [section addItem:item];
    }
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
    [[UIApplication sharedApplication] openURL:webURL];
}

- (void)facebookTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    if (_item.facebookUrl) {
        __typeof (&*self) __weak weakSelf = self;

        NSString* facebookUrl = [@"https://www.facebook.com/" stringByAppendingString:_item.facebookUrl];
        NSString* graphURLString = [@"https://graph.facebook.com/" stringByAppendingString:_item.facebookUrl];
        NSURL* graphURL = [NSURL URLWithString:graphURLString];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:graphURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError == nil) {
                NSError* error = nil;
                NSDictionary* parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error == nil) {
                    NSString* identifier = [parsedObject valueForKey:@"id"];
                    [weakSelf openPage:[NSString stringWithFormat:@"fb:///profile/%@", identifier] withURL:facebookUrl];
                }
            }
        }];
    }
}

- (void)twitterTapped:(RETableViewItem*)item {
    WFDetailedViewItem* _item = (WFDetailedViewItem*)item;
    if (_item.twitterUrl) {
        NSString* twitterUrl = [@"https://twitter.com/" stringByAppendingString:_item.twitterUrl];
        [self openPage:[NSString stringWithFormat:@"twitter:///user?screen_name=%@", _item.twitterUrl] withURL:twitterUrl];
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

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [_photos removeAllObjects];
    [_thumbs removeAllObjects];
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
            NSURL* phoneURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:[self.locationObject objectForKey:kWFLocationPhoneKey]]];
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                [[UIApplication sharedApplication] openURL:phoneURL];
            }
        }
    }
}

@end
