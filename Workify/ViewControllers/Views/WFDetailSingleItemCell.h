//
//  WFDetailSingleItemCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 08/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFDetailedItem.h"

@interface WFDetailSingleItemCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFDetailedItem *item;

@end
