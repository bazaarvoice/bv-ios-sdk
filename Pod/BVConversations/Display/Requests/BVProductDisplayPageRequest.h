//
//  ProductDisplayPageRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsRequest.h"
#import "PDPContentType.h"
#import "BVSortOptionReviews.h"
#import "BVSortOptionQuestions.h"
#import "BVSortOptionAnswers.h"
#import "BVSort.h"
#import "PDPInclude.h"

/*
 You can retrieve all information needed for a Product Display Page with this request.
 Optionally, you can include `Reviews` or `QuestionsAndAnswers` as well as statistics on 
 reviews and questions and answers.
 Optionally, you can filter and sort the questions using the `addSort*` and `addFilter*` methods.
 */
@interface BVProductDisplayPageRequest : BVConversationsRequest

- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId;
- (nonnull instancetype) __unavailable init;

- (nonnull instancetype)includeContent:(PDPContentType)contentType limit:(int)limit;
- (nonnull instancetype)includeStatistics:(PDPContentType)contentType;
- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option order:(BVSortOrder)order;
- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option order:(BVSortOrder)order;
- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option order:(BVSortOrder)order;

- (void)load:(ProductRequestCompletionHandler _Nonnull)success failure:(ConversationsFailureHandler _Nonnull)failure;

- (NSString * _Nonnull)endpoint;
- (NSMutableArray * _Nonnull)createParams;
- (NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics;
- (NSString* _Nonnull)includesToParams:(NSArray<PDPInclude*>* _Nonnull)includes;


@end
