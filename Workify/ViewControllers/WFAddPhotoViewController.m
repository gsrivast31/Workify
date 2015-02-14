//
//  WFAddPhotoViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddPhotoViewController.h"

@interface WFAddPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation WFAddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

@end
