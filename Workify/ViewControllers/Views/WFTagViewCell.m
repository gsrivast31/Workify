//
//  WFTagViewCell.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFTagViewCell.h"
#import "SKTagView.h"
#import "SKTag.h"
#import "SKTagButton.h"
#import <Masonry/Masonry.h>
#import "DWTagList.h"

@interface WFTagViewCell() <DWTagListDelegate>

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (nonatomic, strong) DWTagList *tagList;

@end

@implementation WFTagViewCell

+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager {
    return 80.0f;
}

- (void)cellDidLoad {
    [super cellDidLoad];
    self.tagList = [[DWTagList alloc] initWithFrame:CGRectMake(self.tagView.frame.origin.x + 10, self.tagView.frame.origin.y + 10, self.tagView.frame.size.width - 20, self.tagView.frame.size.height - 20)];
    [self.tagList setAutomaticResize:YES];
    [_tagList setTagDelegate:self];
    [_tagList setCornerRadius:4.0f];
    [_tagList setBorderColor:[UIColor lightGrayColor]];
    [_tagList setBorderWidth:1.0f];
    
    [self.tagView addSubview:self.tagList];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    [self.tagList setTags:self.item.values];
}

- (void)cellDidDisappear {
    [super cellDidDisappear];
}
@end
