//
//  BVSettings.h
//  BazaarvoiceSDK
//
//  BVSettings is a singleton object which contains credentials
//  common to all API requests.  All BVGet, BVPost and BVMediaPost
//  requests will use the credentials stored in BVSettings.
// 
//  Created by Bazaarvoice Engineering on 2/21/12.
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

#define BV_API_VERSION @"5.4"

/*!
 BVSettings is a singleton object which contains credentials common to all API requests.
 
 All BVGet, BVPost and BVMediaPost requests will use the credentials stored in BVSettings.
 */
@interface BVSettings : NSObject {
    
}

/*! 
 Static accessor method.
 */
+ (BVSettings*) instance;
/*!
 This is the passkey assigned to the customer.
 */
@property (nonatomic, copy) NSString* passKey;
/*!
 The base url. This will be something like "reviews.<client_name>.bazaarvoice.com" or "reviews.<client_name>.com" for clients which have configured a CNAME to Bazaarvoice.
 */
@property (nonatomic, copy) NSString* baseURL;
/*!
 Boolean indicating whether this request should go to staging (true) or production (false).  Default is production (false).
 */
@property (nonatomic, assign) BOOL staging;
/*!
 Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a minimum timeout of 240 seconds for post requests.
 */
@property (nonatomic, assign) float timeout;

@end