//
//  BVProductSentimentsResponse.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductSentimentsResponse_h
#define BVProductSentimentsResponse_h

#import <Foundation/Foundation.h>

@class BVProductSentimentsResult;
@interface BVProductSentimentsResponse <__covariant ResultType : BVProductSentimentsResult *> : NSObject

//@property(nullable) NSDictionary *formFields;
//
@property(nonnull) ResultType result;

- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end

#endif /* BVProductSentimentsResponse_h */
