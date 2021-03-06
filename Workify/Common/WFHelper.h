//
//  WFHelper.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

@interface WFHelper : NSObject

+ (BOOL) isLoggedIn;
+ (NSString*) commaSeparatedString:(NSArray*)array;
+ (BOOL)isEmpty:(NSString*)string;
+ (NSNumber*)wifiSpeedInMbps:(NSString*)speedString fromUnit:(WFWifiSpeedUnit)unit;

@end
