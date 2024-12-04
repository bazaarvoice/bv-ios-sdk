//
//  BVProductSentimentsErrorCode.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductSentimentsErrorCode_h
#define BVProductSentimentsErrorCode_h


/*
 Type of form error code
 */
typedef NS_ENUM(NSInteger, BVProductSentimentsErrorCode) {
    BVProductSentimentsErrorCodeNoContent,
    BVProductSentimentsErrorCodeBadRequest,
    BVProductSentimentsErrorCodeAccessDenied,
    BVProductSentimentsErrorCodeRequestLimitReached,
    BVProductSentimentsErrorCodeUnknown
};

#endif /* BVProductSentimentsErrorCode_h */
