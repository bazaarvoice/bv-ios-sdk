//
//  SecondaryRating.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A secondary rating value associated with a review.
 The definition of your secondary ratings (if any) are specific to your
 configuration.
 */
@interface BVSecondaryRating : NSObject

@property(nullable) NSNumber *value;
@property(nullable) NSNumber *valueRange;
@property(nullable) NSString *valueLabel;
@property(nullable) NSString *maxLabel;
@property(nullable) NSString *minLabel;
@property(nullable) NSString *label;
@property(nullable) NSString *displayType;
@property(nullable) NSString *identifier;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
