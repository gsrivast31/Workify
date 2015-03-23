//
//  WFAddURLViewController.h
//  Workify
//
//  Created by Ranjeet on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFAddURLDelegate <NSObject>

- (void)urlsAdded:(NSArray*)urlArray;
- (void)noUrlAdded;

@end

@interface WFAddURLViewController : UIViewController

@property (nonatomic, strong) id <WFAddURLDelegate> delegate;

@end
