//
//  WFInputViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFInputViewCell.h"
#import "RETableViewManager.h"
#import "NSString+RETableViewManagerAdditions.h"

static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 5.0;

#pragma mark WFCategorySelectorButton
@implementation WFCategorySelectorButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont flatFontOfSize:16];
        self.titleLabel.contentMode = UIViewContentModeCenter;
        
        [self setImage:[UIImage imageNamed:@"DropdownDisclosureIcon"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:49.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setTitle:(NSString *)aTitle {
    [self setTitle:aTitle forState:UIControlStateNormal];
    
    CGSize titleSize = [aTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.bounds = CGRectMake(0.0f, 0.0f, titleSize.width + self.imageView.bounds.size.width + 20.0f, self.bounds.size.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10.0f, 0.0f, self.bounds.size.width - self.imageView.image.size.width, self.bounds.size.height);
    self.imageView.frame = CGRectMake(self.bounds.size.width - self.imageView.image.size.width, self.bounds.size.height/2.0f - self.imageView.image.size.height/2.0f, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:232.0f/255.0f green:234.0f/255.0f blue:235.0f/255.0f alpha:1.0f].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 0,0);
    CGContextAddLineToPoint(context, 0.0f, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

@end

#pragma mark WFCategoryInputView

@interface WFCategoryInputView ()
@property (nonatomic, strong) NSArray *categories;
- (void)didTapSelectorButton:(WFCategorySelectorButton *)button;
@end

@implementation WFCategoryInputView

#pragma mark - Setup
- (id)initWithCategories:(NSArray *)theCategories
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _categories = theCategories;
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.adjustsFontSizeToFitWidth = NO;
        _textField.font = [UIFont flatFontOfSize:16.0f];
        _textField.textColor = [UIColor colorWithRed:49.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        _textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        _textField.textAlignment = NSTextAlignmentRight;
        
        _selectorButton = [[WFCategorySelectorButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 28.0f)];
        [_selectorButton addTarget:self action:@selector(didTapSelectorButton:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedIndex = 0;
        
        [self addSubview:_textField];
        [self addSubview:_selectorButton];
    }
    return self;
}

- (void)didTapSelectorButton:(WFCategorySelectorButton *)button {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for(NSString *category in self.categories) {
        [actionSheet addButtonWithTitle:category];
    }
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet setCancelButtonIndex:[self.categories count]];
    [actionSheet showInView:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat spacing = 10.0f;
    self.textField.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width - (self.selectorButton.bounds.size.width + spacing), self.bounds.size.height);
    self.selectorButton.frame = CGRectMake(self.textField.frame.origin.x + self.textField.frame.size.width + spacing, 0.0f, self.selectorButton.bounds.size.width, self.bounds.size.height);
}

#pragma mark - Accessors
- (void)setSelectedIndex:(NSUInteger)index {
    _selectedIndex = index;
    [self.selectorButton setTitle:self.categories[index]];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != [actionSheet cancelButtonIndex]) {
        self.selectedIndex = buttonIndex;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(categoryInputView:didSelectOption:)]) {
            [self.delegate categoryInputView:self didSelectOption:buttonIndex];
        }
    }
}

@end

#pragma mark WFInputViewCell

@implementation WFInputViewCell

@synthesize control = _control;
@synthesize label = _label;

#pragma mark - Setup

- (void)cellDidLoad {
    [super cellDidLoad];
    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont flatFontOfSize:14.0f];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @" ";
    [self.contentView addSubview:_label];
    
    self.control = [[WFCategoryInputView alloc] initWithCategories:nil];
    [self.contentView addSubview:self.control];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    [self.control setCategories:self.item.categories];
    [self.control setSelectedIndex:[self.item.selectedIndex unsignedIntegerValue]];
    [self.control.textField setText:self.item.value];
    [self.label setText:self.item.name];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    return 40.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (REUIKitIsFlatMode() && self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [WFInputViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    self.label.frame = CGRectMake(frame.origin.x, frame.origin.y, 120.0f, frame.size.height);
    self.control.frame = CGRectMake(frame.origin.x + 130.0f, frame.origin.y, frame.size.width-140.0f, frame.size.height);
}

@end
