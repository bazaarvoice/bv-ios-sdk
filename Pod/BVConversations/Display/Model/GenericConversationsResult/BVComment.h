//
//  BVComment.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVGenericConversationsResult.h"
#import "BVBadge.h"

@interface BVComment : NSObject<BVGenericConversationsResult>

@property (readonly) NSString* _Nullable title;
@property (readonly) NSString* _Nullable commentText;
@property (readonly) NSString* _Nullable reviewId;
@property (readonly) NSString* _Nullable commentId;
@property (readonly) NSString* _Nullable campaignId;

@property (readonly) NSString* _Nullable userNickname;
@property (readonly) NSString* _Nullable authorId;
@property (readonly) NSString* _Nullable userLocation;
@property (readonly) NSDate* _Nullable submissionTime;
@property (readonly) NSDate* _Nullable lastModeratedTime;
@property (readonly) NSDate* _Nullable lastModificationTime;

@property (readonly) NSString* _Nullable submissionId;
@property (readonly) NSNumber* _Nullable totalFeedbackCount;
@property (readonly) NSNumber* _Nullable totalPositiveFeedbackCount;
@property (readonly) NSNumber* _Nullable totalNegativeFeedbackCount;

@property (readonly) NSString* _Nullable contentLocale;

@property (readonly) NSArray<BVBadge*>* _Nonnull badges;

@property (readonly) BOOL isSyndicated;

@property (nonatomic, strong, readonly) BVConversationsInclude * _Nullable includes;


@end
