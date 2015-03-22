//
//  WFButtonCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/19/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFButtonItem.h"

@interface WFButtonCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFButtonItem *item;

@end
