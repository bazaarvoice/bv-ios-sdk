//
//  BVReviewHighlightsReview.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface BVReviewHighlightsReview : NSObject

@property(nullable) NSNumber *rating;
@property(nullable) NSString *about;
@property(nullable) NSString *reviewText;
@property(nullable) NSString *author;
@property(nullable) NSString *snippetId;
@property(nullable) NSString *reviewId;
@property(nullable) NSString *summary;
@property(nullable) NSString *submissionTime;
@property(nullable) NSString *reviewTitle;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

