//
//  BVUploadableYouTubeVideo.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVUploadableYouTubeVideo.h"

@implementation BVUploadableYouTubeVideo

- (nonnull instancetype)initWithVideoURL:(nonnull NSString *)url
                            videoCaption:(nullable NSString *)caption {
  if ((self = [super init])) {
    _videoURL = url;
    _videoCaption = caption;
  }
  return self;
}

@end
