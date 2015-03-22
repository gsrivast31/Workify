//
//  WFLocationSearchViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/20/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@class CLPlacemark;

@protocol WFAddAddressDelegate <NSObject>

- (void)addressAdded:(NSDictionary*)addressDictionary;

@end

@interface WFDistanceView : UIView

- (id)initWithFrame:(CGRect)frame from:(CLLocation*)fromLocation to:(CLLocation*)toLocation;

@property (nonatomic, strong) UILabel* distanceLabel;
@property (nonatomic, strong) UILabel* arrowLabel;

@end

@interface WFLocationSearchViewController : UITableViewController

@property (nonatomic, strong) CLPlacemark* currentPlaceMark;
@property (weak, readwrite, nonatomic) id<WFAddAddressDelegate> delegate;

@end
