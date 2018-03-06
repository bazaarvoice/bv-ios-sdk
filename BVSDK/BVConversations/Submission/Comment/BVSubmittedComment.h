//
//  BVSubmittedComment.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVSubmittedComment : NSObject

@property(nullable, readonly) NSString *commentText;
@property(nullable, readonly) NSString *title;
@property(readonly) BOOL sendEmailAlertWhenAnswered;
@property(nullable, readonly) NSDate *submissionTime;
@property(nullable, readonly) NSNumber *typicalHoursToPost;
@property(nullable, readonly) NSString *submissionId;
@property(nullable, readonly) NSString *commentId;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
