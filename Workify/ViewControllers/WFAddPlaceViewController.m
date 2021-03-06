//
//  WFAddPlaceViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddPlaceViewController.h"
#import "RETableViewManager.h"
#import "WFHourViewCell.h"
#import "WFInputItem.h"
#import "WFOptionItem.h"
#import "WFOptionViewCell.h"
#import "WFButtonItem.h"
#import "WFSubTitleItem.h"
#import "WFAddURLViewController.h"
#import "WFAddPhotoViewController.h"
#import "WFLocationSearchViewController.h"
#import "WFMediaController.h"
#import "MWPhotoBrowser.h"

#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>
#import <MBProgressHUD.h>
#import "UIImage+ResizeAdditions.h"

#define INCLUDE_ALL_FIELDS 0

@interface WFAddPlaceViewController () <RETableViewManagerDelegate, WFAddAddressDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, WFAddURLDelegate, MWPhotoBrowserDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readwrite, strong) RETableViewManager* manager;

@property (strong, readwrite, nonatomic) RETextItem *nameItem;
@property (strong, readwrite, nonatomic) RETextItem *emailItem;
@property (strong, readwrite, nonatomic) RETextItem *phoneItem;

@property (strong, readwrite, nonatomic) WFSubTitleItem *addressItem;

@property (strong, readwrite, nonatomic) RETextItem *websiteItem;
@property (strong, readwrite, nonatomic) RETextItem *facebookItem;
@property (strong, readwrite, nonatomic) RETextItem *twitterItem;

@property (strong, readwrite, nonatomic) RESegmentedItem* locationTypeItem;
@property (strong, readwrite, nonatomic) RELongTextItem *notesItem;

#if INCLUDE_ALL_FIELDS

@property (strong, readwrite, nonatomic) RELongTextItem *descItem;

@property (strong, readwrite, nonatomic) RESegmentedItem *wifiItem;
@property (strong, readwrite, nonatomic) RENumberItem *wifiDownloadItem;
@property (strong, readwrite, nonatomic) RESegmentedItem *wifiSpeedUnitItem;
@property (strong, readwrite, nonatomic) RENumberItem *wifiUploadItem;

@property (strong, readwrite, nonatomic) RESegmentedItem *priceUnitItem;
@property (strong, readwrite, nonatomic) RENumberItem *dayPriceItem;
@property (strong, readwrite, nonatomic) RENumberItem *weeklyPriceItem;
@property (strong, readwrite, nonatomic) RENumberItem *monthlyPriceItem;

/*@property (strong, readwrite, nonatomic) WFInputItem *wifiDownloadItem;
@property (strong, readwrite, nonatomic) WFInputItem *wifiUploadItem;

@property (strong, readwrite, nonatomic) WFInputItem *dayPriceItem;
@property (strong, readwrite, nonatomic) WFInputItem *weeklyPriceItem;
@property (strong, readwrite, nonatomic) WFInputItem *monthlyPriceItem;*/

@property (strong, readwrite, nonatomic) RESegmentedItem *noiseItem;

@property (strong, readwrite, nonatomic) WFOptionItem* openDaysItem;

@property (strong, readwrite, nonatomic) WFOptionItem* foodItem;
@property (strong, readwrite, nonatomic) WFOptionItem* powerItem;
@property (strong, readwrite, nonatomic) WFOptionItem* seatingItem;
@property (strong, readwrite, nonatomic) WFOptionItem* amenitiesItem;

@property (strong, readwrite, nonatomic) RETableViewItem *photosCountItem;

@property (strong, readwrite, nonatomic) NSMutableArray *photosArray;
@property (strong, readwrite, nonatomic) NSMutableArray *photoUrlsArray;
@property (strong, readwrite, nonatomic) NSMutableArray *allPhotosArray;

#endif

@end

@implementation WFAddPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Suggest a place";
    
#if INCLUDE_ALL_FIELDS
    self.photosArray = [[NSMutableArray alloc] init];
    self.photoUrlsArray = [[NSMutableArray alloc] init];
    self.allPhotosArray = [[NSMutableArray alloc] init];
