//
//  BVSettings.h
//  BazaarvoiceSDK
//  
//  Created by Bazaarvoice Engineering on 2/21/12.
//  Copyright (c) 2012 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

#define BV_API_VERSION @"5.4"

/*!
 BVSettings is a singleton object which contains credentials common to all API requests.
 
 All BVGet, BVPost and BVMediaPost requests will use the credentials stored in BVSettings.
 */
@interface BVSettings : NSObject

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
 The client's identifier. This should be the same as the <client_name> in the baseURL.
 */
@property (nonatomic, copy) NSString* clientId;

/*!
 The name of the application. For example: "Test Shopping App"
 */
@property (nonatomic, copy) NSString* appName;

/*!
 Boolean indicating whether this request should go to staging (true) or production (false).  Default is production (false).
 */
@property (nonatomic, assign) BOOL staging;
/*!
 Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a minimum timeout of 240 seconds for post requests.
 */
@property (nonatomic, assign) float timeout;

@end