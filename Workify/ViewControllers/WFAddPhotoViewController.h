//
//  WFAddPhotoViewController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFAddPhotoDelegate <NSObject>

- (void) photosAdded:(NSArray*)photos;

@end

@interface WFAddPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, readwrite, nonatomic) id<WFAddPhotoDelegate> delegate;

@end
