//
//  BVStoreReviewSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVReviewSubmissionResponse.h"
#import "BVReviewSubmission.h"
#import "BVSubmissionAction.h"
#import "BVConversationsRequest.h"
#import "BVUploadablePhoto.h"

typedef void (^ReviewSubmissionCompletion)(BVReviewSubmissionResponse* _Nonnull response);


/**
 Class to use to submit a review on a store to the Bazaarvoice platform. Requires that you have set the apiKeyConversationsStore value in the BVSDKManager and client id before you begin using submission request.
 
 Of the many parameters possible on a BVStoreReviewSubmission, the ones needed for submission depend on your specific implementation.
 
 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations/reviews/submit/5_4
 
 @availability 4.2.0 and later
 */
@interface BVStoreReviewSubmission : BVReviewSubmission

/**
 Create a new BVStoreReviewSubmission.
 
 @param reviewTitle    The user-provided title of the review.
 @param reviewText     The user-provided body of the review.
 @param rating         The user-provided rating: 1-5.
 @param storeId        The store identifier that this review is associated with.
 */
-(nonnull instancetype)initWithReviewTitle:(nonnull NSString*)reviewTitle reviewText:(nonnull NSString*)reviewText rating:(NSUInteger)rating storeId:(nonnull NSString*)storeId;
-(nonnull instancetype) __unavailable init;


@end
