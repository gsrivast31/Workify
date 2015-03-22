//
//  WFPhotoViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFPhotoViewController.h"
#import "KRLCollectionViewGridLayout.h"
#import "WFPhotoCell.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "WFMediaController.h"
#import "WFLoginViewController.h"
#import "MZFormSheetPresentationController.h"

@interface WFPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, WFLoginDelegate>

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation WFPhotoViewController

static NSString * const reuseIdentifier = @"photoCell";

- (KRLCollectionViewGridLayout *)layout {
    return (id)self.collectionView.collectionViewLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.photosArray = [[NSMutableArray alloc] init];
    self.layout.numberOfItemsPerLine = 3;
    self.layout.aspectRatio = 1;
    self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layout.interitemSpacing = 10;
    self.layout.lineSpacing = 10;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(addPhoto:)];
    
    self.title = @"Photos";
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addPhoto:(id)sender {
    if ([WFHelper isLoggedIn]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self promptForSource];
        } else {
            [self promptForPhotoRoll];
        }
    } else {
        WFLoginViewController* vc = [[WFLoginViewController alloc] init];
        vc.loginDelegate = self;
        UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
        navVC.view.layer.cornerRadius = 6.0;
        
        MZFormSheetPresentationController *controller = [[MZFormSheetPresentationController alloc] initWithContentViewController:navVC];
        controller.contentViewControllerTransitionStyle = MZFormSheetTransitionStyleDropDown;
        controller.shouldCenterVertically = YES;
        controller.shouldDismissOnBackgroundViewTap = YES;
        controller.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTop;
        controller.shouldApplyBackgroundBlurEffect = YES;
        
        navVC.navigationBarHidden = YES;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell configureCellWithURL:[self.photosArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WFPhotoCell* cell = (WFPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    JTSImageInfo* imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = cell.imageView.image;
    imageInfo.referenceRect = cell.imageView.frame;
    imageInfo.referenceView = cell.imageView.superview;
    imageInfo.referenceContentMode = cell.imageView.contentMode;
    imageInfo.referenceCornerRadius = cell.imageView.layer.cornerRadius;
    
    JTSImageViewController* imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark UIImagePickerControllerDelegate

- (void)promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) saveImage:(UIImage*)image {
    
    NSString * timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSString* filePath = [NSString stringWithFormat:@"image_%@.jpeg", timeStamp];
    
    __weak typeof(self) weakSelf = self;
    
    [[WFMediaController sharedInstance] saveImage:image withFilename:filePath success:^{
        __strong typeof(weakSelf) strongSelf = self;
        
        [strongSelf.photosArray addObject:filePath];
        [strongSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[strongSelf.photosArray count]-1 inSection:0]]];
    } failure:^(NSError *error) {
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self saveImage:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

#pragma mark WFLoginDelegate 

- (void)loggedInWithUser:(PFUser *)user error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (!user) {
        NSString *errorMessage = nil;
        if (!error) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            errorMessage = @"Uh oh. The user cancelled the Facebook login.";
        } else {
            NSLog(@"Uh oh. An error occurred: %@", error);
            errorMessage = [error localizedDescription];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Dismiss", nil];
        [alert show];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self promptForSource];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

@end
