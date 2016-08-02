//
//  BVDelegate.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@class BVNetwork;

/*!
    BVDelegate is a protocol which notifies the client of API request status updates. Each request is guaranteed to result in one of either didReceiveResponse: or didFailToReceiveResponse:.  All BVPost or BVMediaPost requests will generate one or more didSendBodyData: callbacks.
 */
__deprecated_msg("BVDelegate has been deprecated and will be removed in a future release. To retreive content, use the following request objects: BVProductDisplayPageRequest, BVReviewsRequest, BVQuestionsRequest, BVBulkRatingsRequest. Please see the github documentation for recommended use of this SDK.")
@protocol BVDelegate <NSObject>

@optional
/*!
    Delegate callback for the case that the request is successful. Issued on main thread.
    @param response The deserialized response.
    @param request The object which generated the request.
 */
- (void) didReceiveResponse:(NSDictionary *)response forRequest:(id)request;


/*!
    Delegate callback to indicate that body data has been sent as part of this request.  This method will only be called for submission requests and will be called one or more times as the data is sent.
    @param bytesWritten The number of bytes written in this update.
    @param totalBytesSent The total number of bytes written for this entire request.
    @param totalBytesExpectedToSend The total number of bytes expected to be written as part of this request.
    @param request The object which generated the request.
 */
- (void) didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend forRequest:(id)request;


/*!
    Delegate callback for the case that the request fails. Issued on main thread.
    @param err Contains specifics about the error.
    @param request The object which generated the request.
 */
- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request;
@end

