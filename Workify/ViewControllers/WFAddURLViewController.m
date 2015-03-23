//
//  WFAddURLViewController.m
//  Workify
//
//  Created by Ranjeet on 3/23/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddURLViewController.h"
#import "RETableViewManager.h"
#import "WFButtonItem.h"

@interface WFAddURLViewController() <RETableViewManagerDelegate>

@property (nonatomic, strong) UIButton* publishButton;
@property (nonatomic, strong) UIButton* cancelButton;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, readwrite, strong) RETableViewManager* manager;

@property (strong, nonatomic) NSMutableArray* urlItems;

@end

@implementation WFAddURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Review";
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.publishButton = [[UIButton alloc] init];
    [self.publishButton setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8]];
    [self.publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.publishButton setTitle:[NSString stringWithFormat:@"%@ Done", [NSString iconStringForEnum:FUICheck]] forState:UIControlStateNormal];
    [self.publishButton.titleLabel setFont:[UIFont iconFontWithSize:16]];
    [self.publishButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.publishButton];
    
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setBackgroundColor:[UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8]];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[NSString stringWithFormat:@"%@ Cancel", [NSString iconStringForEnum:FUICross]]  forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont iconFontWithSize:16]];
    
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];

    self.urlItems = [[NSMutableArray alloc] initWithCapacity:10];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFButtonItem"] = @"WFButtonCell";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addTableEntries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.publishButton.frame = CGRectMake(0.0f, self.view.frame.size.height - 44.0f, self.view.frame.size.width / 2.0f, 44.0f);
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height - 44.0f, self.view.frame.size.width / 2.0f, 44.0f);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44.0f);
}


- (void)addTableEntries {
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];

    for (NSInteger i=0; i<10; i++) {
        NSString* iStr = [[NSNumber numberWithInteger:i+1] stringValue];
        RETextItem* item = [RETextItem itemWithTitle:iStr value:nil placeholder:[@"URL " stringByAppendingString:iStr]];
        item.validators = @[@"url"];
        item.cellHeight = 40.0f;
        [section addItem:item];
        [self.urlItems addObject:item];
    }
}

- (void)done:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(urlsAdded:)]) {
            NSArray *managerErrors = self.manager.errors;
            if (managerErrors.count > 0) {
                NSMutableArray *errors = [NSMutableArray array];
                for (NSError *error in managerErrors) {
                    [errors addObject:error.localizedDescription];
                }
                NSString *errorString = [errors componentsJoinedByString:@"\n"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                NSMutableArray* values = [[NSMutableArray alloc] init];
                for (RETextItem* item in self.urlItems) {
                    NSString* value = item.value;
                    if ([self isValidString:value]) {
                        [values addObject:value];
                    }
                }
                
                [self.delegate urlsAdded:values];
            }
        }
    }
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noUrlAdded)]) {
        [self.delegate noUrlAdded];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)isValidString:(NSString*)string {
    return string && ![string isEqualToString:@""];
}

- (void)saveURLs {
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
