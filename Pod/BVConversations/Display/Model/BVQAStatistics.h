//
//  QAStatistics.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVDimensionAndDistributionUtil.h"

/*
 Statistics about the Questions and Answers for a product.
 */
@interface BVQAStatistics : NSObject

@property NSNumber* _Nullable helpfulVoteCount;
@property NSNumber* _Nullable bestAnswerCount;
@property NSNumber* _Nullable totalAnswerCount;
@property NSNumber* _Nullable totalQuestionCount;
@property NSNumber* _Nullable featuredQuestionCount;
@property NSNumber* _Nullable featuredAnswerCount;

@property NSNumber* _Nullable questionHelpfulVoteCount;
@property NSNumber* _Nullable answerNotHelpfulVoteCount;
@property NSNumber* _Nullable questionNotHelpfulVoteCount;
@property NSNumber* _Nullable answerHelpfulVoteCount;

@property TagDistribution _Nullable tagDistribution;
@property ContextDataDistribution _Nullable contextDataDistribution;

@property NSDate* _Nullable firstQuestionTime;
@property NSDate* _Nullable lastQuestionTime;
@property NSDate* _Nullable firstAnswerTime;
@property NSDate* _Nullable lastAnswerTime;
@property NSDate* _Nullable lastQuestionAnswerTime;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
