//
//  BVVideoSubmission.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVVideoSubmission.h"
#import "BVConversationsRequest+Private.h"
#import "BVConversationsRequest.h"
#import "BVLogger+Private.h"
#import "BVMultiPart+NSURLRequest.h"
#import "BVNetworkingManager.h"
#import "BVVideoSubmissionErrorResponse.h"
#import "BVVideoSubmissionResponse.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVSubmission+Private.h"
#import "BVSubmissionErrorResponse.h"

static NSUInteger const MAX_VIDEO_BYTES = 250 * 1024 * 1024; /// BV API max is 250MB

@interface BVVideoSubmission ()

@property(nonnull, readwrite) NSString *video;
@property(readwrite) BVVideoContentType videoContentType;

@end

@implementation BVVideoSubmission


- (nonnull instancetype)initWithVideo:(nonnull NSString *)video videoContentType:(BVVideoContentType)videoContentType {
    if ((self = [super init])) {
      self.video = video;
      self.videoContentType = videoContentType;
      self.maxVideoBytes = MAX_VIDEO_BYTES;
    }
    return self;
}

- (NSString *)videoContentTypeToString {
    switch (self.videoContentType) {
        case BVVideoContentTypeReview:
            return @"review";
    }
}


- (nullable NSData *)nsDataForVideo {
    @try {
        NSData *videoData = [NSData dataWithContentsOfFile: self.video];
        if (videoData && videoData.length < self.maxVideoBytes) {
            return videoData;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return nil;
}

- (nonnull NSString *)endpoint {
  return @"uploadvideo.json";
}

- (nonnull NSString *)getFileName {
  return self.video.lastPathComponent;
}

- (nonnull NSURLRequest *)generateRequest {
  NSDictionary *parameters = [self createSubmissionParameters];

  NSString *urlString = [NSString
      stringWithFormat:@"%@%@", [BVSubmission commonEndpoint], [self endpoint]];
  NSURL *url = [NSURL URLWithString:urlString];

  /// add multipart form data
  NSMutableData *body = [NSMutableData data];
  NSString *boundary = [NSURLRequest generateBoundaryWithData:body
                                         andFileName:[self getFileName]
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
  NSString *videoContentType = [self videoContentTypeToString];
  NSData *videoData = [self nsDataForVideo];
  return @{
    @"apiversion" : @"5.4",
    @"passkey" : passKey,
    @"contenttype" : videoContentType,
    @"video" : videoData
  };
}
          
- (void)upload:(__strong BVVideoSubmissionUploadCompletion)success failure:(__strong ConversationsFailureHandler)failure {
    
    [self submit:^(BVSubmissionResponse<BVSubmittedVideo *> *_Nonnull response) {
        
        NSString *videoUrl = response.result.video.videoUrl;
        
        success(videoUrl);
    }
     
         failure:^(NSArray<NSError *> *__nonnull errors) {
             failure(errors);
         }];
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVVideoSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVVideoSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  return nil;
}

@end
