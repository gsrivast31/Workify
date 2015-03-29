//
//  WFLocationTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationTableViewCell.h"
#import "WFMediaController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface WFLocationTableViewCell()

@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *wifiDownloadIconButton;
@property (weak, nonatomic) IBOutlet UILabel *wifiDownloadLabel;
@property (weak, nonatomic) IBOutlet UIButton *wifiUploadIconButton;
@property (weak, nonatomic) IBOutlet UILabel *wifiUploadLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceTypeLabel;

@end

@implementation WFLocationTableViewCell

- (void)configureCellForObject:(PFObject *)object {
    self.backgroundImageView.image = [UIImage imageNamed:@"banner2"];
    
    PFFile* file = [object objectForKey:kWFLocationDisplayPhotoKey];
    if (file) {
        self.backgroundImageView.file = file;
        [self.backgroundImageView loadInBackground];
    }
    
    NSNumber* wifiDownloadSpeedNum = [object objectForKey:kWFLocationWifiDownloadSpeedKey] ;
    
    if (wifiDownloadSpeedNum) {
        double wifiDownloadSpeed = [wifiDownloadSpeedNum doubleValue];
        self.wifiDownloadLabel.text = [NSString stringWithFormat:@"%.1f Mbps", wifiDownloadSpeed];
    } else {
        self.wifiDownloadLabel.text = @"-";

    }
    
    NSNumber* wifiUploadSpeedNum = [object objectForKey:kWFLocationWifiUploadSpeedKey] ;
    if (wifiUploadSpeedNum) {
        double wifiUploadSpeed = [wifiUploadSpeedNum doubleValue];
        self.wifiUploadLabel.text = [NSString stringWithFormat:@"%.1f Mbps", wifiUploadSpeed];
    } else {
        self.wifiUploadLabel.text = @"-";
    }
    
    [self.wifiDownloadLabel setFont:[UIFont flatFontOfSize:16]];
    [self.wifiUploadLabel setFont:[UIFont flatFontOfSize:16]];
    
    [self.wifiDownloadIconButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self.wifiUploadIconButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    
    [self.wifiDownloadIconButton setTintColor:[UIColor whiteColor]];
    [self.wifiUploadIconButton setTintColor:[UIColor whiteColor]];
    
    [self.ratingLabel setFont:[UIFont iconFontWithSize:17]];
    
    [self.spaceTypeLabel setFont:[UIFont flatFontOfSize:15]];
    
    self.spaceTypeLabel.text = [WFStringStore spaceTypeString:[[object objectForKey:kWFLocationTypeKey] integerValue]];
    
    NSString* string = @"";
    for (NSInteger i=0; i<[[object objectForKey:kWFLocationRatingsKey] integerValue]; i++) {
        string = [string stringByAppendingString:[NSString iconStringForEnum:FUIStar2]];
    }
    [self.ratingLabel setText:string];
    [self.ratingLabel setTextColor:[UIColor turquoiseColor]];
    
    self.nameLabel.text = [object objectForKey:kWFLocationNameKey];
    
    NSDictionary* addressDict = [object objectForKey:kWFLocationAddressKey];
    self.addressLabel.text = [WFHelper commaSeparatedString:@[[addressDict objectForKey:kAddressStreet], [addressDict objectForKey:kAddressSubStreet], [addressDict objectForKey:kAddressSubCity]]];
    
    self.nameLabel.font = [UIFont flatFontOfSize:18];
    self.addressLabel.font = [UIFont flatFontOfSize:16];
    
    
}

@end
