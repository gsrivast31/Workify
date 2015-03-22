//
//  WFLocationController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 04/03/2014.
//  Copyright (c) 2014 GAURAV SRIVASTAVA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^IMCurrentLocationSuccessCallback)(CLLocation*);
typedef void (^IMCurrentLocationFailureCallback)(NSError*);
typedef void (^IMGeolocateSuccessCallback)(NSArray*);
typedef void (^IMGeolocateFailureCallback)(NSError*);
typedef void (^IMReverseGeolocateSuccessCallback)(NSArray*);
typedef void (^IMReverseGeolocateFailureCallback)(NSError*);

@interface WFLocationController : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) CLGeocoder *geocoder;

+ (id)sharedInstance;

// Logic
- (void)fetchUserLocationWithSuccess:(IMCurrentLocationSuccessCallback)successCallback
                             failure:(IMCurrentLocationFailureCallback)failureCallback;
- (void)geocodeString:(NSString*)string
          withSuccess:(IMGeolocateSuccessCallback)successCallback
              failure:(IMGeolocateFailureCallback)failureCallback;
- (void)reverseGeocodeLocation:(CLLocation *)location
                   withSuccess:(IMReverseGeolocateSuccessCallback)successCallback
                       failure:(IMReverseGeolocateFailureCallback)failureCallback;

@end
