//
//  WFEnumConstants.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/22/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#ifndef Workify_WFEnumConstants_h
#define Workify_WFEnumConstants_h

//Noise
typedef NS_ENUM(NSInteger, WFNoiseType) {
    WFNoiseSilence = 0,
    WFNoiseAverage = 1,
    WFNoiseNoisy = 2
};

/*
//Space Type
typedef NS_ENUM(NSInteger, WFSpaceType) {
    WFSpaceCafe = 0,
    WFSpaceCoWorking = 1,
    WFSpaceLiving = 2
};

//Noise
typedef NS_ENUM(NSInteger, WFNoiseType) {
    WFNoiseSilence = 0,
    WFNoiseAverage = 1,
    WFNoiseNoisy = 2
};

//Food
typedef NS_ENUM(NSInteger, WFFoodType) {
    WFFoodCoffeeTea = 0,
    WFFoodAlcohol = 1,
    WFFoodBreakfast = 2,
    WFFoodLunch = 3,
    WFFoodSnacks = 4,
    WFFoodDinner = 5
};

//Seating
typedef NS_ENUM(NSInteger, WFSeatingType) {
    WFSeatIndoor = 0,
    WFSeatOutdoor = 1,
    WFSeatSeparateRoom = 2,
    WFSeatStandingDesk = 3,
    WFSeatTableFor1to4 = 4,
    WFSeatTableForMoreThan5 = 5
};

//Power
typedef NS_ENUM(NSInteger, WFPowerType) {
    WFPowerNone = 0,
    WFPowerLimited = 1,
    WFPowerGood = 2,
    WFPowerEnough = 3
};

//Amenities
typedef NS_ENUM(NSInteger, WFAmenitiesType) {
    WFAmenityAC = 0,
    WFAmenityTV = 1,
    WFAmenityKidFriendly = 2,
    WFAmenityDogFriendly = 3,
    WFAmenityWashroom = 4,
    WFAmenityParking = 5
};*/

//Days
typedef NS_ENUM(NSInteger, WFDay) {
    WFMonday = 0,
    WFTuesday = 1,
    WFWednesday = 2,
    WFThursday = 3,
    WFFriday = 4,
    WFSaturday = 5,
    WFSunday = 6
};

//Wifi
typedef NS_ENUM(NSInteger, WFWifiType) {
    WFWifiReliable = 0,
    WFWifiShaky = 1,
    WFWifiAbsent = 2,
    WFWifiDontKnow = 3
};

//Wifi Speed
typedef NS_ENUM(NSInteger, WFWifiSpeedType) {
    WFWifiSpeed0Mbps = 0,
    WFWifiSpeed256Kbps = 1,
    WFWifiSpeed512Kbps = 2,
    WFWifiSpeed1Mbps = 3,
    WFWifiSpeed2Mbps = 4,
    WFWifiSpeed4Mbps = 5,
    WFWifiSpeed10Mbps = 6
};

//Wifi Speed Units
typedef NS_ENUM(NSInteger, WFWifiSpeedUnit) {
    WFWifiSpeedKbps = 0,
    WFWifiSpeedMbps = 1,
    WFWifiSpeedGbps = 2,
};

//Price Units
typedef NS_ENUM(NSInteger, WFWifiPriceUnit) {
    WFPriceINR = 0,
    WFPriceDollar = 1,
    WFPricePound = 2,
    WFPriceEuro = 3,
};

#endif
