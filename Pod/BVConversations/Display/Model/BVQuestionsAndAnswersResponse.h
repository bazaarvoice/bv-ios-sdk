//
//  QuestionsAndAnswersResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseConversationsResponse.h"
#import "BVQuestion.h"
#import "BVResponse.h"
#import <Foundation/Foundation.h>
/*
 A response to a `BVQuestionsAndAnswersRequest`. Contains one or multiple (up to
 20) `BVQuestion` objects in the `results` array.
 Contains other response information like the current index of pagination
 (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVQuestionsAndAnswersResponse
    : BVBaseConversationsResultsResponse <BVQuestion *>

@end
