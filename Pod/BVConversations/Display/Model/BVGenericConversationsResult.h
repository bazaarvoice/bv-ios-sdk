//
//  GenericConversationsResult.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

@class BVConversationsInclude;

/// Internal protocol - used only within BVSDK
@protocol BVGenericConversationsResult

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse includes:(BVConversationsInclude* _Nullable)includes;

@end
