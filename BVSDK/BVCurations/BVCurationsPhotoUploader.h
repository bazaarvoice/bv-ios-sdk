//
//  BVCurationsPhotoUploader.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "BVCurationsAddPostRequest.h"

__attribute__ ((deprecated))
typedef void (^uploadCompletionHandler)(void);

__attribute__ ((deprecated))
typedef void (^uploadErrorHandler)(NSError *__nonnull);

/*!
 API for posting Custom Content to Curations.
 */
__attribute__ ((deprecated))
@interface BVCurationsPhotoUploader : NSObject

/*!
 This call wraps the Curations "Custom Post" API. Besides having your client ID
 and Curations API configured in the BVSDKManager, all you need to do is use one
 of the initializers in the BVCurationsAddPostRequest and make the API call.

 @param postParams - A valid initialized BVCurationsAddPostRequest object.
 @param completionHandler - Only called when a custom post has succeeded. This
 handler contains no parameters and is invoked on the main thread.
 @param failureHandler - Called when there is an API failure of some kind. Error
 code and error text are returned in an NSError object. This handler is invoked
 on the main thread.
 */
- (void)submitCurationsContentWithParams:
            (nullable BVCurationsAddPostRequest *)postParams
                       completionHandler:
                           (nonnull uploadCompletionHandler)completionHandler
                             withFailure:
                                 (nonnull uploadErrorHandler)failureHandler;

@end
