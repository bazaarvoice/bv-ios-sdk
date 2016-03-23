//
//  BVCurationsPhotoUploader.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "BVCurationsAddPostRequest.h"

typedef void (^uploadCompletionHandler)(void);
typedef void (^uploadErrorHandler)(NSError *);

/*!
 API for posting Custom Content to Curations.
 */
@interface BVCurationsPhotoUploader : NSObject

/*! 
 This call wraps the Curations "Custom Post" API. Besides having your client ID and Curations API configured in the BVSDKManager, all you need to do is use one of the initializers in the BVCurationsAddPostRequest and make the API call.
 
 @param postParams - A valid initialized BVCurationsAddPostRequest object.
 @param completionHandler - Only called when a custom post has succeeded. This handler contains no parameters and is invoked on the main thread.
 @param failureHanler - Called when there is an API failure of some kind. Error code and error text are returned in an NSError object. This handler is invoked on the main thread.
 */
- (void)submitCurationsContentWithParams:(BVCurationsAddPostRequest *)postParams
                       completionHandler:(uploadCompletionHandler)completionHandler
                             withFailure:(uploadErrorHandler)failureHandler;

@end