#endif
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFInputItem"] = @"WFInputViewCell";
    self.manager[@"WFOptionItem"] = @"WFOptionViewCell";
    self.manager[@"WFButtonItem"] = @"WFButtonCell";
    self.manager[@"WFSubTitleItem"] = @"WFSubTitleCell";
    [self addTableEntries];
    
    self.saveButton.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.saveButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
#if INCLUDE_ALL_FIELDS
    [self.saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
#else
    [self.saveButton addTarget:self action:@selector(saveUnreviewed:) forControlEvents:UIControlEventTouchUpInside];
#endif
    
    if(!self.navigationItem.leftBarButtonItem) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [backButton setImage:[[UIImage imageNamed:@"NavBarIconBack.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [backButton setTitle:self.navigationItem.backBarButtonItem.title forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dismissSelf:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10.0f, 0, 0)];
        [backButton setAdjustsImageWhenHighlighted:NO];
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#if INCLUDE_ALL_FIELDS
- (void)save:(id)sender {
    NSArray* managerErrors = self.manager.errors;
    BOOL bInValid = [WFHelper isEmpty:self.websiteItem.value] && [WFHelper isEmpty:self.facebookItem.value] && [WFHelper isEmpty:self.twitterItem.value] && !self.addressItem.value;
    if (managerErrors.count > 0 || bInValid) {
        NSMutableArray *errors = [NSMutableArray array];
        for (NSError *error in managerErrors) {
            [errors addObject:error.localizedDescription];
        }
        
        if (bInValid) {
            [errors addObject:@"Either of them must not be empty:Website, Facebook, Twitter, Address."];
        }
        NSString *errorString = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PFObject* locationObj = [PFObject objectWithClassName:kWFLocationClassKey];
    if (self.nameItem.value) {
        locationObj[kWFLocationNameKey] = self.nameItem.value;
        locationObj[kWFLocationCanonicalNameKey] = [[self.nameItem.value lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if (self.emailItem.value) locationObj[kWFLocationEmailKey] = self.emailItem.value;
    if (self.phoneItem.value) locationObj[kWFLocationPhoneKey] = self.phoneItem.value;
    locationObj[kWFLocationTypeKey] = [NSNumber numberWithInteger:self.locationTypeItem.value];
    
    NSString* city = nil;
    if (self.addressItem.value) {
        locationObj[kWFLocationAddressKey] = self.addressItem.value;
        city = [self.addressItem.value objectForKey:kAddressCity];
    }

    if (self.websiteItem.value) locationObj[kWFLocationWebsiteKey] = self.websiteItem.value;
    if (self.facebookItem.value) locationObj[kWFLocationFacebookKey] = self.facebookItem.value;
    if (self.twitterItem.value) locationObj[kWFLocationTwitterKey] = self.twitterItem.value;
    
    if (self.descItem.value) locationObj[kWFLocationAboutKey] = self.descItem.value;
    locationObj[kWFLocationWifiTypeKey] = [NSNumber numberWithInteger:self.wifiItem.value] ;

    if (self.wifiDownloadItem.value) locationObj[kWFLocationWifiDownloadSpeedKey] = [WFHelper wifiSpeedInMbps:self.wifiDownloadItem.value fromUnit:self.wifiItem.value];
    if (self.wifiUploadItem.value) locationObj[kWFLocationWifiUploadSpeedKey] = [WFHelper wifiSpeedInMbps:self.wifiUploadItem.value fromUnit:self.wifiItem.value];
    
    if (self.dayPriceItem.value && self.weeklyPriceItem.value && self.monthlyPriceItem.value) {
        locationObj[kWFLocationPricingKey] = @{kPriceDayPassKey : self.dayPriceItem.value,
                                               kPriceWeekPassKey : self.weeklyPriceItem.value,
                                               kPriceMonthPassKey : self.monthlyPriceItem.value};
    }
    
    locationObj[kWFLocationPricingUnitKey] = [NSNumber numberWithInteger:self.priceUnitItem.value];
    
    locationObj[kWFLocationNoiseOptionsKey] = [NSNumber numberWithInteger:self.noiseItem.value];

    if ([self.openDaysItem.value count]) locationObj[kWFLocationOpenDaysKey] = self.openDaysItem.value;
    if ([self.foodItem.value count]) locationObj[kWFLocationFoodOptionsKey] = self.foodItem.value;
    if ([self.powerItem.value count]) locationObj[kWFLocationPowerOptionsKey] = self.powerItem.value;
    
    if ([self.seatingItem.value count]) locationObj[kWFLocationSeatingOptionsKey] = self.seatingItem.value;
    if ([self.amenitiesItem.value count]) locationObj[kWFLocationAmenitiesKey] = self.amenitiesItem.value;
    
    locationObj[kWFLocationRatingsKey] = [NSNumber numberWithInteger:0];
    locationObj[kWFLocationReviewCountKey] = [NSNumber numberWithInteger:0];
    
    PFRelation* locImages = [locationObj relationForKey:kWFLocationPhotosKey];

    __typeof (&*self) __weak weakSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /*[locationObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        for (NSString* imageName in self.photosArray) {
            [[WFMediaController sharedInstance] imageWithFilenameAsync:imageName success:^(UIImage *image) {
                [weakSelf shouldUploadImage:image withCallback:^(PFObject *photoObj, NSError* error) {
                    if (photoObj) {
                        [locImages addObject:photoObj];
                    } else if (error) {
                        NSLog(@"Error:%@", error.localizedDescription);
                    }
                }];
            } failure:^{
            }];
        }
        

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeeded) {
            NSLog(@"Saved successfully : %@", locationObj.objectId);
        } else {
            NSLog(@"Error:%@", error.localizedDescription);
        }
    }];*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSMutableArray* photoObjArray = [NSMutableArray array];
        for (UIImage* anImage in strongSelf.photosArray) {
            UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1024.0f, 1024.0f) interpolationQuality:kCGInterpolationHigh];
            UIImage *thumbnailImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(56.0f, 56.0f) interpolationQuality:kCGInterpolationHigh];
            
            NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
            NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
            
            if (imageData && thumbnailImageData) {
                PFFile* photoFile = [PFFile fileWithData:imageData];
                NSError* error1 = nil;
                BOOL bPhotoSaved = [photoFile save:&error1];
                if (bPhotoSaved) {
                    NSError* error2 = nil;
                    PFFile* thumbnailFile = [PFFile fileWithData:thumbnailImageData];
                    BOOL bThumbSaved = [thumbnailFile save:&error2];
                    if (bThumbSaved) {
                        PFObject* object = [PFObject objectWithClassName:kWFPhotoClassKey];
                        object[kWFPhotoPictureKey] = photoFile;
                        object[kWFPhotoThumbnailKey] = thumbnailFile;
                        [photoObjArray addObject:object];
                    } else {
                        NSLog(@"Error:%@", error2.localizedDescription);
                    }
                } else {
                    NSLog(@"Error:%@", error1.localizedDescription);
                }
            }
        }
        
        if (photoObjArray == nil) {
            [self placeAdded:NO error:nil];
        }
        
        [PFObject saveAllInBackground:photoObjArray block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                for (PFObject* obj in photoObjArray) {
                    [locImages addObject:obj];
                }
                
                //Save the display image
                locationObj[kWFLocationDisplayPhotoKey] = [[photoObjArray objectAtIndex:0] objectForKey:kWFPhotoPictureKey];
                locationObj[kWFLocationPhotoCountKey] = [NSNumber numberWithInteger:photoObjArray.count];

                [locationObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Saved Successfully:%@", locationObj.objectId);
                        
                        if (city) {
                            PFQuery* query = [PFQuery queryWithClassName:kWFCityClassKey];
                            [query whereKey:kWFCityCanonicalNameKey equalTo:[[city lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                if (error == nil) {
                                    if (object != nil) {
                                        [object incrementKey:kWFCityLocationsCountKey];
                                        PFRelation* relation = [object relationForKey:kWFCityLocationsKey];
                                        [relation addObject:locationObj];
                                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                                [strongSelf placeAdded:YES error:error];
                                            });
                                        }];
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                            [strongSelf placeAdded:YES error:error];
                                        });
                                    }
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                        [strongSelf placeAdded:NO error:error];
                                    });
                                }
                            }];
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                [strongSelf placeAdded:YES error:error];
                            });
                        }
                    } else {
                        NSLog(@"Error:%@", error.localizedDescription);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                            [strongSelf placeAdded:NO error:error];
                        });
                    }
                }];
            } else {
                NSLog(@"Error:%@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                    [strongSelf placeAdded:NO error:error];
                });
            }
        }];
    });
}
#endif

- (void)saveUnreviewed:(id)sender {
    NSArray* managerErrors = self.manager.errors;
    BOOL bInValid = [WFHelper isEmpty:self.websiteItem.value] && [WFHelper isEmpty:self.facebookItem.value] && [WFHelper isEmpty:self.twitterItem.value] && !self.addressItem.value;
    if (managerErrors.count > 0 || bInValid) {
        NSMutableArray *errors = [NSMutableArray array];
        for (NSError *error in managerErrors) {
            [errors addObject:error.localizedDescription];
        }
        
        if (bInValid) {
            [errors addObject:@"Either of them must not be empty:Website, Facebook, Twitter, Address."];
        }
        NSString *errorString = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PFObject* locationObj = [PFObject objectWithClassName:kWFLocationSuggestionClassKey];
    if (self.nameItem.value) {
        locationObj[kWFLocationNameKey] = self.nameItem.value;
    }
    
    if (self.emailItem.value) locationObj[kWFLocationEmailKey] = self.emailItem.value;
    if (self.phoneItem.value) locationObj[kWFLocationPhoneKey] = self.phoneItem.value;
    locationObj[kWFLocationTypeKey] = [NSNumber numberWithInteger:self.locationTypeItem.value];
    
    if (self.websiteItem.value) locationObj[kWFLocationWebsiteKey] = self.websiteItem.value;
    if (self.facebookItem.value) locationObj[kWFLocationFacebookKey] = self.facebookItem.value;
    if (self.twitterItem.value) locationObj[kWFLocationTwitterKey] = self.twitterItem.value;
    
    if (self.notesItem.value) locationObj[kWFLocationNotesKey] = self.notesItem.value;
    
    locationObj[kWFLocationUserKey] = [PFUser currentUser];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [locationObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf placeAdded:YES error:error];
            });
        } else if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf placeAdded:NO error:error];
            });
        }
    }];
}

- (void)shouldUploadImage:(UIImage*)anImage withCallback:(photoUploadHandler)callback {
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(560.0f, 560.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:86.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    NSData *thumbnailImageData = UIImagePNGRepresentation(thumbnailImage);
    
    if (!imageData || !thumbnailImageData) {
        callback(nil, nil);
    }
    
    PFFile* photoFile = [PFFile fileWithData:imageData];
    PFFile* thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Photo uploaded successfully");
            [thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Thumbnail uploaded successfully");
                    PFObject* object = [PFObject objectWithClassName:kWFPhotoClassKey];
                    object[kWFPhotoPictureKey] = photoFile;
                    object[kWFPhotoThumbnailKey] = thumbnailFile;
                    
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            callback(object, error);
                        } else {
                            callback(nil, error);
                        }
                    }];
                } else {
                    callback (nil, error);
                }
            }];
        } else {
            callback(nil, error);
        }
    }];
}

- (void)dismissSelf:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableEntries {
    [self addGeneralSection];
    [self addAddressSection];
    [self addSocialWebSection];
    [self addLocationTypeSection];
    
#if INCLUDE_ALL_FIELDS
    [self addDescriptionSection];
    [self addWifiSection];
    [self addPricingSection];
    [self addNoiseSection];
    [self addDaysSection];
    [self addFoodSection];
    [self addPowerSection];
    [self addSeatingSection];
    [self addAmenitiesSection];
    [self addPhotosButton];
#endif
    [self addNotesSection];
}

- (void)addGeneralSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"General Info"];
    [self.manager addSection:section];
    
    self.nameItem = [RETextItem itemWithTitle:@"Name" value:nil placeholder:@"E.g. Gaurav Srivastava"];
    self.nameItem.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nameItem.validators = @[@"presence"];
    self.emailItem = [RETextItem itemWithTitle:@"Email" value:nil placeholder:@"abc@xyz.com"];
    self.emailItem.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailItem.validators = @[@"email"];
    self.phoneItem = [RENumberItem itemWithTitle:@"Phone" value:nil placeholder:@"91-1234567890"];
    
    [section addItem:self.nameItem];
    [section addItem:self.emailItem];
    [section addItem:self.phoneItem];
}

- (void)addLocationTypeSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Location Type"];
    [self.manager addSection:section];

    self.locationTypeItem = [RESegmentedItem itemWithTitle:nil segmentedControlTitles:[WFStringStore spaceTypeStrings] value:-1];
    self.locationTypeItem.tintColor = [UIColor turquoiseColor];
    self.locationTypeItem.validators = @[@"presence"];
    [section addItem:self.locationTypeItem];
}

- (void)addAddressSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Address"];
    [self.manager addSection:section];

    __typeof (&*self) __weak weakSelf = self;
    self.addressItem = [WFSubTitleItem itemWithTitle:@"No address added" subTitle:@"Tap to find it" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        WFLocationSearchViewController* vc = [[WFLocationSearchViewController alloc] init];
        vc.delegate = self;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.addressItem.selectionStyle = UITableViewCellSelectionStyleNone;
    [section addItem:self.addressItem];
}

- (void)addSocialWebSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Web/Social"];
    [self.manager addSection:section];

    self.websiteItem = [RETextItem itemWithTitle:@"Website" value:nil placeholder:@"Website of space"];
    self.facebookItem = [RETextItem itemWithTitle:@"Facebook" value:nil placeholder:@"Facebook page URL"];
    self.twitterItem = [RETextItem itemWithTitle:@"Twitter" value:nil placeholder:@"Twitter page URL"];

    [section addItem:self.websiteItem];
    [section addItem:self.facebookItem];
    [section addItem:self.twitterItem];
}

#if INCLUDE_ALL_FIELDS
- (void)addDescriptionSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Description"];
    [self.manager addSection:section];

    self.descItem = [RELongTextItem itemWithValue:nil placeholder:@"A short description"];
    self.descItem.cellHeight = 88.0f;
    [section addItem:self.descItem];
}

- (void)addDaysSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Open Days"];
    [self.manager addSection:section];

    self.openDaysItem = [WFOptionItem itemWithOptions:[WFStringStore daysStrings]];
    [section addItem:self.openDaysItem];

//    self.hourItem = [WFDayItem item];
//    [section addItem:self.hourItem];
}

- (void)addWifiSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Wifi"];
    [self.manager addSection:section];
    
    self.wifiItem = [RESegmentedItem itemWithTitle:@"" segmentedControlTitles:[WFStringStore wifiStrings] value:WFWifiDontKnow switchValueChangeHandler:^(RESegmentedItem *item) {
        
    }];
    self.wifiItem.tintColor = [UIColor turquoiseColor];
    [section addItem:self.wifiItem];
    
    self.wifiDownloadItem = [RENumberItem itemWithTitle:@"Download Speed" value:nil placeholder:@"4"];
    [section addItem:self.wifiDownloadItem];

    self.wifiUploadItem = [RENumberItem itemWithTitle:@"Upload Speed" value:nil placeholder:@"2"];
    [section addItem:self.wifiUploadItem];

    self.wifiSpeedUnitItem = [RESegmentedItem itemWithTitle:@"Speed Unit" segmentedControlTitles:[WFStringStore wifiUnitStrings] value:WFWifiSpeedMbps];
    [section addItem:self.wifiSpeedUnitItem];

    /*self.wifiDownloadItem = [WFInputItem itemWithTitle:@"Download Speed" value:@"4" categories:@[@"Gbps", @"Mbps", @"Kbps"] selectedIndex:[NSNumber numberWithInteger:2]];
    [section addItem:self.wifiDownloadItem];
    
    self.wifiUploadItem = [WFInputItem itemWithTitle:@"Upload Speed" value:@"4" categories:@[@"Gbps", @"Mbps", @"Kbps"] selectedIndex:[NSNumber numberWithInteger:2]];
    [section addItem:self.wifiUploadItem];*/
}

- (void)addPricingSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Pricing"];
    [self.manager addSection:section];
    
    self.priceUnitItem = [RESegmentedItem itemWithTitle:@"Price Unit" segmentedControlTitles:[WFStringStore priceUnitStrings] value:WFPriceINR];
    [section addItem:self.priceUnitItem];
    
    self.dayPriceItem = [RENumberItem itemWithTitle:@"Day Pass" value:nil placeholder:@"0"];
    self.weeklyPriceItem = [RENumberItem itemWithTitle:@"Weekly Pass" value:nil placeholder:@"0"];
    self.monthlyPriceItem = [RENumberItem itemWithTitle:@"Monthly Pass" value:nil placeholder:@"0"];
    
    [section addItem:self.dayPriceItem];
    [section addItem:self.weeklyPriceItem];
    [section addItem:self.monthlyPriceItem];
    
    /*self.dayPriceItem = [WFInputItem itemWithTitle:@"Day Pass" value:@"100" categories:@[@"INR", @"Dollars", @"Pounds", @"Euros"  ] selectedIndex:[NSNumber numberWithInteger:0]];
    [section addItem:self.dayPriceItem];
    
    self.weeklyPriceItem = [WFInputItem itemWithTitle:@"Weekly Pass(if any)" value:@"100" categories:@[@"INR", @"Dollars", @"Pounds", @"Euros"] selectedIndex:[NSNumber numberWithInteger:0]];
    [section addItem:self.weeklyPriceItem];
    
    self.monthlyPriceItem = [WFInputItem itemWithTitle:@"Monthly Pass(if any)" value:@"100" categories:@[@"INR", @"Dollars", @"Pounds", @"Euros"] selectedIndex:[NSNumber numberWithInteger:0]];
    [section addItem:self.monthlyPriceItem];*/
}

- (void)addFoodSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Food Options"];
    [self.manager addSection:section];
    
    self.foodItem = [WFOptionItem itemWithOptions:[WFStringStore foodStrings]];
    [section addItem:self.foodItem];
}

- (void)addPowerSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Power Options"];
    [self.manager addSection:section];

    self.powerItem = [WFOptionItem itemWithOptions:[WFStringStore powerStrings]];
    [section addItem:self.powerItem];
}

- (void)addSeatingSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Seating Options"];
    [self.manager addSection:section];

    self.seatingItem = [WFOptionItem itemWithOptions:[WFStringStore seatingStrings]];
    [section addItem:self.seatingItem];
}

- (RETableViewSection*)addNoiseSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Noise level"];
    [self.manager addSection:section];
    
    self.noiseItem = [RESegmentedItem itemWithTitle:nil segmentedControlTitles:[WFStringStore noiseStrings] value:0 switchValueChangeHandler:^(RESegmentedItem *item) {
    }];
    self.noiseItem.tintColor = [UIColor turquoiseColor];
    [section addItem:self.noiseItem];
    return section;
}

- (void)addAmenitiesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Amenities"];
    [self.manager addSection:section];
    
    self.amenitiesItem = [WFOptionItem itemWithOptions:[WFStringStore amenitiesStrings]];
    [section addItem:self.amenitiesItem];
}

- (void)addPhotosButton {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Gallery"];
    [self.manager addSection:section];
    
    __typeof (&*self) __weak weakSelf = self;
    
    NSString* countText;
    if (self.photosArray.count) {
        countText = [NSString stringWithFormat:@"Total Photos : %ld", (unsigned long)[self.photosArray count]];
    } else {
        countText = @"No photos added";
    }
    
    self.photosCountItem = [RETableViewItem itemWithTitle:countText];
    self.photosCountItem.selectionStyle = UITableViewCellSelectionStyleNone;
    self.photosCountItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:self.photosCountItem];

    [section addItem:[WFButtonItem itemWithTitle:@"Add Photos" tapHandler:^(RETableViewItem *item) {
        [weakSelf addPhotos];
    }]];
    
    [section addItem:[WFButtonItem itemWithTitle:@"View Photos" tapHandler:^(RETableViewItem *item) {
        [weakSelf viewPhotos];
    }]];
}
#endif

- (void)addNotesSection {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@"Notes"];
    [self.manager addSection:section];
    
    self.notesItem = [RELongTextItem itemWithValue:nil placeholder:@"Any other information?"];
    self.notesItem.cellHeight = 120.0f;
    [section addItem:self.notesItem];
}

