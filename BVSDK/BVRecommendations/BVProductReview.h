//
//  BVProductReview.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A product review written about a BVRecommendedProduct
@interface BVProductReview : NSObject

/// Title of the review. Example: "Great product!", "Drains batteries too
/// quickly."
@property(strong, nonatomic) NSString *reviewTitle;

/// Body text of the review.
@property(strong, nonatomic) NSString *reviewText;

/// The review author's name
@property(strong, nonatomic) NSString *reviewAuthorName;

@end
