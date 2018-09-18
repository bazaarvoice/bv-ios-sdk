//
//  BVConversationsRequest.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversations.h"
#import <Foundation/Foundation.h>

@interface BVConversationsRequest : NSObject

/**
 This method adds extra user provided query parameters to a
 submission request, and will be urlencoded.
 */
- (nonnull instancetype)addCustomDisplayParameter:(nonnull NSString *)parameter
                                        withValue:(nonnull NSString *)value;

- (void)
loadContent:(nonnull BVConversationsRequest *)request
 completion:(nonnull void (^)(NSDictionary *__nonnull response))completion
    failure:(nonnull void (^)(NSArray<NSError *> *__nonnull errors))failure;

@end
