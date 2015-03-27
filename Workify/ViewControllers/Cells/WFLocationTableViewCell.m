//
//  WFLocationTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFLocationTableViewCell.h"
#import "WFMediaController.h"

@interface WFLocationTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
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

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCell {
    /*__weak typeof(self) weakSelf = self;
    [[WFMediaController sharedInstance] imageWithFilenameAsync:@"bkgnd2" success:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.backgroundImageView.image = image;
    } failure:^{
    }];*/
    self.backgroundImageView.image = [UIImage imageNamed:@"bkgnd2"];

    self.wifiDownloadLabel.text = @"4Mbps";
    self.wifiUploadLabel.text = @"2Mbps";
    
    [self.wifiDownloadLabel setFont:[UIFont flatFontOfSize:16]];
    [self.wifiUploadLabel setFont:[UIFont flatFontOfSize:16]];
    
    [self.wifiDownloadIconButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self.wifiUploadIconButton setImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
    
    [self.wifiDownloadIconButton setTintColor:[UIColor whiteColor]];
    [self.wifiUploadIconButton setTintColor:[UIColor whiteColor]];
    
    [self.ratingLabel setFont:[UIFont iconFontWithSize:17]];
    
    [self.spaceTypeLabel setFont:[UIFont flatFontOfSize:15]];
    self.spaceTypeLabel.text = kSpaceCoWorking;
    
    NSString* string = @"";
    for (NSInteger i=0; i<5; i++) {
        string = [string stringByAppendingString:[NSString iconStringForEnum:FUIStar2]];
    }
    [self.ratingLabel setText:string];
    [self.ratingLabel setTextColor:[UIColor turquoiseColor]];
    
    self.nameLabel.text = @"CAFE COFFEE DAY";
    self.addressLabel.text = @"Indiranagar, Colaba, Mumbai";
    
    self.nameLabel.font = [UIFont flatFontOfSize:18];
    self.addressLabel.font = [UIFont flatFontOfSize:16];
    
    
}

@end
