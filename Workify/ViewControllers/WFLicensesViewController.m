//
//  WFLicensesViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 3/22/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//


#import "WFLicensesViewController.h"

@interface WFLicensesViewController ()
{
    UIWebView *webView;
}
@end

@implementation WFLicensesViewController

#pragma mark - Setup
- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Licenses", nil);
    }
    return self;
}

- (void)loadView {
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
    baseView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    [baseView addSubview:webView];
    
    self.view = baseView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    webView.frame = self.view.frame;
    
    NSString *licenseText = @"";
    NSArray* licensePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"txt" inDirectory:@"Licensing"];
//    NSArray *licenses = @[@"MBProgressHUD-License", @"UAAppReviewManager-License", @"Reachability-License", @"FXBlurView-License"];
    for(NSString *bundlePath in licensePaths) {
        //NSString *bundlePath = [[NSBundle mainBundle] pathForResource:license ofType:@"txt"];
        if(bundlePath) {
            NSString* fileName = [[bundlePath componentsSeparatedByString:@"/"] lastObject];
            if (fileName) {
                NSError *error = nil;
                NSString *contents = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:&error];
                if(!error) {
                    licenseText = [licenseText stringByAppendingFormat:@"<h2>%@</h2>", [fileName stringByReplacingOccurrencesOfString:@"-License.txt" withString:@""]];
                    licenseText = [licenseText stringByAppendingFormat:@"<p>%@</p>", contents];
                }
            }
        }
    }

    NSString *html = @"<html><head><style>body { font: 87.5% 'Avenir Next', 'Helvetica Neue', Arial, Helvetica, sans-serif; padding: 10px; color: #414141 } p { padding-bottom: 20px }</style></head><body style=\"background-color: transparent;\">";
    html = [html stringByAppendingString:[licenseText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"]];
    html = [html stringByAppendingString:@"</body></html>"];
    
    [webView loadHTMLString:html baseURL:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    webView.frame = self.view.bounds;
    webView.scrollView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0f, 0.0f, 0.0f);
    webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0f, 0.0f, 0.0f);
}


@end
