//
//  BVPhotoSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmittedPhoto.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BVPhotoContentType) {
  BVPhotoContentTypeAnswer,
  BVPhotoContentTypeComment, // PRR only
  BVPhotoContentTypeQuestion,
  BVPhotoContentTypeReview
};

@interface BVPhotoSubmission : BVSubmission <BVSubmittedPhoto *>

@property(nonnull, readonly) UIImage *photo;
@property(nullable, readonly) NSString *photoCaption;
@property(readonly) BVPhotoContentType photoContentType;
@property(readwrite) NSUInteger
    maxImageBytes; // Set by BVPhotoSubmission itself, but is here for testing

- (nonnull instancetype)initWithPhoto:(nonnull UIImage *)photo
                         photoCaption:(nullable NSString *)photoCaption
                     photoContentType:(BVPhotoContentType)photoContentType;
- (nonnull instancetype)__unavailable init;

@end
