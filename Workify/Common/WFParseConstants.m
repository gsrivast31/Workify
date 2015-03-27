//
//  WFParseConstants.m
//  Workify
//
//  Created by Ranjeet on 3/27/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFParseConstants.h"

#pragma mark - PFObject City Class
// Class key
NSString *const kWFCityClassKey = @"City";

// Field keys
NSString *const kWFCityIDKey = @"cityId";
NSString *const kWFCityNameKey = @"name";
NSString *const kWFCityCanonicalNameKey = @"canonicalName";
NSString *const kWFCityLocationsKey = @"locations";
NSString *const kWFCityLocationsCountKey = @"locationCount";
NSString *const kWFCityDisplayPhotoKey = @"displayPhoto";

#pragma mark - PFObject Location Class
// Class key
NSString *const kWFLocationClassKey = @"Location";

// Field keys
NSString *const kWFLocationIDKey = @"locId";
NSString *const kWFLocationCityKey = @"city";
NSString *const kWFLocationNameKey = @"name";
NSString *const kWFLocationCanonicalNameKey = @"canonicalName";
NSString *const kWFLocationRatingsKey = @"ratings";
NSString *const kWFLocationDisplayPhotoKey = @"displayPhoto";
NSString *const kWFLocationAddressKey = @"address";
NSString *const kWFLocationLatitudeKey = @"lat";
NSString *const kWFLocationLongitudeKey = @"lang";
NSString *const kWFLocationEmailKey = @"email";
NSString *const kWFLocationPhoneKey = @"phone";
NSString *const kWFLocationWebsiteKey = @"website";
NSString *const kWFLocationFacebookKey = @"facebook";
NSString *const kWFLocationTwitterKey = @"twitter";
NSString *const kWFLocationTypeKey = @"type";
NSString *const kWFLocationAboutKey = @"about";
NSString *const kWFLocationWifiTypeKey = @"wifiType";
NSString *const kWFLocationWifiDownloadSpeedKey = @"wifiDwnldSpeed";
NSString *const kWFLocationWifiUploadSpeedKey = @"wifiUpldSpeed";
NSString *const kWFLocationPricingKey = @"pricing";
NSString *const kWFLocationPricingUnitKey = @"pricingUnit";
NSString *const kWFLocationPowerOptionsKey = @"power";
NSString *const kWFLocationFoodOptionsKey = @"food";
NSString *const kWFLocationNoiseOptionsKey = @"noise";
NSString *const kWFLocationSeatingOptionsKey = @"seating";
NSString *const kWFLocationAmenitiesKey = @"amenities";
NSString *const kWFLocationOpenDaysKey = @"openDays";
NSString *const kWFLocationReviewCountKey = @"reviewCnt";
NSString *const kWFLocationPhotoCountKey = @"photoCnt";
NSString *const kWFLocationPhotosKey = @"photos";

#pragma mark - PFObject User Class
// Field keys
NSString *const kWFUserDisplayNameKey = @"displayName";
NSString *const kWFUserFacebookIDKey = @"facebookId";
NSString *const kWFUserPhotoIDKey = @"photoId";
NSString *const kWFUserProfilePicSmallKey = @"profilePictureSmall";
NSString *const kWFUserProfilePicMediumKey = @"profilePictureMedium";
NSString *const kWFUserEmailKey = @"email";

#pragma mark - PFObject Photo Class
// Class key
NSString *const kWFPhotoClassKey = @"Photo";

// Field keys
NSString *const kWFPhotoPictureKey = @"image";
NSString *const kWFPhotoThumbnailKey = @"thumbnail";

#pragma mark - PFObject Review Class
// Class key
NSString *const kWFReviewClassKey = @"Review";

// Field keys
NSString *const kWFReviewContentKey = @"content";
NSString *const kWFReviewLocationKey = @"location";
NSString *const kWFReviewAuthorKey = @"author";
NSString *const kWFReviewDateKey = @"date";
NSString *const kWFReviewRatingsKey = @"ratings";
