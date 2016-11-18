//
//  BVSDKConstants.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#ifndef BVSDKConstants_h
#define BVSDKConstants_h

/// Provides the master version of the SDK.

#define BV_SDK_VERSION @"6.2.0"

/// Conversation SDK Version
#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V620"

/// Error domain for NSError results, when present.
#define BVErrDomain @"com.bvsdk.bazaarvoice"
#define SYSTEM_VERSION_IOS_10              ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)

#endif /* BVSDKConstants_h */
