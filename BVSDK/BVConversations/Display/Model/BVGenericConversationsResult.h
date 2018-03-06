//
//  GenericConversationsResult.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

@class BVConversationsInclude;

/// Internal protocol - used only within BVSDK
@protocol BVGenericConversationsResult

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse
                         includes:(nullable BVConversationsInclude *)includes;

@end
