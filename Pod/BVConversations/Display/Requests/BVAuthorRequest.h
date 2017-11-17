//
//  BVAuthorRequest.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVConversationsRequest.h"
#import "BVAuthorResponse.h"
#import "BVAuthorContentType.h"
#import "BVSortOptionReviews.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionAnswers.h"
#import "BVSort.h"

/** This class allow you to build request parameters and request a user profile (author) and accepted content (Reviews, Questions, Answers) the author has submitted. The request builder conforms to parameters described in https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/profiles/display#parameters */
@interface BVAuthorRequest : BVConversationsRequest

@property (readonly) NSString* _Nonnull authorId;

/// The id for the author's profile you are trying to fetch
- (nonnull instancetype)initWithAuthorId:(NSString * _Nonnull)authorId;

- (nonnull instancetype) __unavailable init;

/// Add the statistics for the content type. Call multiple times for more than one submission type.
- (nonnull instancetype)includeStatistics:(BVAuthorContentType)contentType;
/// The type of submitted content to include. Call once for each type of Reviews, Questions, Answers.
- (nonnull instancetype)includeContent:(BVAuthorContentType)contentType limit:(int)limit;

/// When Reviews are included in the response, optinally add one or more sort parameters.
- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option order:(BVSortOrder)order;
/// When Questions are included in the response, optinally add one or more sort parameters.
- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option order:(BVSortOrder)order;
/// When Answers are included in the response, optinally add one or more sort parameters.
- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option order:(BVSortOrder)order;

/// Make an asynch http request to fetch the Author's profile data. See the BVAuthorResponse model for available fields.
- (void)load:(void (^ _Nonnull)(BVAuthorResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure;

// internal use
- (NSString * _Nonnull)endpoint;
// internal use
- (NSMutableArray * _Nonnull)createParams;

@end
