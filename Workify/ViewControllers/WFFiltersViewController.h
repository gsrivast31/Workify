//
//  WFFiltersViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFFilterDelegate <NSObject>

- (void)filtersAdded:(NSDictionary*)filterDictionary;

@end

@interface WFFiltersViewController : UIViewController

@property (nonatomic, strong) id<WFFilterDelegate> delegate;

@end
