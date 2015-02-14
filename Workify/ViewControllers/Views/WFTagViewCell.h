//
//  WFTagViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFTagItem.h"
#import "RETableViewCell.h"

@interface WFTagViewCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFTagItem *item;

@end
