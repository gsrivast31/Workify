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

+ (BOOL)isEmpty:(NSString*)string {
    return (!string) || ([string isEqualToString:@""]);
}

+ (NSNumber*)wifiSpeedInMbps:(NSString*)speedString fromUnit:(WFWifiSpeedUnit)unit {
    double speed = [speedString doubleValue];
    if (unit == WFWifiSpeedKbps) {
        speed = speed * 0.001f;
    } else if (unit == WFWifiSpeedGbps) {
        speed = speed * 1000.0f;
    }
    return [NSNumber numberWithDouble:speed];
}


@end
