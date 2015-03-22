//
//  UIView+Animation.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/21/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)animateWithBounce
{
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

@end
