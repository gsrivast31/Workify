//
//  WFAppDelegate.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAppDelegate.h"
#import <RETableViewManager/RETableViewCell.h>
#import "REFrostedViewController.h"
#import "UAAppReviewManager.h"
#import "WFSideMenuViewController.h"
#import "WFNavigationController.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface WFAppDelegate () <REFrostedViewControllerDelegate>

@end

@implementation WFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Fill in with your Parse credentials:
    // ****************************************************************************
    [Parse setApplicationId:@"bQq1Yxu8avvF2wsLi8kb9wMD8I5Xz3mfLo0pA5E3" clientKey:@"DND6IMQmrkPlBqiI3WIJ6AYSwPsJrQ7SrtH960bw"];
    
    // ****************************************************************************
    // Your Facebook application id is configured in Info.plist.
    // ****************************************************************************
    [PFFacebookUtils initializeFacebook];

    // Initialise Appirater
    [UAAppReviewManager setAppID:@""];
    [UAAppReviewManager setDaysUntilPrompt:2];
    [UAAppReviewManager setUsesUntilPrompt:5];
    [UAAppReviewManager setSignificantEventsUntilPrompt:-1];
    [UAAppReviewManager setDaysBeforeReminding:3];
    [UAAppReviewManager setReviewMessage:NSLocalizedString(@"If you find Workify useful you can help support further development by leaving a review on the App Store. It'll only take a minute!", nil)];
    
    WFSideMenuViewController* sideVC = [[WFSideMenuViewController alloc] init];
    WFNavigationController* navVC = (WFNavigationController*)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"rootController"];
    
    REFrostedViewController* mainVC = [[REFrostedViewController alloc] initWithContentViewController:navVC menuViewController:sideVC];
    mainVC.direction = REFrostedViewControllerDirectionLeft;
    mainVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    mainVC.liveBlur = YES;
    mainVC.delegate = self;
    mainVC.blurSaturationDeltaFactor = 3.0f;
    mainVC.blurRadius = 10.0f;
    mainVC.limitMenuViewSize = YES;
    
    CGFloat menuWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 340.0f : 280.0f;
    mainVC.menuViewSize = CGSizeMake(menuWidth, self.window.frame.size.height);
    
    self.viewController = mainVC;
    
    self.window.rootViewController = mainVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupStyling];
    
    // Let UAAppReviewManager know our application has launched
    [UAAppReviewManager showPromptIfNecessary];
    return YES;
}

- (void)setupStyling {
    [[UINavigationBar appearance] setBarTintColor:[UIColor turquoiseColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont flatFontOfSize:17],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]
                                                           }];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor turquoiseColor]];
    [[RETableViewCell appearance] setTintColor:[UIColor turquoiseColor]];
    [[REActionBar appearance] setTintColor:[UIColor turquoiseColor]];
}

// ****************************************************************************
// App switching methods to support Facebook Single Sign-On.
// ****************************************************************************
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UAAppReviewManager showPromptIfNecessary];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PFFacebookUtils session] close];

}

@end
