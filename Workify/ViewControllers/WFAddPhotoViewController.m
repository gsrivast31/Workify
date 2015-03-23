//
//  WFAddPhotoViewController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 09/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFAddPhotoViewController.h"
#import "WFMediaController.h"
#import "WFPhotoCell.h"
#import "KRLCollectionViewGridLayout.h"
#import "JTSImageViewController.h"
#import "MZFormSheetPresentationController.h"
#import "WFAddURLViewController.h"

@interface WFAddPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, WFAddURLDelegate>

@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation WFAddPhotoViewController

static NSString * const reuseIdentifier = @"photoCell";

- (KRLCollectionViewGridLayout *)layout {
    return (id)self.collectionView.collectionViewLayout;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photosArray = [[NSMutableArray alloc] init];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    self.layout.numberOfItemsPerLine = 3;
    self.layout.aspectRatio = 1;
    self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.layout.interitemSpacing = 10;
    self.layout.lineSpacing = 10;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavBarIconAdd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(addPhoto:)];
    
    self.doneButton.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:0.8];
    [self.doneButton.titleLabel setFont:[UIFont iconFontWithSize:17]];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"Add Photos";
}

- (void)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photosAdded:)]) {
        [self.delegate photosAdded:nil];
    }
}

- (void)addPhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}

- (void)done:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photosAdded:)]) {
        [self.delegate photosAdded:self.photosArray];
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", @"URL", nil];
    
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

- (void)promptForURL {
    WFAddURLViewController* vc = [[WFAddURLViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
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
        } else if(buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
            [self promptForPhotoRoll];
        } else {
            [self promptForURL];
        }
    }
}

#pragma mark WFAddURLDelegate

- (void)urlsAdded:(NSArray *)urlArray {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)noUrlAdded {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
