//
//  WFLoginViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/21/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFUser;

@protocol WFLoginDelegate <NSObject>
- (void)loggedInWithUser:(PFUser*)user error:(NSError*)error;
@end

@interface WFLoginViewController : UIViewController

@property (nonatomic, assign) BOOL showStatusBar;

@property(nonatomic, strong) id<WFLoginDelegate> loginDelegate;

@end
