//
//  WFRatingViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFRatingViewCell.h"

@interface WFRatingViewCell()

@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *fourthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;

@end

@implementation WFRatingViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    [self.firstStar setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
    [self.secondStar setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
    [self.thirdStar setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
    [self.fourthStar setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
    [self.fifthStar setImage:[UIImage imageNamed:@"star-empty"] forState:UIControlStateNormal];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    int starsCount = [self.item.value intValue];
    if (starsCount-- > 0) [self.firstStar setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    if (starsCount-- > 0) [self.secondStar setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    if (starsCount-- > 0) [self.thirdStar setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    if (starsCount-- > 0) [self.fourthStar setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    if (starsCount-- > 0) [self.fifthStar setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

@end
