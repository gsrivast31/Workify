//
//  WFDaysTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDaysTableViewCell.h"

@interface WFDaysTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *monButton;
@property (weak, nonatomic) IBOutlet UIButton *tueButton;
@property (weak, nonatomic) IBOutlet UIButton *wedButton;
@property (weak, nonatomic) IBOutlet UIButton *thursButton;
@property (weak, nonatomic) IBOutlet UIButton *friButton;
@property (weak, nonatomic) IBOutlet UIButton *satButton;
@property (weak, nonatomic) IBOutlet UIButton *sunButton;

@end

@implementation WFDaysTableViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    [self setTintColor:[UIColor clearColor]];
    [self.monButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.tueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.thursButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.friButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.satButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sunButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.monButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.tueButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.wedButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.thursButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.friButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.satButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.sunButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    
    [self.monButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.tueButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.wedButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.thursButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.friButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.satButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.sunButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    self.monButton.selected = self.tueButton.selected = self.wedButton.selected = self.thursButton.selected = self.friButton.selected = self.satButton.selected = self.sunButton.selected = NO;

    for (NSNumber* val in self.item.value) {
        NSInteger intVal = [val integerValue];
        if (intVal == 0) {
            self.monButton.selected = YES;
        } else if (intVal == 1) {
            self.tueButton.selected = YES;
        } else if (intVal == 2) {
            self.wedButton.selected = YES;
        } else if (intVal == 3) {
            self.thursButton.selected = YES;
        } else if (intVal == 4) {
            self.friButton.selected = YES;
        } else if (intVal == 5) {
            self.satButton.selected = YES;
        } else if (intVal == 6) {
            self.sunButton.selected = YES;
        }
    }
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)changeState:(id)sender {
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;

    NSMutableArray* array = [NSMutableArray array];
    if (self.monButton.selected) {
        [array addObject:[NSNumber numberWithInteger:0]];
    }
    if (self.tueButton.selected) {
        [array addObject:[NSNumber numberWithInteger:1]];
    }
    if (self.wedButton.selected) {
        [array addObject:[NSNumber numberWithInteger:2]];
    }
    if (self.thursButton.selected) {
        [array addObject:[NSNumber numberWithInteger:3]];
    }
    if (self.friButton.selected) {
        [array addObject:[NSNumber numberWithInteger:4]];
    }
    if (self.satButton.selected) {
        [array addObject:[NSNumber numberWithInteger:5]];
    }
    if (self.sunButton.selected) {
        [array addObject:[NSNumber numberWithInteger:6]];
    }
    
    self.item.value = [array copy];
}

@end
