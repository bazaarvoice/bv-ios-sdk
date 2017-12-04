//
//  QAStatistics.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionAndDistributionUtil.h"
#import <Foundation/Foundation.h>

/*
 Statistics about the Questions and Answers for a product.
 */
@interface BVQAStatistics : NSObject

@property(nullable) NSNumber *helpfulVoteCount;
@property(nullable) NSNumber *bestAnswerCount;
@property(nullable) NSNumber *totalAnswerCount;
@property(nullable) NSNumber *totalQuestionCount;
@property(nullable) NSNumber *featuredQuestionCount;
@property(nullable) NSNumber *featuredAnswerCount;

@property(nullable) NSNumber *questionHelpfulVoteCount;
@property(nullable) NSNumber *answerNotHelpfulVoteCount;
@property(nullable) NSNumber *questionNotHelpfulVoteCount;
@property(nullable) NSNumber *answerHelpfulVoteCount;

@property(nullable) TagDistribution tagDistribution;
@property(nullable) ContextDataDistribution contextDataDistribution;

@property(nullable) NSDate *firstQuestionTime;
@property(nullable) NSDate *lastQuestionTime;
@property(nullable) NSDate *firstAnswerTime;
@property(nullable) NSDate *lastAnswerTime;
@property(nullable) NSDate *lastQuestionAnswerTime;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
