//
//  WFPlacesTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPlacesTableViewCell.h"
#import "WFMediaController.h"

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface WFPlacesTableViewCell()

@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation WFPlacesTableViewCell

- (void)configureCellWithObject:(PFObject*)object {
    self.backgroundImageView.image = [UIImage imageNamed:@"banner1"];
    self.backgroundImageView.file = [object objectForKey:kWFCityDisplayPhotoKey];
    
    [self.backgroundImageView loadInBackground];
    
    self.nameLabel.font = [UIFont boldFlatFontOfSize:20];
    self.nameLabel.text = [object objectForKey:kWFCityNameKey];

    self.statusLabel.font = [UIFont flatFontOfSize:14];
    NSInteger locCount = [[object objectForKey:kWFCityLocationsCountKey] integerValue];
    if (locCount == 0) {
        self.statusLabel.text = @"( COMING SOON )";
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%ld places", (long)locCount];
    }
}

- (void)configureCellWithCity:(NSString *)city locationsCount:(NSInteger)count imageName:(NSString*)imageName {
    /*__weak typeof(self) weakSelf = self;
    [[WFMediaController sharedInstance] imageWithFilenameAsync:@"bkgnd1" success:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.backgroundImageView.image = image;
    } failure:^{
    }];*/
    self.backgroundImageView.image = [UIImage imageNamed:imageName];
    
    self.nameLabel.text = city;
    self.nameLabel.font = [UIFont boldFlatFontOfSize:20];

    if (count == 0) {
        self.statusLabel.text = @"( COMING SOON )";
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%ld places", (long)count];
    }
    self.statusLabel.font = [UIFont flatFontOfSize:14];
}

@end
