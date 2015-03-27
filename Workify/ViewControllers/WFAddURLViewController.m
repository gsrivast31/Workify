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

@property (nonatomic, readwrite, strong) RETableViewManager* manager;
@property (strong, nonatomic) NSMutableArray* urlItems;

@end

@implementation WFAddURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Review";
    
    self.urlItems = [[NSMutableArray alloc] initWithCapacity:10];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager[@"WFButtonItem"] = @"WFButtonCell";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconSave"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(done:)];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addTableEntries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
