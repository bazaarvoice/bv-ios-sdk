//
//  BVReviewTokens.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

/*
 A Bazaarvoice Review Tokens Data. Generally, this is extra information
 collected when a user
 submitted a review, question, or answer.
 A common Context Data Value is "Age" and "Gender".
 */
@interface BVReviewTokens : NSObject

@property(nullable) NSNumber *status;
@property(nullable) NSString *type;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nonnull) NSArray<NSString *> *data;

- (nonnull id)initWithApiResponse:(nonnull id)apiResponse;

@end
