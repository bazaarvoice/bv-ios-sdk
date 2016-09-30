//
//  SubmissionResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Common information shared between submission response objects.
 */
@interface BVSubmissionResponse : NSObject

@property NSString* _Nullable locale;
@property NSString* _Nullable submissionId;
@property NSNumber* _Nullable typicalHoursToPost;
@property NSString* _Nullable authorSubmissionToken;

@property NSDictionary * _Nullable formFields;

-(nonnull instancetype)initWithApiResponse:(nonnull NSDictionary*)apiResponse;

@end
