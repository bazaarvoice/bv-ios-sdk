//
//  BVProductReview.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }


/// A product review written about a BVProduct
@interface BVProductReview : NSObject


/// Internal use
-(id)initWithDict:(NSDictionary*)dict;


/// Title of the review. Example: "Great product!", "Drains batteries too quickly."
@property (strong, nonatomic) NSString *reviewTitle;


/// Body text of the review.
@property (strong, nonatomic) NSString *reviewText;


/// The review author's name
@property (strong, nonatomic) NSString *reviewAuthorName;


@end
