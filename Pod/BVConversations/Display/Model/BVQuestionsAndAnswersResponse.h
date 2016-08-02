//
//  QuestionsAndAnswersResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVResponse.h"
#import "BVQuestion.h"

/*
 A response to a `BVQuestionsAndAnswersRequest`. Contains one or multiple (up to 20) `BVQuestion` objects in the `results` array.
 Contains other response information like the current index of pagination (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVQuestionsAndAnswersResponse : NSObject<BVResponse>

@property NSNumber* _Nullable offset;
@property NSString* _Nullable locale;
@property NSArray<BVQuestion*>* _Nonnull results;
@property NSNumber* _Nullable totalResults;
@property NSNumber* _Nullable limit;

@end
