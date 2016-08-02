//
//  SubmissionErrorResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsError.h"
#import "BVFieldError.h"

/*
 The submission reached the Bazaarvoice server successfully but ultimately failed. This most commonly is caused
 by issues with validation. For example: a review with `reviewText` that is too short, or a review that is missing user information.
 */
@interface BVSubmissionErrorResponse : NSObject

@property bool hasErrors;

@property NSArray<BVConversationsError*>* _Nonnull errors;
@property NSArray<BVFieldError*>* _Nonnull fieldErrors;

@property NSString* _Nullable locale;
@property NSString* _Nullable submissionId;
@property NSNumber* _Nullable typicalHoursToPost;
@property NSString* _Nullable authorSubmissionToken;

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse;
-(nonnull NSArray<NSError*>*)toNSErrors;

@end
