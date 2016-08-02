//
//  SecondaryRating.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A secondary rating value associated with a review.
 The definition of your secondary ratings (if any) are specific to your configuration.
 */
@interface BVSecondaryRating : NSObject

@property NSNumber* _Nullable value;
@property NSNumber* _Nullable valueRange;
@property NSString* _Nullable valueLabel;
@property NSString* _Nullable maxLabel;
@property NSString* _Nullable minLabel;
@property NSString* _Nullable label;
@property NSString* _Nullable displayType;
@property NSString* _Nullable identifier;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
