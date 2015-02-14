//
//  WFTwoColumnViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 08/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFTwoColumnItem.h"

@interface WFSingleColumnView : UIView

- (id)init;
- (void)setContentFrame:(CGRect)frame;
- (void)setContent:(NSDictionary*)dict;

@end

@interface WFTwoColumnViewCell : RETableViewCell

@property (strong, readwrite, nonatomic) WFTwoColumnItem *item;
@property (readwrite, nonatomic) NSUInteger itemCount;

@end
