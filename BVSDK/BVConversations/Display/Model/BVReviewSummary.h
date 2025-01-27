//
//  BVReviewSummary.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVReviewSummary_h
#define BVReviewSummary_h

#import <Foundation/Foundation.h>
#import "BVGenericConversationsResult.h"

@interface BVReviewSummary : BVGenericConversationsResult

@property(nullable) NSString *summary;
@property(nullable) NSString *type;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSString *disclaimer;
@property(nullable) NSNumber *status;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

#endif /* BVReviewSummary_h */
