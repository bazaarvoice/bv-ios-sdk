//
//  BVSubmittedFeedback.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVFeedbackInappropriateResponse : NSObject

-(nullable instancetype)initWithFeedbackResponse:(nullable id)feedbackDict;

@property NSString * _Nonnull authorId;
@property NSString * _Nonnull reasonText;
    
@end

@interface BVFeedbackHelpfulnessResponse : NSObject

-(nullable instancetype)initWithFeedbackResponse:(nullable id)feedbackDict;

@property NSString * _Nonnull authorId;
@property NSString * _Nonnull vote;

@end


@interface BVSubmittedFeedback : NSObject

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@property BVFeedbackInappropriateResponse * _Nonnull inappropriateResponse;
@property BVFeedbackHelpfulnessResponse * _Nonnull helpfulnessResponse;

@end
