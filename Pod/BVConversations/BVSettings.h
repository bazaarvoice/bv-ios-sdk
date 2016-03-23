//
//  BVSettings.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "BVCore.h"

#define BV_API_VERSION @"5.4" // Conversations API versions

/*!
    BVSettings is a singleton object which contains credentials common to all API requests.
 
    All BVGet, BVPost and BVMediaPost requests will use the credentials stored in BVSettings.
 */
@interface BVSettings : NSObject


/// Static accessor method.
+ (BVSettings*) instance  __deprecated_msg("Use `BVSDKManager to init the Converations API`");


/// This is the passkey assigned to the customer.
@property (nonatomic, copy) NSString* passKey __deprecated_msg("Use `BVSDKManager to init the Converations API`");


/// The client's identifier. This should be the same as the <client_name> in the baseURL.
@property (nonatomic, copy) NSString* clientId __deprecated_msg("Use `BVSDKManager to init the Converations API`");


/// Boolean indicating whether this request should go to staging (true) or production (false).  Default is production (false).
@property (nonatomic, assign) BOOL staging __deprecated_msg("Use `BVSDKManager to init the Converations API`");

 
/// Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a minimum timeout of 240 seconds for post requests.
@property (nonatomic, assign) float timeout __deprecated_msg("Use `BVSDKManager to init the Converations API`");


/// Set the log level for getting analytic event info. Default is BVLogLevel.kBVLogLevelError
-(void)setLogLevel:(BVLogLevel)logLevel __deprecated_msg("Use `BVSDKManager to init the Converations API`");

@end