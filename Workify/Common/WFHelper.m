//
//  WFHelper.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFHelper.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@implementation WFHelper

+ (BOOL) isLoggedIn {
    return ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]);
}

+ (NSString*) commaSeparatedString:(NSArray*)array {
    NSString* string = @"";
    for (NSString* str in array) {
        if (![str isEqualToString:@""]) {
            string = [string stringByAppendingFormat:@"%@, ", str];
        }
    }
    if ([string hasSuffix:@", "]) {
        string = [string substringToIndex:string.length - 2];
    }
    return string;
}


@end
