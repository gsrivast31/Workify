//
//  WFStepperTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFStepperTableViewCell.h"

@interface WFStepperTableViewCell()
{
    NSUInteger currentIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *valueButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@end

@implementation WFStepperTableViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    [self.minusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.minusButton setTintColor:[UIColor turquoiseColor]];
    [self.plusButton setTintColor:[UIColor turquoiseColor]];
    [self.valueButton.titleLabel setFont:[UIFont flatFontOfSize:16]];
    [self.valueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.minusButton addTarget:self action:@selector(decreaseValue:) forControlEvents:UIControlEventTouchUpInside];
    [self.plusButton addTarget:self action:@selector(increaseValue:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    currentIndex = [self.item.values indexOfObject:self.item.value];
    [self.valueButton setTitle:self.item.value forState:UIControlStateNormal];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}


- (void)increaseValue:(id)sender {
    if (currentIndex < [self.item.values count] - 1) {
        currentIndex++;
        self.item.value = [self.item.values objectAtIndex:currentIndex];
        [self.valueButton setTitle:self.item.value forState:UIControlStateNormal];
    }
}

- (void)decreaseValue:(id)sender {
    if (currentIndex > 0) {
        currentIndex--;
        self.item.value = [self.item.values objectAtIndex:currentIndex];
        [self.valueButton setTitle:self.item.value forState:UIControlStateNormal];
    }
}

@end
