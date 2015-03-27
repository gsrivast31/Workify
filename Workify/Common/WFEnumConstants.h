//
//  WFEnumConstants.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/22/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#ifndef Workify_WFEnumConstants_h
#define Workify_WFEnumConstants_h

//Space Type
typedef NS_ENUM(NSInteger, WFSpaceType) {
    WFSpaceCafe = 1,
    WFSpaceCoWorking = 2,
    WFSpaceLiving = 3
};

//Wifi
typedef NS_ENUM(NSInteger, WFWifiType) {
    WFWifiReliable = 1,
    WFWifiShaky = 2,
    WFWifiAbsent = 3,
    WFWifiDontKnow = 4
};

//Wifi Speed
typedef NS_ENUM(NSInteger, WFWifiSpeedType) {
    WFWifiSpeed256Kbps = 1,
    WFWifiSpeed512Kbps = 2,
    WFWifiSpeed1Mbps = 3,
    WFWifiSpeed2Mbps = 4,
    WFWifiSpeed4Mbps = 5,
    WFWifiSpeed10Mbps = 6
};

//Noise
typedef NS_ENUM(NSInteger, WFNoiseType) {
    WFNoiseSilence = 1,
    WFNoiseAverage = 2,
    WFNoiseNoisy = 3
};

//Food
typedef NS_ENUM(NSInteger, WFFoodType) {
    WFFoodCoffeeTea = 1,
    WFFoodAlcohol = 2,
    WFFoodBreakfast = 3,
    WFFoodLunch = 4,
    WFFoodSnacks = 5,
    WFFoodDinner = 6
};

//Seating
typedef NS_ENUM(NSInteger, WFSeatingType) {
    WFSeatIndoor = 1,
    WFSeatOutdoor = 2,
    WFSeatSeparateRoom = 3,
    WFSeatStandingDesk = 4,
    WFSeatTableFor1to4 = 5,
    WFSeatTableForMoreThan5 = 6
};

//Power
typedef NS_ENUM(NSInteger, WFPowerType) {
    WFPowerNone = 1,
    WFPowerLimited = 2,
    WFPowerGood = 3,
    WFPowerEnough = 4
};

//Amenities
typedef NS_ENUM(NSInteger, WFAmenitiesType) {
    WFAmenityAC = 1,
    WFAmenityTV = 2,
    WFAmenityKidFriendly = 3,
    WFAmenityDogFriendly = 4,
    WFAmenityWashroom = 5,
    WFAmenityParking = 6
};

//Days
typedef NS_ENUM(NSInteger, WFDay) {
    WFMonday = 1,
    WFTuesday = 2,
    WFWednesday = 3,
    WFThursday = 4,
    WFFriday = 5,
    WFSaturday = 6,
    WFSunday = 7
};

#endif
