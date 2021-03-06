//
//  WFHourViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"

@interface WFSingleDayCell : UIView

@property (nonatomic, strong) UITextField* startHourTextField;
@property (nonatomic, strong) UITextField* endHourTextField;

- (id)initWithDay:(NSString*)day;
- (void)setContentFrame:(CGRect)frame;
- (void)setContent:(NSDictionary*)dict;

@end

@interface WFHourViewCell : RETableViewCell

@end
