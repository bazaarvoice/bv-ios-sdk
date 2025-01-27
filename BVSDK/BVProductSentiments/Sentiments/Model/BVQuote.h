//
//  BVQuote.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVQuote_h
#define BVQuote_h

#import "BVProductSentimentsResult.h"

@interface BVQuote : BVProductSentimentsResult

@property(nullable) NSString *quoteID;
@property(nullable) NSString *text;
@property(nullable) NSString *emotion;
@property(nullable) NSNumber *reviewRating;
@property(nullable) NSString *reviewID;
@property(nullable) NSString *reviewedAt;
@property(nullable) NSString *translatedText;
@property(nullable) NSString *nativeLanguage;
@property(nullable) NSNumber *incentivised; //Boolean
@property(nullable) NSString *reviewType;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

#endif /* BVQuote_h */
