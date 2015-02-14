//
//  WFMultilineTextCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFMultilineTextItem.h"
#import "RETableViewCell.h"

@interface WFMultilineTextCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFMultilineTextItem *item;
@property (strong, readonly, nonatomic) UILabel *multilineLabel;

@end
