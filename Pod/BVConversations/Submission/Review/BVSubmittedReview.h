//
//  SubmittedReview.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVSubmittedReview : NSObject

@property NSString* _Nullable title;
@property NSString* _Nullable reviewText;
@property NSNumber* _Nullable rating;
@property NSString* _Nullable reviewId;

@property NSString* _Nullable submissionId;
@property NSDate* _Nullable submissionTime;

@property NSNumber* _Nullable isRecommended;
@property NSNumber* _Nullable sendEmailAlertWhenCommented;
@property NSNumber* _Nullable sendEmailAlertWhenPublished;

@property NSNumber* _Nullable typicalHoursToPost;

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
