//
//  ConversationsRequest.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVStringKeyValuePair.h"
#import "BVReviewsResponse.h"
#import "BVProductsResponse.h"
#import "BVQuestionsAndAnswersResponse.h"
#import "BVBulkRatingsResponse.h"

typedef void (^ReviewRequestCompletionHandler)(BVReviewsResponse* _Nonnull response);
typedef void (^ProductRequestCompletionHandler)(BVProductsResponse* _Nonnull response);
typedef void (^BulkRatingsSuccessHandler)(BVBulkRatingsResponse* _Nonnull response);
typedef void (^QuestionsAndAnswersSuccessHandler)(BVQuestionsAndAnswersResponse* _Nonnull response);
typedef void (^ConversationsFailureHandler)(NSArray<NSError*>* _Nonnull errors);

/// Internal class - used only within BVSDK
@interface BVConversationsRequest : NSObject

-(NSMutableArray<BVStringKeyValuePair*>* _Nonnull)createParams;
-(NSString* _Nonnull)endpoint;
+(NSString* _Nonnull)commonEndpoint;

- (void)loadReviews:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVReviewsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure;
- (void)loadProducts:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVProductsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure;
- (void)loadQuestions:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVQuestionsAndAnswersResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure;
- (void)loadBulkRatings:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVBulkRatingsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure;

-(void)sendError:(nonnull NSError*)error failureCallback:(nonnull ConversationsFailureHandler)failure;
-(void)sendErrors:(nonnull NSArray<NSError*>*)errors failureCallback:(nonnull ConversationsFailureHandler)failure;

- (NSError * _Nonnull)limitError:(NSInteger)limit;
- (NSError * _Nonnull)tooManyProductsError:(NSArray<NSString *> * _Nonnull)productIds;





@end
