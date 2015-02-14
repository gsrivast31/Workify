//
//  WFLocationController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 04/03/2014.
//  Copyright (c) 2014 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationController.h"

@interface WFLocationController ()
{
    BOOL isFetchingUserLocation;
    
    NSTimer *locationFetchTimer;
    CLLocation *lastLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IMCurrentLocationSuccessCallback currentLocationSuccessCallback;
@property (nonatomic, strong) IMCurrentLocationFailureCallback currentLocationFailureCallback;

- (void)locationFetchTimerTick;

@end

@implementation WFLocationController

@synthesize locationManager = _locationManager;
@synthesize geocoder = _geocoder;
@synthesize currentLocationSuccessCallback = _currentLocationSuccessCallback;
@synthesize currentLocationFailureCallback = _currentLocationFailureCallback;

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Setup
- (id)init {
    self = [super init];
    if(self) {
        lastLocation = nil;
        locationFetchTimer = nil;
        isFetchingUserLocation = NO;
    }
    return self;
}

#pragma mark - Logic

- (void)fetchUserLocationWithSuccess:(IMCurrentLocationSuccessCallback)successCallback failure:(IMCurrentLocationFailureCallback)failureCallback {
    isFetchingUserLocation = YES;
    lastLocation = nil;
    
    if(locationFetchTimer) {
        [locationFetchTimer invalidate], locationFetchTimer = nil;
    }
    
    locationFetchTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(locationFetchTimerTick) userInfo:nil repeats:NO];
    
    self.currentLocationSuccessCallback = successCallback;
    self.currentLocationFailureCallback = failureCallback;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)reverseGeocodeLocation:(CLLocation *)location
                   withSuccess:(IMReverseGeolocateSuccessCallback)successCallback
                       failure:(IMReverseGeolocateFailureCallback)failureCallback {
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(!error) {
            successCallback(placemarks);
        } else {
            failureCallback(error);
        }
    }];
}

- (void)locationFetchTimerTick
{
    if(isFetchingUserLocation) {
        isFetchingUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
        
        if(lastLocation) {
            self.currentLocationSuccessCallback(lastLocation);
        } else {
            NSMutableDictionary *errorInfo = [NSMutableDictionary dictionary];
            [errorInfo setValue:NSLocalizedString(@"Unable to determine location", @"Error message shown when a users current geographic location cannot be determined") forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:kErrorDomain code:0 userInfo:errorInfo];
            
            self.currentLocationFailureCallback(error);
        }
        self.currentLocationSuccessCallback = nil;
        self.currentLocationFailureCallback = nil;
    }
}

#pragma mark - CLLocationsManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
    
    // Make sure this location data isn't cached
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    // Test that horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    if (lastLocation == nil || lastLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
        lastLocation = newLocation;
        
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            [self.locationManager stopUpdatingLocation];
            
            if(isFetchingUserLocation) {
                isFetchingUserLocation = NO;
                
                [locationFetchTimer invalidate], locationFetchTimer = nil;
                
                self.currentLocationSuccessCallback(newLocation);
                self.currentLocationSuccessCallback = nil;
                self.currentLocationFailureCallback = nil;
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    
    if(isFetchingUserLocation) {
        isFetchingUserLocation = NO;
        
        self.currentLocationFailureCallback(error);
        self.currentLocationFailureCallback = nil;
    }
}

#pragma mark - Accessors
- (CLLocationManager *)locationManager {
    if(!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    
    return _locationManager;
}

- (CLGeocoder *)geocoder {
    if(!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

@end