#if INCLUDE_ALL_FIELDS
- (void)addPhotos {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", @"URL", nil];
    
    [actionSheet showInView:self.view];
}

- (void)viewPhotos {
    
    for (NSInteger i=0; i<_photosArray.count; i++) {
        MWPhoto* photo = [MWPhoto photoWithImage:[_photosArray objectAtIndex:i]];
        [_allPhotosArray addObject:photo];
    }
    
    for (NSInteger i=0; i<_photoUrlsArray.count; i++) {
        MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:[_photoUrlsArray objectAtIndex:i]]];
        [_allPhotosArray addObject:photo];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = YES;
    browser.startOnGrid = YES;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:nc animated:YES completion:nil];
}
#endif

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.addressItem.indexPath]) {
        return YES;
    }
    return NO;
}

#if INCLUDE_ALL_FIELDS

#pragma mark Helpers
- (void)updatePhotoCount {
    RETableViewCell* cell = (RETableViewCell*)[self.tableView cellForRowAtIndexPath:self.photosCountItem.indexPath];
    NSString* countText;
    NSInteger count = [self.photosArray count] + [self.photoUrlsArray count];
    if (count) {
        countText = [NSString stringWithFormat:@"Total Photos : %ld", (long)count];
    } else {
        countText = @"No photos added";
    }
    self.photosCountItem.title = countText;
    [cell.textLabel setText:countText];
}

