//
//  BVCurationsFeedLoader.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "BVCurations.h"
#import "BVCurationsFeedItem.h"
#import "BVCurationsFeedRequest.h"

@class BVCurationsFeedRequest;

typedef void (^feedRequestCompletionHandler)(
    NSArray<BVCurationsFeedItem *> *__nonnull);
typedef void (^feedRequestErrorHandler)(NSError *__nonnull);

/// API helper class used for fetching a curations feed with desired parameters
/// (BVCurationsFeedRequest)
@interface BVCurationsFeedLoader : NSObject

/**
    Fetch a curations feed.

    @param feedRequest The query string parameters object
    @param completionHandler Called on a successful response with an array of
   BVCurationsFeedItem objects. Called on main thread.
    @param failureHandler Called  with a filled out NSError object for any error
   that does not yeild a valid Curations feed. Called on main thread.
 */
- (void)loadFeedWithRequest:(nonnull BVCurationsFeedRequest *)feedRequest
          completionHandler:
              (nonnull feedRequestCompletionHandler)completionHandler
                withFailure:(nonnull feedRequestErrorHandler)failureHandler;

@end
