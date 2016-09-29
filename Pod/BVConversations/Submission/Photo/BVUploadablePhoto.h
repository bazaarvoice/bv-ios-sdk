//
//  BVUploadablePhoto.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PhotoUploadCompletion)(NSString* _Nonnull photoUrl);
typedef void (^PhotoUploadFailure)(NSArray<NSError*>* _Nonnull errors);

typedef NS_ENUM(NSInteger, BVPhotoContentType) {
    BVPhotoContentTypeReview,
    BVPhotoContentTypeQuestion,
    BVPhotoContentTypeAnswer
};

@interface BVUploadablePhoto : NSObject

@property (readonly) UIImage* _Nonnull photo;
@property (readonly) NSString* _Nullable photoCaption;

-(nonnull instancetype)initWithPhoto:(nonnull UIImage*)photo photoCaption:(nullable NSString*)caption;
-(nonnull instancetype) __unavailable init;

-(void)uploadForContentType:(BVPhotoContentType)type success:(nonnull PhotoUploadCompletion)success failure:(nonnull PhotoUploadFailure)failure;

@end
