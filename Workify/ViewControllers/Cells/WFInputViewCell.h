//
//  WFInputViewCell.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 10/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "RETableViewCell.h"
#import "WFInputItem.h"

@class WFCategoryInputView;

@protocol WFCategoryInputViewDelegate <NSObject>
@optional
- (void)categoryInputView:(WFCategoryInputView *)categoryInputView didSelectOption:(NSUInteger)index;
@end

@interface WFCategorySelectorButton : UIButton
- (void)setTitle:(NSString*)aTitle;
@end

@interface WFCategoryInputView : UIView <UIActionSheetDelegate>
@property (nonatomic, weak) id<WFCategoryInputViewDelegate> delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) WFCategorySelectorButton *selectorButton;
@property (nonatomic, assign) NSUInteger selectedIndex;
- (id)initWithCategories:(NSArray *)categories;
@end

@interface WFInputViewCell : RETableViewCell
@property (nonatomic, retain) WFCategoryInputView *control;
@property (nonatomic, retain) UILabel *label;

@property (nonatomic, strong, readwrite) WFInputItem* item;
@end
