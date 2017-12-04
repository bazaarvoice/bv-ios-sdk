//
//  BVUploadableYouTubeVideo.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVUploadableYouTubeVideo : NSObject

- (nonnull instancetype)initWithVideoURL:(nonnull NSString *)url
                            videoCaption:(nullable NSString *)caption;

@property(nonnull, readonly) NSString *videoURL;
@property(nullable, readonly) NSString *videoCaption;

@end
