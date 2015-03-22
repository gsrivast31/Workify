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

+ (NSString*)spaceTypeString:(int16_t)type;
+ (NSString*)wifiString:(int16_t)type;
+ (NSString*)wifiSpeedString:(int16_t)type;
+ (NSString*)noiseString:(int16_t)type;
+ (NSString*)foodString:(int16_t)type;
+ (NSString*)seatingString:(int16_t)type;
+ (NSString*)powerString:(int16_t)type;
+ (NSString*)amenitiesString:(int16_t)type;

@end
