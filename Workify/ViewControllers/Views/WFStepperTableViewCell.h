//
//  WFStepperTableViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFStepperItem.h"

@interface WFStepperTableViewCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFStepperItem *item;

@end
