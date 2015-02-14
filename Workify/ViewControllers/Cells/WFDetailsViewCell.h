//
//  WFDetailsViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 07/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFDetailedViewItem.h"

@interface WFDetailsViewCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFDetailedViewItem *item;

@end
