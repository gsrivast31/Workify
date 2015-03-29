//
//  WFOptionViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFOptionItem.h"

@protocol WFSingleOptionDelegate <NSObject>

- (void)optionToggled;

@end

@interface WFSingleOptionView : UIView

- (id)init;
- (void)setContent:(NSString*)text andTag:(NSInteger)tag;
+ (CGFloat)heightWithText:(NSString*)text constrainedToWidth:(CGFloat)width;

@property (nonatomic) BOOL state;
@property (nonatomic) NSInteger tag;
@property (nonatomic, strong) id<WFSingleOptionDelegate> delegate;

@end

@interface WFOptionViewCell : RETableViewCell<WFSingleOptionDelegate>

@property (nonatomic, strong, readwrite) WFOptionItem* item;
@property (nonatomic, strong) NSMutableArray* viewsArray;
@property (readwrite, nonatomic) NSUInteger itemCount;

@end
