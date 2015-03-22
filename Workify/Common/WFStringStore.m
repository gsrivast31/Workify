//
//  WFStringStore.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFStringStore.h"
#import "WFEnumConstants.h"
#import "WFStringConstants.h"

@implementation WFStringStore

+ (NSArray*)spaceTypeStrings {
    static dispatch_once_t pred;
    static NSArray *spaceTypeStrings = nil;
    dispatch_once(&pred, ^{
        spaceTypeStrings = @[kSpaceCafe, kSpaceCoWorking, kSpaceLiving];
    });
    
    return spaceTypeStrings;
}

+ (NSArray*)wifiStrings {
    static dispatch_once_t pred;
    static NSArray *wifiStrings = nil;
    dispatch_once(&pred, ^{
        wifiStrings = @[kWifiReliable, kWifiShaky, kWifiAbsent, kWifiDontKnow];
    });
    
    return wifiStrings;
}

+ (NSArray*)wifiSpeedStrings {
    static dispatch_once_t pred;
    static NSArray *wifiSpeedStrings = nil;
    dispatch_once(&pred, ^{
        wifiSpeedStrings = @[kWifiSpeed256Kbps, kWifiSpeed512Kbps, kWifiSpeed1Mbps, kWifiSpeed2Mbps, kWifiSpeed4Mbps, kWifiSpeed10Mbps];
    });
    
    return wifiSpeedStrings;
}

+ (NSArray*)noiseStrings {
    static dispatch_once_t pred;
    static NSArray *noiseStrings = nil;
    dispatch_once(&pred, ^{
        noiseStrings = @[kNoiseSilence, kNoiseAverage, kNoiseNoisy];
    });
    
    return noiseStrings;
}

+(NSArray*)foodStrings {
    static dispatch_once_t pred;
    static NSArray *foodStrings = nil;
    dispatch_once(&pred, ^{
        foodStrings = @[kFoodCoffeeTea, kFoodAlcohol, kFoodBreakfast, kFoodLunch, kFoodSnacks, kFoodDinner];
    });
    
    return foodStrings;
}

+ (NSArray*)seatingStrings {
    static dispatch_once_t pred;
    static NSArray *seatingStrings = nil;
    dispatch_once(&pred, ^{
        seatingStrings = @[kSeatIndoor, kSeatOutdoor, kSeatSeparateRoom, kSeatStandingDesk, kSeatTableFor1to4, kSeatTableForMoreThan5];
    });
    
    return seatingStrings;
}

+ (NSArray*)powerStrings {
    static dispatch_once_t pred;
    static NSArray *powerStrings = nil;
    dispatch_once(&pred, ^{
        powerStrings = @[kPowerNone, kPowerLimited, kPowerGood, kPowerEnough];
    });
    
    return powerStrings;
}

+(NSArray*)amenitiesStrings {
    static dispatch_once_t pred;
    static NSArray *amenitiesStrings = nil;
    dispatch_once(&pred, ^{
        amenitiesStrings = @[kAmenityAC, kAmenityTV, kAmenityKidFriendly, kAmenityDogFriendly, kAmenityWashroom, kAmenityParking];
    });
    
    return amenitiesStrings;
}

+ (NSString*)spaceTypeString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore spaceTypeStrings].count) {
        return [[WFStringStore spaceTypeStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)wifiString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore wifiStrings].count) {
        return [[WFStringStore wifiStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)wifiSpeedString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore wifiSpeedStrings].count) {
        return [[WFStringStore wifiSpeedStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)noiseString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore noiseStrings].count) {
        return [[WFStringStore noiseStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)foodString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore foodStrings].count) {
        return [[WFStringStore foodStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)seatingString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore seatingStrings].count) {
        return [[WFStringStore seatingStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)powerString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore powerStrings].count) {
        return [[WFStringStore powerStrings] objectAtIndex:type - 1];
    }
    return nil;
}

+ (NSString*)amenitiesString:(int16_t)type {
    if (type > 0 && type <= [WFStringStore amenitiesStrings].count) {
        return [[WFStringStore amenitiesStrings] objectAtIndex:type - 1];
    }
    return nil;
}

@end
