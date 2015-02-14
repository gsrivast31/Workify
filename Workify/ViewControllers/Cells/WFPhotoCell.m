//
//  WFPhotoCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPhotoCell.h"

@implementation WFPhotoCell

- (void)configureCellWithURL:(NSString*)urlString {
    self.imageView.image = [UIImage imageNamed:@"bkgnd1"];
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.clipsToBounds = YES;
}

@end
