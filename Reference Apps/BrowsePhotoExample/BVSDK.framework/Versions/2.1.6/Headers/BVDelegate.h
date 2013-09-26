//
//  BVDelegate.h
//  BazaarvoiceSDK
//
//  BVDelegate is a protocol which notifies the client of API
//  request status updates. Each request is guaranteed to result
//  in one of either didReceiveResponse: or didFailToReceiveResponse:.
//  All BVPost or BVMediaPost requests will generate one or more
//  didSendBodyData: callbacks.
//
//  Created by Bazaarvoice Engineering on 11/26/12.
//
//  Copyright 2013 Bazaarvoice, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

@class BVNetwork;

/*!
 BVDelegate is a protocol which notifies the client of API request status updates. Each request is guaranteed to result in one of either didReceiveResponse: or didFailToReceiveResponse:.  All BVPost or BVMediaPost requests will generate one or more didSendBodyData: callbacks.
 */
@protocol BVDelegate <NSObject>

@optional
/*!
 Delegate callback for the case that the request is successful.
 @param response The deserialized response.
 @param request The object which generated the request.
 */
- (void) didReceiveResponse:(NSDictionary *)response forRequest:(id)request;
/*!
 Delegate callback to indicate that body data has been sent as part of this request.  This method will only be called for submission requests and will be called one or more times as the data is sent.
 @param bytesWritten The number of bytes written in this update.
 @param totalBytesWritten The total number of bytes written for this entire request.
 @param totalBytesExpectedToWrite The total number of bytes expected to be written as part of this request.
 @param request The object which generated the request.
 */
- (void) didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite forRequest:(id)request;

/*!
 Delegate callback for the case that the request fails.
 @param err Contains specifics about the error.
 @param request The object which generated the request.
 */
- (void) didFailToReceiveResponse:(NSError*)err forRequest:(id)request;
@end

