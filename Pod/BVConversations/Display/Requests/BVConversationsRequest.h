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
#import "BVAuthorResponse.h"

typedef void (^ConversationsFailureHandler)(NSArray<NSError*>* _Nonnull errors);


/// Internal class - used only within BVSDK
@interface BVConversationsRequest : NSObject

-(NSMutableArray<BVStringKeyValuePair*>* _Nonnull)createParams;
-(NSString* _Nonnull)endpoint;
+(NSString* _Nonnull)commonEndpoint;

-(nonnull instancetype)addAdditionalField:(nonnull NSString*)fieldName value:(nonnull NSString*)value __deprecated_msg("use addCustomDisplayParameter instead.");

/**
 This method adds extra user provided query parameters to a
 submission request, and will be urlencoded.
 */
-(nonnull instancetype)addCustomDisplayParameter:(nonnull NSString*)parameter withValue:(nonnull NSString*)value;

- (void)loadContent:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(NSDictionary* _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError*>* _Nonnull errors))failure;
-(void)sendError:(nonnull NSError*)error failureCallback:(nonnull ConversationsFailureHandler)failure;
-(void)sendErrors:(nonnull NSArray<NSError*>*)errors failureCallback:(nonnull ConversationsFailureHandler)failure;

- (NSError * _Nonnull)limitError:(NSInteger)limit;
- (NSError * _Nonnull)tooManyProductsError:(NSArray<NSString *> * _Nonnull)productIds;

- (NSString * _Nonnull)getPassKey;

@end
