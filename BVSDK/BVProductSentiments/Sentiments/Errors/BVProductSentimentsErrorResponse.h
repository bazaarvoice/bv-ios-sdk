//
//  BVProductSentimentsErrorResponse.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductSentimentsErrorResponse_h
#define BVProductSentimentsErrorResponse_h

#import <Foundation/Foundation.h>

/*
 The API request reached the server successfully, but error(s) occured in the
 server. See the errors returned from `toNSError`
 to debug this failure.
 Typically, this happens when the `apiKeyConversations` is set incorrectly, or
 invalid parameters are attached to a request.
 For example: a `BVReviewsRequest` object with a limit of 400 is invalid (max of
 20) and will return with an error in this class.
 */
@interface BVProductSentimentsErrorResponse : NSObject

@property(nonnull) NSString *code;
@property(nonnull) NSString *type;
@property(nonnull) NSString *title;
@property(nonnull) NSString *detail;

- (nullable id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;
- (nonnull NSArray<NSError *> *)toNSErrors;

@end

#endif /* BVProductSentimentsErrorResponse_h */
