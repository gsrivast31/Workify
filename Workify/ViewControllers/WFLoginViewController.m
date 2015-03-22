//
//  WFLoginViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/21/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLoginViewController.h"
#import "MZFormSheetController.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface WFLoginViewController ()

@property (nonatomic, strong) FUIButton* loginButton;
@property (nonatomic, strong) UILabel* captionLabel;

@end

@implementation WFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captionLabel = [[UILabel alloc] init];
    self.captionLabel.font = [UIFont flatFontOfSize:15];
    self.captionLabel.textAlignment = NSTextAlignmentCenter;
    self.captionLabel.text = @"You are not signed in. Sign in to continue.\n Tap to cancel.";
    self.captionLabel.textColor = [UIColor turquoiseColor];
    self.captionLabel.numberOfLines = 0;
    
    [self.view addSubview:self.captionLabel];
    
    self.loginButton = [[FUIButton alloc] init];
    self.loginButton.titleLabel.font = [UIFont iconFontWithSize:14];
    self.loginButton.buttonColor = [UIColor colorFromHexCode:@"3b5998"];
    self.loginButton.shadowColor = [UIColor colorFromHexCode:@"3b5998"];
    self.loginButton.shadowHeight = 3.0f;
    self.loginButton.cornerRadius = 3.0f;
    [self.loginButton setTitle:[NSString stringWithFormat:@"%@ LOGIN WITH FACEBOOK", [NSString iconStringForEnum:FUIFacebook]] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.loginButton];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat textHeight = [self.captionLabel.text re_sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(200.0f, INFINITY)].height;
    CGRect textRect = CGRectMake((self.view.frame.size.width - 200.0f)/2.0f, 20.0f, 200.0f, textHeight);
    self.captionLabel.frame = textRect;
    self.loginButton.frame = CGRectMake((self.view.frame.size.width - 240.0f)/2.0f, 20.0f + textHeight + 20.0f, 240.0f, 60.0f);

}

- (void)login:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (self.loginDelegate && [self.loginDelegate respondsToSelector:@selector(loggedInWithUser:error:)]) {
            [self.loginDelegate loggedInWithUser:user error:error];
        }
    }];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    //    return self.showStatusBar; // your own visibility code
    return NO;
}

@end
