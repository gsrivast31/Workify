//
//  WFMediaController.m
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

#import "WFMediaController.h"

@interface WFMediaController()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation WFMediaController
@synthesize cache = _cache;

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Setup
- (id)init
{
    self = [super init];
    if(self)
    {
        _cache = [[NSCache alloc] init];
    }
    
    return self;
}

#pragma mark - Logic
- (void)saveImage:(UIImage *)image
     withFilename:(NSString *)filename
          success:(void (^)(void))successCallback
          failure:(void (^)(NSError *))failureCallback
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // TODO: Replace with settings value for image quality
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        dispatch_async( dispatch_get_main_queue(), ^{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if([paths count])
            {
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
                NSString *imagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", filename]];
                
                NSError *error = nil;
                if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
                {
                    if(![[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error])
                    {
                        error = [NSError errorWithDomain:@"IM"
                                                    code:0
                                                userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Unable to create image documents folder", nil)}];
                    }
                }
                
                // Provided we haven't run into a previous error, try to write away our image
                if(!error)
                {
                    [imageData writeToFile:imagePath options:NSDataWritingAtomic error:&error];
                }
                
                // Call either our success or failure callback
                if(!error)
                {
                    successCallback();
                }
                else
                {
                    failureCallback(error);
                }
            }
        });
    });
}
- (void)deleteImageWithFilename:(NSString *)filename
                        success:(void (^)(void))successCallback
                        failure:(void (^)(NSError *))failureCallback
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count])
    {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
        NSString *imagePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", filename]];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
        
        [self.cache removeObjectForKey:filename];
        
        // Call either our success or failure callback
        if(!error)
        {
            if(successCallback) successCallback();
        }
        else
        {
            if(failureCallback) failureCallback(error);
        }
    }
}
- (UIImage *)imageWithFilename:(NSString *)filename
{
    if([self.cache objectForKey:filename]) return [self.cache objectForKey:filename];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if([paths count])
    {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Images/%@.jpg", filename]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if(image)
        {
            [self.cache setObject:image forKey:filename];
            
            return image;
        }
    }
    
    return nil;
}
- (void)imageWithFilenameAsync:(NSString *)filename
                       success:(void (^)(UIImage *))successCallback
                       failure:(void (^)(void))failureCallback
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if([strongSelf.cache objectForKey:filename])
        {
            if(successCallback) successCallback([strongSelf.cache objectForKey:filename]);
            return;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([paths count])
        {
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/Images/%@.jpg", filename]];
            
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            if(image)
            {
                [strongSelf.cache setObject:image forKey:filename];
                
                if(successCallback) successCallback(image);
                return;
            }
        }
        
        if(failureCallback) failureCallback();
    });
}

- (void)imageFromURL:(NSURL *)url
             success:(void (^)(UIImage *))successCallback
             failure:(void (^)(void))failureCallback {
    
    if([self.cache objectForKey:url.absoluteString]) {
        if(successCallback) successCallback([self.cache objectForKey:url.absoluteString]);
        return;
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [self.cache setObject:image forKey:url.absoluteString];
        
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(image);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureCallback();
            });
        }
    }];
    [task resume];
}

#pragma mark - Helpers
- (UIImage *)resizeImage:(UIImage *)image
                  toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
+ (BOOL)canStoreMedia
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}



@end