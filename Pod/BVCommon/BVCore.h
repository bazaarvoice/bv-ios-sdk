//
//  BVCore.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVCore_h
#define BVCore_h

#include "BVSDKManager.h"
#include "BVLogger.h"
#include "BVAnalyticsManager.h"
#include "BVAuthenticatedUser.h"

/**
 *  Provides the master version of the SDK.
 */
#define BV_SDK_VERSION @"3.2.0"

// Conversation SDK Version
#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V320"

/**
 *  Error domain for NSError results, when present.
 *
 */
#define BVErrDomain @"com.bvsdk.bazaarvoice"

#endif /* BVCore_h */
