//
//  WFDaysTableViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFDaysTableViewCell.h"

@interface WFDaysTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *anyButton;
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
    [self.anyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.monButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.tueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.thursButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.friButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.satButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sunButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.anyButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.monButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.tueButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.wedButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.thursButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.friButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.satButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    [self.sunButton setTitleColor:[UIColor turquoiseColor] forState:UIControlStateSelected];
    
    [self.anyButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.monButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.tueButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.wedButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.thursButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.friButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.satButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [self.sunButton addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    
    self.anyButton.selected = self.monButton.selected = self.tueButton.selected = self.wedButton.selected = self.thursButton.selected = self.friButton.selected = self.satButton.selected = self.sunButton.selected = NO;

}

- (void)cellWillAppear {
    [super cellWillAppear];
    
    for (NSNumber* val in self.item.value) {
        NSInteger intVal = [val integerValue];
        if (intVal == 0) {
            self.anyButton.selected = YES;
        } else if (intVal == 1) {
            self.monButton.selected = YES;
        } else if (intVal == 2) {
            self.tueButton.selected = YES;
        } else if (intVal == 3) {
            self.wedButton.selected = YES;
        } else if (intVal == 4) {
            self.thursButton.selected = YES;
        } else if (intVal == 5) {
            self.friButton.selected = YES;
        } else if (intVal == 6) {
            self.satButton.selected = YES;
        } else if (intVal == 7) {
            self.sunButton.selected = YES;
        }
    }
    [self.anyButton setSelected:YES];
    [self.thursButton setSelected:YES];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

- (void)changeState:(id)sender {
    UIButton* button = (UIButton*)sender;
    button.selected = !button.selected;
    
    if (button == self.anyButton && button.selected == YES) {
        self.monButton.selected = self.tueButton.selected = self.wedButton.selected = self.thursButton.selected = self.friButton.selected = self.satButton.selected = self.sunButton.selected = NO;
    } else if(button.selected == YES) {
        self.anyButton.selected = NO;
    }
    
    self.item.value = @[[NSNumber numberWithBool:self.anyButton.selected],
                        [NSNumber numberWithBool:self.monButton.selected],
                        [NSNumber numberWithBool:self.tueButton.selected],
                        [NSNumber numberWithBool:self.wedButton.selected],
                        [NSNumber numberWithBool:self.thursButton.selected],
                        [NSNumber numberWithBool:self.friButton.selected],
                        [NSNumber numberWithBool:self.satButton.selected],
                        [NSNumber numberWithBool:self.sunButton.selected]];
}

@end
