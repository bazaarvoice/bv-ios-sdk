//
//  BVCore.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVCore_h
#define BVCore_h

#include "BVSDKManager.h"
#include "BVLogger.h"
#include "BVAnalyticsManager.h"
#include "BVPixel.h"
#include "BVAuthenticatedUser.h"

/// Provides the master version of the SDK.
#define BV_SDK_VERSION @"4.0.3"

/// Conversation SDK Version
#define SDK_HEADER_NAME @"X-UA-BV-SDK"
#define SDK_HEADER_VALUE @"IOS_SDK_V403"

/// Error domain for NSError results, when present.
#define BVErrDomain @"com.bvsdk.bazaarvoice"

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }


#endif
