//
//  WFPlacesTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 05/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPlacesTableViewCell.h"
#import "WFMediaController.h"

@interface WFPlacesTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation WFPlacesTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
