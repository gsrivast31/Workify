//
//  WFHourViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFHourViewCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 5.0;
static const CGFloat kPadding = 5.0f;

@interface WFSingleDayCell()

@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, strong) UITextField* startHourTextField;
@property (nonatomic, strong) UITextField* endHourTextField;
@property (nonatomic, strong) UIButton* closedButton;

@property (nonatomic, strong) UILabel* startHoursLabel;
@property (nonatomic, strong) UILabel* endHoursLabel;
@property (nonatomic, strong) UILabel* dashLabel;

@end

@implementation WFSingleDayCell

- (id)initWithDay:(NSString *)day {
    if (self = [super init]) {
        self.dayLabel = [[UILabel alloc] init];
        self.startHourTextField = [[UITextField alloc] init];
        self.endHourTextField = [[UITextField alloc] init];
        self.closedButton = [[UIButton alloc] init];
        
        [self.closedButton setTitle:@"Open" forState:UIControlStateNormal];
        [self.closedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closedButton setTitle:@"Closed" forState:UIControlStateDisabled];
        [self.closedButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.closedButton addTarget:self action:@selector(toggleState:) forControlEvents:UIControlEventTouchUpInside];
        
        self.startHoursLabel = [[UILabel alloc] init];
        self.endHoursLabel = [[UILabel alloc] init];
        self.dashLabel = [[UILabel alloc] init];

        [self.dayLabel setText:day];
        [self.dayLabel setFont:[UIFont flatFontOfSize:14]];
        [self.startHoursLabel setText:@"hrs"];
        [self.startHoursLabel setFont:[UIFont flatFontOfSize:12]];
        [self.endHoursLabel setText:@"hrs"];
        [self.endHoursLabel setFont:[UIFont flatFontOfSize:12]];
        [self.dashLabel setText:@"to"];
        [self.dashLabel setFont:[UIFont flatFontOfSize:12]];
        
        [self addSubview:self.dayLabel];
        [self addSubview:self.startHourTextField];
        [self addSubview:self.startHoursLabel];
        [self addSubview:self.endHourTextField];
        [self addSubview:self.endHoursLabel];
        [self addSubview:self.closedButton];
    }
    return self;
}

- (void)setContentFrame:(CGRect)frame {
    self.frame = frame;
    CGFloat dayWidth = [self.dayLabel.text re_sizeWithFont:[UIFont flatFontOfSize:14]].width;
    self.dayLabel.frame = CGRectMake(0, 0, dayWidth, self.frame.size.height);

    CGFloat endHourWidth = [self.endHoursLabel.text re_sizeWithFont:[UIFont flatFontOfSize:12]].width;
    CGFloat startHourWidth = [self.startHoursLabel.text re_sizeWithFont:[UIFont flatFontOfSize:12]].width;
    CGFloat dashWidth = [self.dashLabel.text re_sizeWithFont:[UIFont flatFontOfSize:12]].width;

    CGFloat startX = self.frame.size.width - endHourWidth - kHorizontalMargin;
    
    self.endHoursLabel.frame = CGRectMake(startX, 0, endHourWidth, self.frame.size.height);
    startX -= 40.0f + kPadding;
    
    self.endHourTextField.frame = CGRectMake(startX, 0, 40.0f, self.frame.size.height);
    startX -= dashWidth + kPadding;
    
    self.dashLabel.frame = CGRectMake(startX, 0, dashWidth, self.frame.size.height);
    startX -= startHourWidth + kPadding;
    
    self.startHoursLabel.frame = CGRectMake(startX, 0, startHourWidth, self.frame.size.height);
    startX -= 40.0f + kPadding;
    
    self.startHourTextField.frame = CGRectMake(startX, 0, 40.0f, self.frame.size.height);
    startX -= 100.0f + kPadding;
    
    self.closedButton.frame = CGRectMake(startX, 0, 100.0f, self.frame.size.height);
}

- (void)setState:(BOOL)isClosed {
    if (isClosed) {
        [self.closedButton setEnabled:NO];
        [self.startHourTextField setEnabled:NO];
        [self.endHourTextField setEnabled:NO];
        [self.startHoursLabel setTextColor:[UIColor grayColor]];
        [self.endHoursLabel setTextColor:[UIColor grayColor]];
    } else {
        [self.closedButton setEnabled:YES];
        [self.startHourTextField setEnabled:YES];
        [self.endHourTextField setEnabled:YES];
        [self.startHourTextField setText:@""];
        [self.endHourTextField setText:@""];
        [self.startHoursLabel setTextColor:[UIColor blackColor]];
        [self.endHoursLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)setContent:(NSDictionary*)dict {
    [self.dayLabel setText:dict[@"day"]];
    [self.startHourTextField setText:dict[@"start"]];
    [self.endHourTextField setText:dict[@"end"]];
    
    BOOL isClosed = [(NSNumber*)dict[@"closed"] boolValue];
    [self setState:isClosed];
}

- (void)toggleState:(id)sender {
    if ([self.closedButton isEnabled]) {
        [self setState:NO];
    } else {
        [self setState:YES];
    }
}

@end

@interface WFHourViewCell()

@end

@implementation WFHourViewCell

- (void)cellDidLoad {
    [super cellDidLoad];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Mon"]];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Tue"]];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Wed"]];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Thu"]];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Fri"]];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Sat"]];
    [self addSubview:[[WFSingleDayCell alloc] initWithDay:@"Sun"]];
}

- (void)cellWillAppear {
    [super cellWillAppear];
}

- (void)layoutSubviews {
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFHourViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    CGFloat startY = frame.origin.y;
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[WFSingleDayCell class]]) {
            [(WFSingleDayCell*)view setContentFrame:CGRectMake(frame.origin.x, startY, frame.size.width, 30.0f)];
            startY += 30.0f + kVerticalMargin;
        }
    }
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    return 210.0f + 2*kVerticalMargin + 6*kVerticalMargin;
}
@end
