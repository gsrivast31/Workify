//
//  WFSideMenuViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/19/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFSideMenuViewController.h"
#import "REFrostedViewController.h"
#import "WFAppDelegate.h"
#import "WFNavigationController.h"
#import "WFLocationSearchViewController.h"
#import "WFAddPlaceViewController.h"

#import <MessageUI/MessageUI.h>
#import "UAAppReviewManager.h"
#import "UIView+Animation.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface WFUserView()

@property (nonatomic, strong) FUIButton* loginButton;
@property (nonatomic, strong) UIImageView* profileImageView;
@property (nonatomic, strong) UILabel* usernameLabel;
@property (nonatomic, strong) FUIButton* logoutButton;

@end

@implementation WFUserView

@synthesize loginButton;
@synthesize profileImageView;
@synthesize usernameLabel;
@synthesize logoutButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        loginButton = [[FUIButton alloc] init];
        loginButton.titleLabel.font = [UIFont iconFontWithSize:14];
        loginButton.buttonColor = [UIColor colorFromHexCode:@"3b5998"];
        loginButton.shadowColor = [UIColor colorFromHexCode:@"3b5998"];
        loginButton.shadowHeight = 3.0f;
        loginButton.cornerRadius = 3.0f;
        [loginButton setTitle:[NSString stringWithFormat:@"%@ LOGIN WITH FACEBOOK", [NSString iconStringForEnum:FUIFacebook]] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        logoutButton = [[FUIButton alloc] init];
        logoutButton.titleLabel.font = [UIFont iconFontWithSize:13];
        logoutButton.buttonColor = [UIColor colorFromHexCode:@"3b5998"];
        logoutButton.shadowColor = [UIColor colorFromHexCode:@"3b5998"];
        logoutButton.shadowHeight = 3.0f;
        logoutButton.cornerRadius = 3.0f;
        [logoutButton setTitle:[NSString stringWithFormat:@"%@ LOGOUT", [NSString iconStringForEnum:FUIFacebook]] forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        profileImageView = [[UIImageView alloc] init];
        profileImageView.layer.masksToBounds = YES;
        profileImageView.layer.cornerRadius = 50.0;
        profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        profileImageView.layer.borderWidth = 3.0f;
        profileImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        profileImageView.layer.shouldRasterize = YES;
        profileImageView.clipsToBounds = YES;
        
        usernameLabel = [[UILabel alloc] init];
        usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        usernameLabel.backgroundColor = [UIColor clearColor];
        usernameLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        usernameLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:loginButton];
        [self addSubview:logoutButton];
        [self addSubview:profileImageView];
        [self addSubview:usernameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    loginButton.frame = CGRectMake(20.0f, (self.frame.size.height - 50.0f)/2.0, self.frame.size.width - 40.0f, 50.0f);
    
    CGFloat startY = self.frame.size.height - 25.0f - 30.0f - 100.0f - 20.0f - 10.0f - 5.0f;
    profileImageView.frame = CGRectMake((self.frame.size.width - 100.0f)/2.0, startY, 100.0f, 100.0f);
    
    startY += 100.0f + 10.0f;
    usernameLabel.frame = CGRectMake(10.0f, startY, self.frame.size.width - 20.0f, 25.0f);
    
    startY += 25.0f + 5.0f;
    logoutButton.frame = CGRectMake((self.frame.size.width - 100.0f)/2.0, startY, 100.0f, 30.0f);
}

- (void)login:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
        
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
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self _loadData];
        }
    }];
    
//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (void)setLoginState {
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self _loadData];
    } else {
        [self setViewState:FALSE];
    }
}

- (void)setViewState:(BOOL)isLoggedIn {
    loginButton.hidden = isLoggedIn;
    profileImageView.hidden = !isLoggedIn;
    usernameLabel.hidden = !isLoggedIn;
    logoutButton.hidden = !isLoggedIn;
}

