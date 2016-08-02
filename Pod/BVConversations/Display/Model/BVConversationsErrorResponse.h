//
//  ConversationsErrorResponse.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The API request reached the server successfully, but error(s) occured in the server. See the errors returned from `toNSError`
 to debug this failure.
 Typically, this happens when the `apiKeyConversations` is set incorrectly, or invalid parameters are attached to a request.
 For example: a `BVReviewsRequest` object with a limit of 400 is invalid (max of 20) and will return with an error in this class.
 */
@interface BVConversationsErrorResponse : NSObject

-(id _Nullable)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;
-(NSArray<NSError*>* _Nonnull)toNSErrors;

@end
