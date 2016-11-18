//
//  BVSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVConversationsRequest.h"

@interface BVSubmission : NSObject

-(void)sendError:(nonnull NSError*)error failureCallback:(nonnull ConversationsFailureHandler)failure;
-(void)sendErrors:(nonnull NSArray<NSError*>*)errors failureCallback:(nonnull ConversationsFailureHandler)failure;
-(nonnull NSData *)transformToPostBody:(nonnull NSDictionary *)parameters;

@end
