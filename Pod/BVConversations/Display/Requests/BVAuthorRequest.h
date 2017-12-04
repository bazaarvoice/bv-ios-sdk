//
//  BVAuthorRequest.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorContentType.h"
#import "BVAuthorResponse.h"
#import "BVConversationsRequest.h"
#import "BVSort.h"
#import "BVSortOptionAnswers.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionReviews.h"

/** This class allow you to build request parameters and request a user profile
 * (author) and accepted content (Reviews, Questions, Answers) the author has
 * submitted. The request builder conforms to parameters described in
 * https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/profiles/display#parameters
 */
@interface BVAuthorRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *authorId;

/// The id for the author's profile you are trying to fetch
- (nonnull instancetype)initWithAuthorId:(nonnull NSString *)authorId;

- (nonnull instancetype)__unavailable init;

/// Add the statistics for the content type. Call multiple times for more than
/// one submission type.
- (nonnull instancetype)includeStatistics:(BVAuthorContentType)contentType;
/// The type of submitted content to include. Call once for each type of
/// Reviews, Questions, Answers.
- (nonnull instancetype)includeContent:(BVAuthorContentType)contentType
                                 limit:(int)limit;

/// When Reviews are included in the response, optinally add one or more sort
/// parameters.
- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option
                                      order:(BVSortOrder)order;
/// When Questions are included in the response, optinally add one or more sort
/// parameters.
- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option
                                        order:(BVSortOrder)order;
/// When Answers are included in the response, optinally add one or more sort
/// parameters.
- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option
                                      order:(BVSortOrder)order;

/// Make an asynch http request to fetch the Author's profile data. See the
/// BVAuthorResponse model for available fields.
- (void)load:(nonnull void (^)(BVAuthorResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

// internal use
- (nonnull NSString *)endpoint;
// internal use
- (nonnull NSMutableArray *)createParams;

@end