- (void)logout:(id)sender {
    [PFUser logOut];
    [self setViewState:FALSE];
}

- (void)_loadData {
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self _updateProfileData];
    }
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:3];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                userProfile[@"name"] = name;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self _updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logout:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

// Set received values if they are not nil and reload the table
- (void)_updateProfileData {
    [self setViewState:TRUE];
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.usernameLabel.text = name;
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.profileImageView.image = [UIImage imageWithData:data];
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}

- (void)animateLoginButton {
    [self.loginButton animateWithBounce];
}

@end

@interface WFSideMenuViewController () <MFMailComposeViewControllerDelegate, WFAddPlaceDelegate>

@property (nonatomic, strong) WFUserView* userView;

@end

@implementation WFSideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.userView = [[WFUserView alloc] initWithFrame:CGRectMake(0, 0, 0, 220.0f)];
    self.tableView.tableHeaderView = self.userView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.userView setLoginState];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont flatFontOfSize:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Settings";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WFAppDelegate* appDelegate = (WFAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* navVC = (UINavigationController*)[(REFrostedViewController*)appDelegate.viewController contentViewController];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [(REFrostedViewController*)appDelegate.viewController hideMenuViewController];
            [navVC popToRootViewControllerAnimated:NO];
        } else if (indexPath.row == 1) {
            if (![WFHelper isLoggedIn]) {
                [self.userView animateLoginButton];
                return;
            }
            [(REFrostedViewController*)appDelegate.viewController hideMenuViewController];
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            WFAddPlaceViewController* vc = (WFAddPlaceViewController*)[storyboard instantiateViewControllerWithIdentifier:@"addPlaceController"];
            vc.delegate = self;
            [navVC pushViewController:vc animated:NO];
        }
    } else if (indexPath.section == 1) {
        [(REFrostedViewController*)appDelegate.viewController hideMenuViewController];
        if (indexPath.row == 0) {
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                [mailController setMailComposeDelegate:self];
                [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
                [mailController setSubject:[NSString stringWithFormat:@"%@ Support", APP_NAME]];
                [mailController setToRecipients:@[@"gaurav.sri87@gmail.com"]];
                [mailController setMessageBody:[NSString stringWithFormat:@"%@\n\n", NSLocalizedString(@"Here's my feedback:", @"A default message shown to users when contacting support for help")] isHTML:NO];
                if(mailController) {
                    [navVC presentViewController:mailController animated:YES completion:nil];
                }
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                    message:NSLocalizedString(@"This device hasn't been setup to send emails.", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        } else if (indexPath.row == 1) {
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                [mailController setMailComposeDelegate:self];
                [mailController setModalPresentationStyle:UIModalPresentationFormSheet];
                [mailController setSubject:[NSString stringWithFormat:@"Checkout this:%@", APP_NAME]];
                
                NSString *body = [NSString stringWithFormat:@"Hey! I found this cool app <b><u><a href='%@'>%@</a></u></b>. Check it out.", APP_URL, APP_NAME];
                [mailController setMessageBody:body isHTML:YES];
                if(mailController) {
                    [navVC presentViewController:mailController animated:YES completion:nil];
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
            [UAAppReviewManager rateApp];
        }
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) return 2;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Home", @"Suggest a place"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"Give feedback", @"Tell a friend", @"Rate this app"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

#pragma mark - MFMailComposeViewDelegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    if (result == MFMailComposeResultSent) {
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark WFAddPlaceDelegate 

- (void)placeAdded:(BOOL)success error:(NSError *)error {
    if (success) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your suggestion has been received. We will get back to you soon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else if (error) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Could not save the suggestion. Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    WFAppDelegate* appDelegate = (WFAppDelegate*)[[UIApplication sharedApplication] delegate];
    UINavigationController* navVC = (UINavigationController*)[(REFrostedViewController*)appDelegate.viewController contentViewController];
    [navVC popToRootViewControllerAnimated:YES];

}

@end
