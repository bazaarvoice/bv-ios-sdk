//
//  Video.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVVideo.h"
#import "BVNullHelper.h"

@implementation BVVideo

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  self = [super init];
  if (self) {
    if (apiResponse == nil) {
      return nil;
    }

    NSDictionary *apiObject = apiResponse;

    SET_IF_NOT_NULL(self.videoHost, apiObject[@"VideoHost"])
    SET_IF_NOT_NULL(self.caption, apiObject[@"Caption"])
    SET_IF_NOT_NULL(self.videoThumbnailUrl, apiObject[@"VideoThumbnailUrl"])
    SET_IF_NOT_NULL(self.videoId, apiObject[@"VideoId"])
    SET_IF_NOT_NULL(self.videoUrl, apiObject[@"VideoUrl"])
    SET_IF_NOT_NULL(self.videoIframeUrl, apiObject[@"VideoIframeUrl"])
  }
  return self;
}

@end
