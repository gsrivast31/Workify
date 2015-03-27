//
//  WFStringConstants.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/22/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#ifndef Workify_WFStringConstants_h
#define Workify_WFStringConstants_h

//Space Type
static NSString* const kSpaceCafe = @"Cafe/Restaurant";
static NSString* const kSpaceCoWorking = @"Co-working space";
static NSString* const kSpaceLiving = @"Living space";

//Wifi
static NSString* const kWifiReliable = @"Reliable";
static NSString* const kWifiShaky = @"Shaky";
static NSString* const kWifiAbsent = @"Absent";
static NSString* const kWifiDontKnow = @"Don't know";

//Wifi Speed
static NSString* const kWifiSpeed256Kbps = @"256 Kbps";
static NSString* const kWifiSpeed512Kbps = @"512 Kbps";
static NSString* const kWifiSpeed1Mbps = @"1 Mbps";
static NSString* const kWifiSpeed2Mbps = @"2 Mbps";
static NSString* const kWifiSpeed4Mbps = @"4 Mbps";
static NSString* const kWifiSpeed10Mbps = @"10 Mbps";

//Pricing
static NSString* const kPriceDayPassKey = @"dayPass";
static NSString* const kPriceWeekPassKey = @"weekPass";
static NSString* const kPriceMonthPassKey = @"monthPass";

//Noise
static NSString* const kNoiseSilence = @"Silence";
static NSString* const kNoiseAverage = @"Avg. Noisy";
static NSString* const kNoiseNoisy = @"Noisy";

//Food
static NSString* const kFoodCoffeeTea = @"Coffee/Tea";
static NSString* const kFoodAlcohol = @"Alcohol";
static NSString* const kFoodBreakfast = @"Breakfast";
static NSString* const kFoodSnacks = @"Snacks";
static NSString* const kFoodLunch = @"Lunch";
static NSString* const kFoodDinner = @"Dinner";

//Seating
static NSString* const kSeatIndoor = @"Indoor";
static NSString* const kSeatOutdoor = @"OutDoor";
static NSString* const kSeatSeparateRoom = @"Separate Room";
static NSString* const kSeatStandingDesk = @"Standing Desk";
static NSString* const kSeatTableFor1to4 = @"Table for 1-4";
static NSString* const kSeatTableForMoreThan5 = @"Table for >5";

//Power
static NSString* const kPowerNone = @"None";
static NSString* const kPowerLimited = @"Limited(less than 1/4 tables)";
static NSString* const kPowerGood = @"Good(Between 1/4 - 1/2 tables)";
static NSString* const kPowerEnough = @"Enough(More than 1/2 tables)";

//Amenities
static NSString* const kAmenityAC = @"Air Conditioner";
static NSString* const kAmenityTV = @"Television";
static NSString* const kAmenityDogFriendly = @"Dog Friendly";
static NSString* const kAmenityKidFriendly = @"Kid Friendly";
static NSString* const kAmenityWashroom = @"Washroom";
static NSString* const kAmenityParking = @"Parking";

//Days
static NSString* const kMonday = @"Monday";
static NSString* const kTuesday = @"Tuesday";
static NSString* const kWednesday = @"Wednesday";
static NSString* const kThursday = @"Thursday";
static NSString* const kFriday = @"Friday";
static NSString* const kSaturday = @"Saturday";
static NSString* const kSunday = @"Sunday";

//Address
static NSString* const kAddressStreet = @"ThoroughFare";
static NSString* const kAddressCity = @"Locality";
static NSString* const kAddressState = @"AdministrativeArea";
static NSString* const kAddressZIP = @"PostalCode";
static NSString* const kAddressCountry = @"Country";
static NSString* const kAddressLatitude = @"Latitude";
static NSString* const kAddressLongitude = @"Longitude";

//Reviews
static NSString * const kReviewsKey   = @"Reviews";
static NSString * const kReviewKey    = @"Review";
static NSString * const kTimeKey      = @"Time";
static NSString * const kRatingKey    = @"Rating";

#endif
