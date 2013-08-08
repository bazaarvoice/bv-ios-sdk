//
//  BVNetwork.h
//  BazaarvoiceSDK
//
//  Single entrypoint for all networking code.  BVGet, BVPost and
//  BVMedia post leverage this class to make requests.  Should not
//  be client facing.
//
//  Created by Bazaarvoice Engineering on 11/27/12.
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
#import "BVDelegate.h"

// Header to include with all API requests to denote a mobile SDK request
#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V214"

@interface BVNetwork : NSObject<NSURLConnectionDataDelegate>

// The delegate to receive BVDelegate callbacks
@property (weak) id<BVDelegate> delegate;
// The BVGet/BVPost/BVMediaPost that is utilizing this network layer.
@property (strong) id sender;
// The URL that this request was sent to.  Is only available after the request has been sent.
@property (readonly) NSString *requestURL;

// Sets a parameter of the form key=value.  Only one value may exist for a particular key.
- (void)setUrlParameterWithName:(NSString *)name value:(id)value;
// Appends a parameter of the form key=value1,value2...
- (void)setUrlListParameterWithName:(NSString *)name value:(NSString *)value;
// Adds a parameter of the form key = value.  There may be more than one value for a particular key.
- (void)addUrlParameterWithName:(NSString *)name value:(NSString *)value;
// Adds a parameter of the form key_1=value, key_2 = value...
- (void)addNthUrlParameterWithName:(NSString *)name value:(NSString *)value;

// Sends a standard GET to an endpoint such as "reviews.json."  Sender is the request object that is
// later passed back to the client in BVDelegate callbacks.
- (void)sendGetWithEndpoint:(NSString *)endpoint sender:(id)sender;
// Sends a standard POST request to an endpoint such as "submitreview.json."  Sender is the request object that is
// later passed back to the client in BVDelegate callbacks.
- (void)sendPostWithEndpoint:(NSString *)endpoint sender:(id)sender;
// Sends a multipart POST request to an endpoint such as "uploadvideo.json"  Sender is the request object that is
// later passed back to the client in BVDelegate callbacks.
- (void)sendMultipartPostWithEndpoint:(NSString *)endpoint sender:(id)sender;

@end