#endif

#pragma mark WFAddAddressDelegate

- (void)addressAdded:(NSDictionary *)addressDictionary {
    NSString* addrString  = [@[[addressDictionary objectForKey:kAddressStreet],
                               [addressDictionary objectForKey:kAddressSubStreet],
                               [addressDictionary objectForKey:kAddressCity],
                               [addressDictionary objectForKey:kAddressSubCity],
                               [addressDictionary objectForKey:kAddressState],
                               [addressDictionary objectForKey:kAddressSubState],
                               [addressDictionary objectForKey:kAddressZIP],
                               [addressDictionary objectForKey:kAddressCountry]] componentsJoinedByString:@", "];

    self.addressItem.title = addrString;
    self.addressItem.detailLabelText = @"Tap to change";
    self.addressItem.value = addressDictionary;
    
    [self.tableView reloadRowsAtIndexPaths:@[self.addressItem.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark RETableViewManagerDelegate

- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WFOptionViewCell class]]) {
        if ([cell respondsToSelector:@selector(setItemCount:)]) {
            WFOptionItem *item = (WFOptionItem*)[[[self.manager.sections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
            [(WFOptionViewCell*)cell setItemCount:[[item options] count]];
        }
    }
}

#if INCLUDE_ALL_FIELDS

#pragma mark UIImagePickerControllerDelegate

- (void)promptForCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera is not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForURL {
    WFAddURLViewController* vc = [[WFAddURLViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (info[UIImagePickerControllerEditedImage]) {
        [self.photosArray addObject:info[UIImagePickerControllerEditedImage]];
    } else {
        [self.photosArray addObject:info[UIImagePickerControllerOriginalImage]];
    }
    [self updatePhotoCount];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else if(buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
            [self promptForPhotoRoll];
        } else {
            [self promptForURL];
        }
    }
}

#pragma mark WFAddURLDelegate

- (void)urlsAdded:(NSArray *)urlArray {
    if (urlArray && [urlArray count]) {
        [self.photoUrlsArray addObjectsFromArray:urlArray];
        [self updatePhotoCount];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)noUrlAdded {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _allPhotosArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _allPhotosArray.count) {
        return [_allPhotosArray objectAtIndex:index];
    }
    
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _allPhotosArray.count) {
        return [_allPhotosArray objectAtIndex:index];
    }
    
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [_allPhotosArray removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#endif

#pragma mark Helper

- (void)placeAdded:(BOOL)success error:(NSError*)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeAdded:error:)]) {
        [self.delegate placeAdded:success error:error];
    }
}

@end
