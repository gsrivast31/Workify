//
//  WFFullTextView.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/17/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "FXBlurView.h"

@interface WFFullTextView : FXBlurView

@property (nonatomic, strong) NSString* text;

// Setup
+ (id)presentInView:(UIView *)parentView withText:(NSString*)text;

@end
