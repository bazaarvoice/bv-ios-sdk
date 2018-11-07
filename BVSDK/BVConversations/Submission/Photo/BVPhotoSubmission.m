//
//  BVPhotoSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVPhotoSubmission.h"
#import "BVConversationsRequest+Private.h"
#import "BVConversationsRequest.h"
#import "BVLogger+Private.h"
#import "BVMultiPart+NSURLRequest.h"
#import "BVNetworkingManager.h"
#import "BVPhotoSubmissionErrorResponse.h"
#import "BVPhotoSubmissionResponse.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVSubmission+Private.h"
#import "BVSubmissionErrorResponse.h"

static NSUInteger const MAX_IMAGE_BYTES = 5 * 1024 * 1024; /// BV API max is 5MB

@interface BVPhotoSubmission ()

@property(nonnull, readwrite) UIImage *photo;
@property(nullable, readwrite) NSString *photoCaption;
@property(readwrite) BVPhotoContentType photoContentType;

@end

@implementation BVPhotoSubmission

- (nonnull instancetype)initWithPhoto:(nonnull UIImage *)photo
                         photoCaption:(nullable NSString *)photoCaption
                     photoContentType:(BVPhotoContentType)photoContentType {
  if ((self = [super init])) {
    self.photo = photo;
    self.photoCaption = photoCaption;
    self.photoContentType = photoContentType;
    self.maxImageBytes = MAX_IMAGE_BYTES;
  }
  return self;
}

- (NSString *)photoContentTypeToString {
  switch (self.photoContentType) {
  case BVPhotoContentTypeReview:
    return @"review";
  case BVPhotoContentTypeAnswer:
    return @"answer";
  case BVPhotoContentTypeQuestion:
    return @"question";
  case BVPhotoContentTypeComment:
    return @"review_comment";
  }
}

- (nullable NSData *)nsDataForPhoto {
  NSData *nsData = UIImageJPEGRepresentation(self.photo, 1.0);
  if (nsData && nsData.length > self.maxImageBytes) {
    nsData = UIImageJPEGRepresentation(self.photo, 0.9);
    NSUInteger imageByteCount = nsData.length;
    if (imageByteCount > self.maxImageBytes) {
      UIImage *workingImage = self.photo;

      while (imageByteCount > self.maxImageBytes) {
        CGSize oldSize = workingImage.size;
        CGSize newSize = CGSizeMake(oldSize.width / 2, oldSize.height / 2);
        workingImage = [self resize:workingImage withTargetSize:newSize];
        nsData = UIImageJPEGRepresentation(workingImage, 0.9);
        imageByteCount = nsData.length;
      }
    }
  }
  return nsData;
}

- (nonnull UIImage *)resize:(UIImage *)image withTargetSize:(CGSize)targetSize {
  CGRect rect = CGRectMake(0, 0, targetSize.width, targetSize.height);
  UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0);
  [image drawInRect:rect];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

- (nonnull NSString *)endpoint {
  return @"uploadphoto.json";
}

- (nonnull NSURLRequest *)generateRequest {
  NSDictionary *parameters = [self createSubmissionParameters];

  NSString *urlString = [NSString
      stringWithFormat:@"%@%@", [BVSubmission commonEndpoint], [self endpoint]];
  NSURL *url = [NSURL URLWithString:urlString];

  /// add multipart form data
  NSMutableData *body = [NSMutableData data];
  NSString *boundary = [NSURLRequest generateBoundaryWithData:body
                                         andContentDictionary:parameters];

  if (!boundary) {
    BVLogError(@"Couldn't generate multi-part boundary, this shouldn't ever "
               @"happen. Please file a bug.",
               BV_PRODUCT_CONVERSATIONS);
    return nil;
  }

  BVLogVerbose(
      ([NSString
          stringWithFormat:@"Generated boundary: %@, for content body: %@\n",
                           boundary, body]),
      BV_PRODUCT_CONVERSATIONS);

  // create request
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];
  NSString *contentType =
      [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
  [request setValue:[NSString
                        stringWithFormat:@"%lu", (unsigned long)[body length]]
      forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:body];

  return request;
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSString *passKey =
      [BVSDKManager sharedManager].configuration.apiKeyConversations;
  NSString *photoContentType = [self photoContentTypeToString];
  NSData *photoData = [self nsDataForPhoto];
  return @{
    @"apiversion" : @"5.4",
    @"passkey" : passKey,
    @"contenttype" : photoContentType,
    @"photo" : photoData
  };
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVPhotoSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVPhotoSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  return nil;
}

@end
