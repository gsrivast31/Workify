//
//  WFParseConstants.h
//  Workify
//
//  Created by Ranjeet on 3/27/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#ifndef Workify_WFParseConstants_h
#define Workify_WFParseConstants_h

#pragma mark - PFObject City Class
// Class key
extern NSString *const kWFCityClassKey;

// Field keys
extern NSString *const kWFCityIDKey;
extern NSString *const kWFCityNameKey;
extern NSString *const kWFCityCanonicalNameKey;
extern NSString *const kWFCityLocationsKey;
extern NSString *const kWFCityLocationsCountKey;
extern NSString *const kWFCityDisplayPhotoKey;

#pragma mark - PFObject Location Class
// Class key
extern NSString *const kWFLocationClassKey;

// Field keys
extern NSString *const kWFLocationIDKey;
extern NSString *const kWFLocationCityKey;
extern NSString *const kWFLocationNameKey;
extern NSString *const kWFLocationCanonicalNameKey;
extern NSString *const kWFLocationRatingsKey;
extern NSString *const kWFLocationDisplayPhotoKey;
extern NSString *const kWFLocationAddressKey;
extern NSString *const kWFLocationLatitudeKey;
extern NSString *const kWFLocationLongitudeKey;
extern NSString *const kWFLocationEmailKey;
extern NSString *const kWFLocationPhoneKey;
extern NSString *const kWFLocationWebsiteKey;
extern NSString *const kWFLocationFacebookKey;
extern NSString *const kWFLocationTwitterKey;
extern NSString *const kWFLocationTypeKey;
extern NSString *const kWFLocationAboutKey;
extern NSString *const kWFLocationWifiTypeKey;
extern NSString *const kWFLocationWifiDownloadSpeedKey;
extern NSString *const kWFLocationWifiUploadSpeedKey;
extern NSString *const kWFLocationPricingKey;
extern NSString *const kWFLocationPricingUnitKey;
extern NSString *const kWFLocationPowerOptionsKey;
extern NSString *const kWFLocationFoodOptionsKey;
extern NSString *const kWFLocationNoiseOptionsKey;
extern NSString *const kWFLocationSeatingOptionsKey;
extern NSString *const kWFLocationAmenitiesKey;
extern NSString *const kWFLocationOpenDaysKey;
extern NSString *const kWFLocationReviewCountKey;
extern NSString *const kWFLocationPhotoCountKey;
extern NSString *const kWFLocationPhotosKey;

#pragma mark - PFObject User Class
// Field keys
extern NSString *const kWFUserDisplayNameKey;
extern NSString *const kWFUserFacebookIDKey;
extern NSString *const kWFUserPhotoIDKey;
extern NSString *const kWFUserProfilePicSmallKey;
extern NSString *const kWFUserProfilePicMediumKey;
extern NSString *const kWFUserEmailKey;

#pragma mark - PFObject Photo Class
// Class key
extern NSString *const kWFPhotoClassKey;

// Field keys
extern NSString *const kWFPhotoPictureKey;
extern NSString *const kWFPhotoThumbnailKey;
extern NSString *const kWFPhotoLocationKey;

#pragma mark - PFObject Review Class
// Class key
extern NSString *const kWFReviewClassKey;

// Field keys
extern NSString *const kWFReviewContentKey;
extern NSString *const kWFReviewAuthorKey;
extern NSString *const kWFReviewLocationKey;
extern NSString *const kWFReviewDateKey;
extern NSString *const kWFReviewRatingsKey;

#endif
