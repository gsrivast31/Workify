//
//  WFMediaController.h
//  Workify
//
//  Created by GAURAV SRIVASTAVA on 06/02/15.
//  Copyright (c) 2015 GAURAV SRIVASTAVA. All rights reserved.
//

@interface WFMediaController : NSObject

+ (id)sharedInstance;

// Logic
- (void)saveImage:(UIImage *)image
     withFilename:(NSString *)filename
          success:(void (^)(void))successCallback
          failure:(void (^)(NSError *))failureCallback;
- (void)deleteImageWithFilename:(NSString *)filename
                        success:(void (^)(void))successCallback
                        failure:(void (^)(NSError *))failureCallback;
- (UIImage *)imageWithFilename:(NSString *)filename;
- (void)imageWithFilenameAsync:(NSString *)filename
                       success:(void (^)(UIImage *))successCallback
                       failure:(void (^)(void))failureCallback;
- (void)imageFromURL:(NSURL *)url
             success:(void (^)(UIImage *))successCallback
             failure:(void (^)(void))failureCallback;

// Helpers
- (UIImage *)resizeImage:(UIImage *)image
                  toSize:(CGSize)newSize;
+ (BOOL)canStoreMedia;

@end
