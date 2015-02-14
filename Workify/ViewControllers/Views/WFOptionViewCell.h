//
//  WFOptionViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFOptionItem.h"

@interface WFSingleOptionView : UIView

- (id)init;
- (void)setContent:(NSDictionary*)dict;

@end

@interface WFOptionViewCell : RETableViewCell

@property (nonatomic, strong, readwrite) WFOptionItem* item;
@property (readwrite, nonatomic) NSUInteger itemCount;

@end
