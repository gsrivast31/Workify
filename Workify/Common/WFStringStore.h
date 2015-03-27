//
//  WFStringStore.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFStringStore : NSObject

+ (NSArray*)spaceTypeStrings;
+ (NSArray*)wifiStrings;
+ (NSArray*)wifiSpeedStrings;
+ (NSArray*)noiseStrings;
+ (NSArray*)foodStrings;
+ (NSArray*)seatingStrings;
+ (NSArray*)powerStrings;
+ (NSArray*)amenitiesStrings;
+ (NSArray*)daysStrings;

+ (NSString*)spaceTypeString:(NSInteger)type;
+ (NSString*)wifiString:(NSInteger)type;
+ (NSString*)wifiSpeedString:(NSInteger)type;
+ (NSString*)noiseString:(NSInteger)type;
+ (NSString*)foodString:(NSInteger)type;
+ (NSString*)seatingString:(NSInteger)type;
+ (NSString*)powerString:(NSInteger)type;
+ (NSString*)amenitiesString:(NSInteger)type;
+ (NSString*)daysString:(NSInteger)type;

+ (NSInteger)spaceTypeIndex:(NSString*)string;
+ (NSInteger)wifiIndex:(NSString*)string;
+ (NSInteger)wifiSpeedIndex:(NSString*)string;
+ (NSInteger)noiseIndex:(NSString*)string;
+ (NSInteger)foodIndex:(NSString*)string;
+ (NSInteger)seatingIndex:(NSString*)string;
+ (NSInteger)powerIndex:(NSString*)string;
+ (NSInteger)amenitiesIndex:(NSString*)string;
+ (NSInteger)daysIndex:(NSString*)string;

@end
