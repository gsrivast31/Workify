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
#import "WFDayItem.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 5.0;
static const CGFloat kPadding = 5.0f;
static const CGFloat kRowHeight = 40.0f;

@interface WFSingleDayCell()

@property (nonatomic, strong) UILabel* dayLabel;
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
        
        [self.startHourTextField setBorderStyle:UITextBorderStyleBezel];
        [self.startHourTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [self.endHourTextField setBorderStyle:UITextBorderStyleBezel];
        [self.endHourTextField setKeyboardType:UIKeyboardTypeNumberPad];

        self.closedButton = [[UIButton alloc] init];
        
        [self.closedButton setTitle:@"Closed" forState:UIControlStateNormal];
        
        [self.closedButton.titleLabel setFont:[UIFont flatFontOfSize:14]];
        [self.closedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.closedButton setBackgroundColor:[UIColor turquoiseColor]];
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
        [self addSubview:self.dashLabel];
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
    startX -= 60.0f + kPadding;
    
    self.endHourTextField.frame = CGRectMake(startX, 0, 60.0f, self.frame.size.height);
    startX -= dashWidth + kPadding;
    
    self.dashLabel.frame = CGRectMake(startX, 0, dashWidth, self.frame.size.height);
    startX -= startHourWidth + kPadding;
    
    self.startHoursLabel.frame = CGRectMake(startX, 0, startHourWidth, self.frame.size.height);
    startX -= 60.0f + kPadding;
    
    self.startHourTextField.frame = CGRectMake(startX, 0, 60.0f, self.frame.size.height);
    startX -= 100.0f + kPadding;
    
    self.closedButton.frame = CGRectMake(startX, 4.0, 60.0f, self.frame.size.height - 8.0f);
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

@property (nonatomic, strong) NSMutableArray* rows;

@end

@implementation WFHourViewCell

@synthesize rows;

+ (BOOL)canFocusWithItem:(WFDayItem *)item {
    return YES;
}

- (UIResponder *)responder {
    return ((WFSingleDayCell*)rows[0]).startHourTextField;
}

- (void)cellDidLoad {
    [super cellDidLoad];
    
    rows = [[NSMutableArray alloc] initWithCapacity:7];
    
    NSArray* dayArray = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"];
    for (NSInteger i=0; i<[dayArray count]; i++) {
        WFSingleDayCell* cell = [[WFSingleDayCell alloc] initWithDay:[dayArray objectAtIndex:i]];
        cell.tag = i+1;
        cell.startHourTextField.inputAccessoryView = self.actionBar;
        cell.endHourTextField.inputAccessoryView = self.actionBar;
        [self addSubview:cell];
        [rows addObject:cell];
    }
}

- (void)cellWillAppear {
    [super cellWillAppear];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFHourViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    CGFloat startY = frame.origin.y;
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[WFSingleDayCell class]]) {
            [(WFSingleDayCell*)view setContentFrame:CGRectMake(frame.origin.x, startY, frame.size.width, kRowHeight)];
            startY += kRowHeight + kVerticalMargin;
        }
    }
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    return 7*kRowHeight + 2*kVerticalMargin + 6*kVerticalMargin;
}

@end
