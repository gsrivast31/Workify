//
//  WFPhotoCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPhotoCell.h"
#import "WFMediaController.h"

@implementation WFPhotoCell

- (void)configureCellWithURL:(NSString*)fileName {
    self.imageView.layer.borderColor = [[UIColor turquoiseColor] CGColor];
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.clipsToBounds = YES;
    
    __weak typeof(self) weakSelf = self;
    [[WFMediaController sharedInstance] imageWithFilenameAsync:fileName success:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.imageView.image = image;
        });
    } failure:^{
    }];

}

@end
