//
//  BVSubmittedReview.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted review.
@interface BVSubmittedReview : NSObject

@property(nullable) NSString *title;
@property(nullable) NSString *reviewText;
@property(nullable) NSNumber *rating;
@property(nullable) NSString *reviewId;

@property(nullable) NSString *submissionId;
@property(nullable) NSDate *submissionTime;

@property(nullable) NSNumber *isRecommended;
@property(nullable) NSNumber *sendEmailAlertWhenCommented;
@property(nullable) NSNumber *sendEmailAlertWhenPublished;

@property(nullable) NSNumber *typicalHoursToPost;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
