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

@property NSString* _Nullable videoHost;
@property NSString* _Nullable caption;
@property NSString* _Nullable videoThumbnailUrl;
@property NSString* _Nullable videoId;
@property NSString* _Nullable videoUrl;
@property NSString* _Nullable videoIframeUrl;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
