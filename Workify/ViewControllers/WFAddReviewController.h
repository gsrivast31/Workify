//
//  WFAddReviewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/22/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFAddReviewDelegate <NSObject>

- (void)reviewAdded:(NSDictionary*)reviewDictionary;
- (void)reviewCanceled;

@end

@interface WFAddReviewController : UITableViewController

@property (nonatomic, strong) id <WFAddReviewDelegate> delegate;

@end
