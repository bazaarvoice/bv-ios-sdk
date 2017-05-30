//
//  BVSubmittedComment.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVSubmittedComment : NSObject

@property (readonly) NSString* _Nullable commentText;
@property (readonly) NSString* _Nullable title;
@property (readonly) BOOL sendEmailAlertWhenAnswered;
@property (readonly) NSDate* _Nullable submissionTime;
@property (readonly) NSNumber* _Nullable typicalHoursToPost;
@property (readonly) NSString* _Nullable submissionId;
@property (readonly) NSString* _Nullable commentId;

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
