//
//  WFAddPlaceViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

@class PFObject;

typedef void(^photoUploadHandler)(PFObject* photoObj, NSError* error);

@protocol WFAddPlaceDelegate <NSObject>

- (void)placeAdded:(BOOL)success error:(NSError*)error;

@end

@interface WFAddPlaceViewController : UIViewController

@property (nonatomic, strong) id<WFAddPlaceDelegate> delegate;

@end
