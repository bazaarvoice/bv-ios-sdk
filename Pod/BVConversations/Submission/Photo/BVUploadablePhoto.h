//
//  BVUploadablePhoto.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PhotoUploadCompletion)(NSString *__nonnull photoUrl);
typedef void (^PhotoUploadFailure)(NSArray<NSError *> *__nonnull errors);

typedef NS_ENUM(NSInteger, BVPhotoContentType) {
  BVPhotoContentTypeReview,
  BVPhotoContentTypeQuestion,
  BVPhotoContentTypeAnswer,
  BVPhotoContentTypeComment // PRR only
};

@interface BVUploadablePhoto : NSObject

@property(nonnull, readonly) UIImage *photo;
@property(nullable, readonly) NSString *photoCaption;
@property(readwrite) NSUInteger
    maxImageBytes; // Set by BVUploadablePhoto itself, but is here for testing

- (nonnull instancetype)initWithPhoto:(nonnull UIImage *)photo
                         photoCaption:(nullable NSString *)caption;
- (nonnull instancetype)__unavailable init;

- (void)uploadForContentType:(BVPhotoContentType)type
                     success:(nonnull PhotoUploadCompletion)success
                     failure:(nonnull PhotoUploadFailure)failure;

@end
