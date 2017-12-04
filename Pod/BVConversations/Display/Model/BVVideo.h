//
//  Video.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A video attached to a review, question, or answer.
 */
@interface BVVideo : NSObject

@property(nullable) NSString *videoHost;
@property(nullable) NSString *caption;
@property(nullable) NSString *videoThumbnailUrl;
@property(nullable) NSString *videoId;
@property(nullable) NSString *videoUrl;
@property(nullable) NSString *videoIframeUrl;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
